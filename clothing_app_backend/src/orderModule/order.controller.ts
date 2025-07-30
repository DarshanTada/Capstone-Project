import { Request, Response } from 'express';
import Order, { STATUS, PAYMENTMETHOD } from './order.model';
import User from '../userModule/user.model';
import Product from '../productModule/product.model';
import ProductVariant from '../productModule/productVariant.model';
import Address from '../addressModule/address.model';
import mongoose from 'mongoose';
import { sendMail } from '../utils/sendMail';

export const createOrder = async (req: Request, res: Response): Promise<void> => {
  try {
    // Debug: Log the received request body
    console.log("Received request body:", req.body);
    console.log("Products type:", typeof req.body.products);
    console.log("Products value:", req.body.products);

    let {
      products,
      user,
      address,
      paymentMethod
    } = req.body;

    // Parse products if it's a JSON string (for form-data)
    if (typeof products === 'string') {
      try {
        products = JSON.parse(products);
        console.log("Parsed products:", products);
      } catch (parseError) {
        console.error("JSON parse error:", parseError);
        res.status(400).json({
          success: false,
          message: "Invalid products JSON format",
          error: (parseError as Error).message
        });
        return;
      }
    }

    // Validate required fields
    if (!products || !Array.isArray(products) || products.length === 0 || !user || !address) {
      console.log("Validation failed:", { products, user, address, productsIsArray: Array.isArray(products) });
      res.status(400).json({
        success: false,
        message: "All required fields must be provided: products array, user, address",
        received: {
          products: products ? (Array.isArray(products) ? `Array with ${products.length} items` : typeof products) : 'null/undefined',
          user: user || 'null/undefined',
          address: address || 'null/undefined'
        }
      });
      return;
    }

    // Validate ObjectIds
    if (!mongoose.Types.ObjectId.isValid(user)) {
      res.status(400).json({ success: false, message: "Invalid user ID" });
      return;
    }

    if (!mongoose.Types.ObjectId.isValid(address)) {
      res.status(400).json({ success: false, message: "Invalid address ID" });
      return;
    }

    // Check if user exists
    const userExists = await User.findById(user);
    if (!userExists) {
      res.status(404).json({ success: false, message: "User not found" });
      return;
    }

    // Check if address exists and belongs to user
    const addressExists = await Address.findById(address);
    if (!addressExists) {
      res.status(404).json({ success: false, message: "Address not found" });
      return;
    }

    if (String(addressExists.userId) !== String(user)) {
      res.status(403).json({ success: false, message: "Address does not belong to this user" });
      return;
    }

    // Process each product in the order
    const processedProducts = [];
    let totalAmount = 0;

    for (const productItem of products) {
      const { product, quantity, size } = productItem;
      const parsedQuantity = parseInt(quantity);

      // Validate product item fields
      if (!product || !parsedQuantity || !size) {
        res.status(400).json({
          success: false,
          message: "Each product must have: product ID, quantity, and size"
        });
        return;
      }

      // Validate product ObjectId
      if (!mongoose.Types.ObjectId.isValid(product)) {
        res.status(400).json({ success: false, message: `Invalid product ID: ${product}` });
        return;
      }

      // Validate quantity
      if (isNaN(parsedQuantity) || parsedQuantity <= 0) {
        res.status(400).json({ success: false, message: "Quantity must be a positive number" });
        return;
      }

      // Check if product exists
      const productExists = await Product.findById(product);
      if (!productExists) {
        res.status(404).json({ success: false, message: `Product not found: ${product}` });
        return;
      }

      // Debug: Log product details
      console.log("Product details:", {
        id: product,
        name: (productExists as any).name,
        price: (productExists as any).price,
        priceType: typeof (productExists as any).price
      });

      // Check if product variant with specified size exists and has enough stock
      const variant = await ProductVariant.findOne({ 
        productObjectId: product, 
        size: size.toLowerCase(),
        available_status: 'in_stock' 
      });

      if (!variant) {
        res.status(400).json({ 
          success: false, 
          message: `Product variant with size ${size} is not available or out of stock for ${productExists.name}` 
        });
        return;
      }

      if (variant.stock_qty && variant.stock_qty < parsedQuantity) {
        res.status(400).json({ 
          success: false, 
          message: `Insufficient stock for ${productExists.name}. Available: ${variant.stock_qty}, Requested: ${parsedQuantity}` 
        });
        return;
      }

      // Debug: Log variant details
      console.log("Variant details:", {
        variantId: variant._id,
        price: variant.price,
        priceType: typeof variant.price,
        size: variant.size,
        stock: variant.stock_qty
      });

      // Validate variant price (price comes from variant, not product)
      const variantPrice = parseFloat(variant.price?.toString() || '0');
      if (isNaN(variantPrice) || variantPrice <= 0) {
        res.status(400).json({ 
          success: false, 
          message: `Invalid variant price for ${(productExists as any).name} (Size: ${size}). Price: ${variant.price}` 
        });
        return;
      }

      // Calculate item price using variant price
      const itemPrice = variantPrice * parsedQuantity;
      totalAmount += itemPrice;

      console.log("Price calculation:", {
        variantPrice,
        parsedQuantity,
        itemPrice,
        totalAmount
      });

      processedProducts.push({
        product,
        quantity: parsedQuantity,
        size: size.toLowerCase(),
        status: STATUS.PENDING,
        price: itemPrice
      });

      // Update stock quantity
      if (variant.stock_qty) {
        variant.stock_qty -= parsedQuantity;
        if (variant.stock_qty <= 0) {
          variant.available_status = 'out_of_stock';
        }
        await variant.save();
      }
    }

    // Create order
    const newOrder = await Order.create({
      products: processedProducts,
      user,
      address,
      paymentMethod: paymentMethod || PAYMENTMETHOD.CREDITCARD,
      totalAmount
    });

    // Populate order details for response
    const populatedOrder = await Order.findById(newOrder._id)
      .populate('products.product', 'name price images')
      .populate('user', 'name email phone_number')
      .populate('address');

    // Send order confirmation email
    try {
      const productList = processedProducts.map((item: any, index) => {
        const product = (populatedOrder as any).products[index].product;
        return `- ${product.name} (Size: ${item.size}, Quantity: ${item.quantity}) - $${item.price.toFixed(2)}`;
      }).join('\n');

      await sendMail({
        to: userExists.email,
        subject: `Order Confirmation - Order #${newOrder._id}`,
        text: `Dear ${userExists.name || 'Customer'},

Your order has been successfully placed!

Order Details:
- Order ID: ${newOrder._id}
- Total Amount: $${totalAmount.toFixed(2)}

Products Ordered:
${productList}

Status: ${STATUS.PENDING}

We will send you updates as your order progresses.

Thank you for shopping with us!

Best regards,
Your Shopping Team`
      });
    } catch (emailError) {
      console.error('Failed to send order confirmation email:', emailError);
      // Don't fail the order creation if email fails
    }

    res.status(201).json({
      success: true,
      message: "Order created successfully",
      data: populatedOrder
    });

  } catch (error) {
    console.error("Error creating order:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

// Update Individual Product Status in Order
export const updateProductStatus = async (req: Request, res: Response): Promise<void> => {
  try {
    const { orderId, productId, status, reason } = req.body;

    if (!orderId || !productId || !status) {
      res.status(400).json({
        success: false,
        message: "Order ID, Product ID, and status are required"
      });
      return;
    }

    // Validate ObjectIds
    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      res.status(400).json({ success: false, message: "Invalid order ID" });
      return;
    }

    if (!mongoose.Types.ObjectId.isValid(productId)) {
      res.status(400).json({ success: false, message: "Invalid product ID" });
      return;
    }

    // Validate status
    if (!Object.values(STATUS).includes(status)) {
      res.status(400).json({
        success: false,
        message: `Invalid status. Valid statuses are: ${Object.values(STATUS).join(', ')}`
      });
      return;
    }

    const order = await Order.findById(orderId)
      .populate("user", "name email phone_number")
      .populate("products.product", "name");

    if (!order) {
      res.status(404).json({ success: false, message: "Order not found" });
      return;
    }

    // Find the specific product in the order
    const productIndex = (order as any).products.findIndex(
      (item: any) => item.product._id.toString() === productId
    );

    if (productIndex === -1) {
      res.status(404).json({
        success: false,
        message: "Product not found in this order"
      });
      return;
    }

    const oldStatus = (order as any).products[productIndex].status;

    // Update product status
    (order as any).products[productIndex].status = status;

    await order.save();

    // Send status update email
    try {
      const user = (order as any).user;
      const product = (order as any).products[productIndex].product;
      
      await sendMail({
        to: user.email,
        subject: `Order Status Update - Order #${(order as any)._id}`,
        text: `Dear ${user.name || 'Customer'},

Your order status has been updated!

Order ID: ${(order as any)._id}
Product: ${product.name}
Previous Status: ${oldStatus}
New Status: ${status}
${reason ? `Reason: ${reason}` : ''}

Best regards,
Your Shopping Team`
      });
    } catch (emailError) {
      console.error('Failed to send status update email:', emailError);
    }

    res.status(200).json({
      success: true,
      message: `Product status updated from ${oldStatus} to ${status}`,
      data: order
    });

  } catch (error) {
    console.error("Error updating product status:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

// Cancel Individual Product in Order
export const cancelProduct = async (req: Request, res: Response): Promise<void> => {
  try {
    const { orderId, productId, cancelReason } = req.body;

    if (!orderId || !productId) {
      res.status(400).json({
        success: false,
        message: "Order ID and Product ID are required"
      });
      return;
    }

    // Validate ObjectIds
    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      res.status(400).json({ success: false, message: "Invalid order ID" });
      return;
    }

    if (!mongoose.Types.ObjectId.isValid(productId)) {
      res.status(400).json({ success: false, message: "Invalid product ID" });
      return;
    }

    const order = await Order.findById(orderId)
      .populate("user", "name email phone_number")
      .populate("products.product", "name");

    if (!order) {
      res.status(404).json({ success: false, message: "Order not found" });
      return;
    }

    // Find the specific product in the order
    const productIndex = (order as any).products.findIndex(
      (item: any) => item.product._id.toString() === productId
    );

    if (productIndex === -1) {
      res.status(404).json({
        success: false,
        message: "Product not found in this order"
      });
      return;
    }

    const productItem = (order as any).products[productIndex];

    if (productItem.isCancelled) {
      res.status(400).json({
        success: false,
        message: "Product is already cancelled"
      });
      return;
    }

    // Only allow cancellation if not shipped or delivered
    if ([STATUS.SHIPPED, STATUS.DELIVERED].includes(productItem.status)) {
      res.status(400).json({
        success: false,
        message: "Cannot cancel shipped or delivered items"
      });
      return;
    }

    // Cancel the product
    productItem.status = STATUS.CANCELLED;
    productItem.isCancelled = true;
    productItem.cancelReason = cancelReason || "Cancelled by user";

    // Restore stock
    const variant = await ProductVariant.findOne({
      productObjectId: productId,
      size: productItem.size,
    });

    if (variant) {
      if (variant.stock_qty !== undefined) {
        variant.stock_qty = (variant.stock_qty ?? 0) + productItem.quantity;
      }
      
      if (variant.available_status === 'out_of_stock') {
        variant.available_status = 'in_stock';
      }
      
      await variant.save();
    }

    // Recalculate total amount
    (order as any).totalAmount = (order as any).products
      .filter((item: any) => !item.isCancelled)
      .reduce((total: number, item: any) => total + item.price, 0);

    await order.save();

    // Send cancellation email
    try {
      const user = (order as any).user;
      const product = productItem.product;
      
      await sendMail({
        to: user.email,
        subject: `Product Cancelled - Order #${(order as any)._id}`,
        text: `Dear ${user.name || 'Customer'},

A product in your order has been cancelled.

Order ID: ${(order as any)._id}
Cancelled Product: ${product.name}
Reason: ${cancelReason || "No reason provided"}

Refund Amount: $${productItem.price.toFixed(2)}
New Order Total: $${(order as any).totalAmount.toFixed(2)}

If you didn't request this cancellation, please contact our support team.

Best regards,
Your Shopping Team`
      });
    } catch (emailError) {
      console.error('Failed to send cancellation email:', emailError);
    }

    res.status(200).json({
      success: true,
      message: "Product cancelled successfully",
      data: order
    });

  } catch (error) {
    console.error("Error cancelling product:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};


// Get All Orders with filtering (Form Data)
export const getAllOrders = async (req: Request, res: Response): Promise<void> => {
  try {
    const { page, limit, status, userId } = req.body;

    const parsedPage = parseInt(page) || 1;
    const parsedLimit = parseInt(limit) || 10;
    const skip = (parsedPage - 1) * parsedLimit;

    // Build filter condition
    let filterCondition: any = {};

    // Note: Status filtering removed as overallStatus field no longer exists
    // Individual product status filtering can be implemented if needed

    if (userId && mongoose.Types.ObjectId.isValid(userId)) {
      filterCondition.user = userId;
    }

    // Get total count
    const total = await Order.countDocuments(filterCondition);

    // Get orders with pagination
    const orders = await Order.find(filterCondition)
      .populate('products.product', 'name images price')
      .populate('user', 'name email phone_number')
      .populate('address')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parsedLimit);

    res.status(200).json({
      success: true,
      data: orders,
      pagination: {
        total,
        currentPage: parsedPage,
        totalPages: Math.ceil(total / parsedLimit),
        limit: parsedLimit,
      },
      filters: {
        status: status || 'all',
        userId: userId || 'all'
      }
    });

  } catch (error) {
    console.error("Error fetching orders:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

// Get Orders by User ID (Form Data)
export const getOrdersByUserId = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId, page, limit, status } = req.body;

    // Validate userId
    if (!userId || !mongoose.Types.ObjectId.isValid(userId)) {
      res.status(400).json({ success: false, message: "Valid user ID is required" });
      return;
    }

    const parsedPage = parseInt(page) || 1;
    const parsedLimit = parseInt(limit) || 10;
    const skip = (parsedPage - 1) * parsedLimit;

    // Build filter condition
    let filterCondition: any = { user: userId };

    // Note: Status filtering removed as overallStatus field no longer exists
    // Individual product status filtering can be implemented if needed

    // Get total count
    const total = await Order.countDocuments(filterCondition);

    // Get user orders
    const orders = await Order.find(filterCondition)
      .populate('products.product', 'name images price')
      .populate('address')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parsedLimit);

    res.status(200).json({
      success: true,
      data: orders,
      pagination: {
        total,
        currentPage: parsedPage,
        totalPages: Math.ceil(total / parsedLimit),
        limit: parsedLimit,
      },
      filters: {
        status: status || 'all'
      }
    });

  } catch (error) {
    console.error("Error fetching user orders:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

// Get Single Order by ID
export const getOrderById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { orderId } = req.params;

    // Validate orderId
    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      res.status(400).json({ success: false, message: "Invalid order ID" });
      return;
    }

    // Get order with full details
    const order = await Order.findById(orderId)
      .populate('products.product', 'name price images description')
      .populate('user', 'name email phone_number gender age')
      .populate('address');

    if (!order) {
      res.status(404).json({ success: false, message: "Order not found" });
      return;
    }

    res.status(200).json({
      success: true,
      data: order
    });

  } catch (error) {
    console.error("Error fetching order:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};
