import { Request, Response } from 'express';
import Order, { STATUS, PAYMENTMETHOD } from './order.model';
import User from '../userModule/user.model';
import Product from '../productModule/product.model';
import ProductVariant from '../productModule/productVariant.model';
import ProductImage from '../productModule/productImage.model';
import Address from '../addressModule/address.model';
import Preference from '../userModule/preference.model';
import Cart from '../cartModel/cart.model';
import mongoose from 'mongoose';
import { sendMail } from '../utils/sendMail';

export const createOrder = async (req: Request, res: Response): Promise<void> => {
  try {

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
    const userExists = await User.findById(user).select('-password -token');
    if (!userExists) {
      res.status(404).json({ success: false, message: "User not found" });
      return;
    }

    // Check if user has email for order notifications
    if (!userExists.email) {
      res.status(400).json({
        success: false,
        message: "User must have an email address to place orders"
      });
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
      const { variantId, quantity } = productItem;
      const parsedQuantity = parseInt(quantity);

      // Validate product item fields
      if (!variantId || !parsedQuantity) {
        res.status(400).json({
          success: false,
          message: "Each product must have: variantId and quantity"
        });
        return;
      }

      // Validate variantId ObjectId
      if (!mongoose.Types.ObjectId.isValid(variantId)) {
        res.status(400).json({ success: false, message: `Invalid variant ID: ${variantId}` });
        return;
      }

      // Validate quantity
      if (isNaN(parsedQuantity) || parsedQuantity <= 0) {
        res.status(400).json({ success: false, message: "Quantity must be a positive number" });
        return;
      }

      // Get variant details first
      const variant = await ProductVariant.findById(variantId).populate('productObjectId');

      if (!variant) {
        res.status(404).json({
          success: false,
          message: `Product variant not found: ${variantId}`
        });
        return;
      }

      const product = variant.productObjectId;
      if (!product) {
        res.status(404).json({
          success: false,
          message: `Product not found for variant: ${variantId}`
        });
        return;
      }

      // Check availability status
      if (variant.available_status !== 'in_stock') {
        res.status(400).json({
          success: false,
          message: `Product variant is not available or out of stock for ${(product as any).name} (Size: ${variant.size})`
        });
        return;
      }

      // Check stock quantity
      if (variant.stock_qty && variant.stock_qty < parsedQuantity) {
        res.status(400).json({
          success: false,
          message: `Insufficient stock for ${(product as any).name}. Available: ${variant.stock_qty}, Requested: ${parsedQuantity}`
        });
        return;
      }

      // Debug: Log variant details
      console.log("Variant details:", {
        variantId: variant._id,
        productId: (product as any)._id,
        productName: (product as any).name,
        price: variant.price,
        priceType: typeof variant.price,
        size: variant.size,
        stock: variant.stock_qty
      });

      // Validate variant price
      const variantPrice = parseFloat(variant.price?.toString() || '0');
      if (isNaN(variantPrice) || variantPrice <= 0) {
        res.status(400).json({
          success: false,
          message: `Invalid variant price for ${(product as any).name} (Size: ${variant.size}). Price: ${variant.price}`
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
        product: (product as any)._id,
        variantId: variant._id,
        quantity: parsedQuantity,
        size: variant.size,
        status: STATUS.PENDING,
        price: itemPrice
      });

      // Update stock quantity and availability status
      const originalStock = variant.stock_qty || 0;
      console.log(`📦 Updating stock for ${(product as any).name} (Size: ${variant.size})`);
      console.log(`   - Original stock: ${originalStock}`);
      console.log(`   - Quantity ordered: ${parsedQuantity}`);
      
      if (variant.stock_qty !== undefined && variant.stock_qty !== null) {
        variant.stock_qty -= parsedQuantity;
        console.log(`   - New stock: ${variant.stock_qty}`);
        
        // Update availability status based on stock
        if (variant.stock_qty <= 0) {
          variant.available_status = 'out_of_stock';
          console.log(`   - Status updated to: out_of_stock`);
        }
        
        await variant.save();
        console.log(`   ✅ Stock updated successfully`);
      } else {
        console.log(`   ⚠️ Stock quantity not defined for this variant`);
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
      .populate('user', 'email phone_number')
      .populate('address');

    // Get product images for each order item (similar to cart API)
    const orderWithImages = await Promise.all(
      (populatedOrder as any).products.map(async (item: any) => {
        // Get images for this variant using variantId
        const images = await ProductImage.find({
          variantObjectid: item.variantId
        }).sort({ sort_order: 1 });

        // Get the primary image or first image
        const primaryImage = images.find(img => img.is_primary) || images[0];

        return {
          ...item.toObject(),
          image: primaryImage ? {
            _id: primaryImage._id,
            image: primaryImage.image,
            is_primary: primaryImage.is_primary,
            sort_order: primaryImage.sort_order
          } : null
        };
      })
    );

    // Send order confirmation email
    try {
      // Get user's name from preference
      const userPreference = await Preference.findOne({ user: userExists._id });
      const userName = userPreference?.username || userExists.email?.split('@')[0] || 'Customer';

      const productList = processedProducts.map((item: any, index) => {
        const product = (populatedOrder as any).products[index].product;
        return `- ${product.name} (Size: ${item.size}, Quantity: ${item.quantity}) - $${item.price.toFixed(2)}`;
      }).join('\n');

      await sendMail({
        to: userExists.email!,
        subject: `Order Confirmation - Order #${newOrder._id}`,
        text: `Dear ${userName},

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

    // Clear the user's cart after successful order creation
    try {
      const cartClearResult = await Cart.findOneAndUpdate(
        { user: user },
        { 
          items: [],
          subTotalAmount: 0,
          updatedAt: new Date()
        },
        { new: true }
      );
      
      if (cartClearResult) {
        console.log(`🛒 Cart cleared for user ${user} after order creation`);
      } else {
        console.log(`🛒 No cart found for user ${user}, creating empty cart`);
        // Create an empty cart if none exists
        await Cart.create({
          user: user,
          items: [],
          subTotalAmount: 0
        });
      }
    } catch (cartError) {
      console.error('Failed to clear cart after order creation:', cartError);
      // Don't fail the order creation if cart clearing fails
    }

    res.status(200).json({
      success: true,
      message: "Order created successfully",
      data: {
        ...populatedOrder?.toObject(),
        products: orderWithImages
      }
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
    const { orderId, productId, variantId, status, reason } = req.body;

    if (!orderId || !variantId || !status) {
      res.status(400).json({
        success: false,
        message: "Order ID, Variant ID, and status are required"
      });
      return;
    }

    // Validate ObjectIds
    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      res.status(400).json({ success: false, message: "Invalid order ID" });
      return;
    }

    if (!mongoose.Types.ObjectId.isValid(variantId)) {
      res.status(400).json({ success: false, message: "Invalid variant ID" });
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
      .populate("user", "email phone_number")
      .populate("products.product", "name");

    if (!order) {
      res.status(404).json({ success: false, message: "Order not found" });
      return;
    }

    // Find the specific product in the order using variantId
    const productIndex = (order as any).products.findIndex(
      (item: any) => item.variantId && item.variantId.toString() === variantId
    );

    if (productIndex === -1) {
      res.status(404).json({
        success: false,
        message: "Product variant not found in this order"
      });
      return;
    }

    const oldStatus = (order as any).products[productIndex].status;

    // Update product status
    (order as any).products[productIndex].status = status;

    await order.save();

    // Get order with images for response
    const orderWithImages = await Order.findById(orderId)
      .populate('products.product', 'name images price')
      .populate('user', 'email phone_number')
      .populate('address');

    // Add images to order's products (similar to cart API)
    const productsWithImages = await Promise.all(
      (orderWithImages as any).products.map(async (item: any) => {
        // Get images for this variant using variantId
        const images = await ProductImage.find({
          variantObjectid: item.variantId
        }).sort({ sort_order: 1 });

        // Get the primary image or first image
        const primaryImage = images.find(img => img.is_primary) || images[0];

        return {
          ...item.toObject(),
          image: primaryImage ? {
            _id: primaryImage._id,
            image: primaryImage.image,
            is_primary: primaryImage.is_primary,
            sort_order: primaryImage.sort_order
          } : null
        };
      })
    );

    const orderResponse = {
      ...(orderWithImages as any).toObject(),
      products: productsWithImages
    };

    // Send status update email
    try {
      const user = (order as any).user;
      const product = (order as any).products[productIndex].product;
      const productItem = (order as any).products[productIndex];

      // Only send email if user has email address
      if (user.email) {
        // Get user's name from preference
        const userPreference = await Preference.findOne({ user: user._id });
        const userName = userPreference?.username || user.email?.split('@')[0] || 'Customer';

        await sendMail({
          to: user.email,
          subject: `Order Status Update - Order #${(order as any)._id}`,
          text: `Dear ${userName},

Your order status has been updated!

Order ID: ${(order as any)._id}
Product: ${product.name} (Size: ${productItem.size})
Previous Status: ${oldStatus}
New Status: ${status}
${reason ? `Reason: ${reason}` : ''}

Best regards,
Your Shopping Team`
        });
      }
    } catch (emailError) {
      console.error('Failed to send status update email:', emailError);
    }

    res.status(200).json({
      success: true,
      message: `Product status updated from ${oldStatus} to ${status}`,
      data: orderResponse
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
    const { orderId, variantId, cancelReason } = req.body;

    if (!orderId || !variantId) {
      res.status(400).json({
        success: false,
        message: "Order ID and Variant ID are required"
      });
      return;
    }

    // Validate ObjectIds
    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      res.status(400).json({ success: false, message: "Invalid order ID" });
      return;
    }

    if (!mongoose.Types.ObjectId.isValid(variantId)) {
      res.status(400).json({ success: false, message: "Invalid variant ID" });
      return;
    }

    const order = await Order.findById(orderId)
      .populate("user", "email phone_number")
      .populate("products.product", "name");

    if (!order) {
      res.status(404).json({ success: false, message: "Order not found" });
      return;
    }

    // Find the specific product in the order using variantId
    const productIndex = (order as any).products.findIndex(
      (item: any) => item.variantId && item.variantId.toString() === variantId
    );

    if (productIndex === -1) {
      res.status(404).json({
        success: false,
        message: "Product variant not found in this order"
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

    // Restore stock using variantId
    let variant = null;

    if (productItem.variantId) {
      variant = await ProductVariant.findById(productItem.variantId);
    }

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

    // Get order with images for response
    const orderWithImages = await Order.findById(orderId)
      .populate('products.product', 'name images price')
      .populate('user', 'email phone_number')
      .populate('address');

    // Add images to order's products (similar to cart API)
    const productsWithImages = await Promise.all(
      (orderWithImages as any).products.map(async (item: any) => {
        // Get images for this variant using variantId
        const images = await ProductImage.find({
          variantObjectid: item.variantId
        }).sort({ sort_order: 1 });

        // Get the primary image or first image
        const primaryImage = images.find(img => img.is_primary) || images[0];

        return {
          ...item.toObject(),
          image: primaryImage ? {
            _id: primaryImage._id,
            image: primaryImage.image,
            is_primary: primaryImage.is_primary,
            sort_order: primaryImage.sort_order
          } : null
        };
      })
    );

    const orderResponse = {
      ...(orderWithImages as any).toObject(),
      products: productsWithImages
    };

    // Send cancellation email
    try {
      const user = (order as any).user;
      const product = productItem.product;

      // Only send email if user has email address
      if (user.email) {
        // Get user's name from preference
        const userPreference = await Preference.findOne({ user: user._id });
        const userName = userPreference?.username || user.email?.split('@')[0] || 'Customer';

        await sendMail({
          to: user.email,
          subject: `Product Cancelled - Order #${(order as any)._id}`,
          text: `Dear ${userName},

A product in your order has been cancelled.

Order ID: ${(order as any)._id}
Cancelled Product: ${product.name} (Size: ${productItem.size})
Reason: ${cancelReason || "No reason provided"}

Refund Amount: $${productItem.price.toFixed(2)}
New Order Total: $${(order as any).totalAmount.toFixed(2)}

If you didn't request this cancellation, please contact our support team.

Best regards,
Your Shopping Team`
        });
      }
    } catch (emailError) {
      console.error('Failed to send cancellation email:', emailError);
    }

    res.status(200).json({
      success: true,
      message: "Product cancelled successfully",
      data: orderResponse
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
      .populate('user', 'email phone_number')
      .populate('address')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parsedLimit);

    // Add images to each order's products (similar to cart API)
    const ordersWithImages = await Promise.all(
      orders.map(async (order: any) => {
        const productsWithImages = await Promise.all(
          order.products.map(async (item: any) => {
            // Get images for this variant using variantId
            const images = await ProductImage.find({
              variantObjectid: item.variantId
            }).sort({ sort_order: 1 });

            // Get the primary image or first image
            const primaryImage = images.find(img => img.is_primary) || images[0];

            return {
              ...item.toObject(),
              image: primaryImage ? {
                _id: primaryImage._id,
                image: primaryImage.image,
                is_primary: primaryImage.is_primary,
                sort_order: primaryImage.sort_order
              } : null
            };
          })
        );

        return {
          ...order.toObject(),
          products: productsWithImages
        };
      })
    );

    res.status(200).json({
      success: true,
      data: ordersWithImages,
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

    // Add images to each order's products (similar to cart API)
    const ordersWithImages = await Promise.all(
      orders.map(async (order: any) => {
        const productsWithImages = await Promise.all(
          order.products.map(async (item: any) => {
            // Get images for this variant using variantId
            const images = await ProductImage.find({
              variantObjectid: item.variantId
            }).sort({ sort_order: 1 });

            // Get the primary image or first image
            const primaryImage = images.find(img => img.is_primary) || images[0];

            return {
              ...item.toObject(),
              image: primaryImage ? {
                _id: primaryImage._id,
                image: primaryImage.image,
                is_primary: primaryImage.is_primary,
                sort_order: primaryImage.sort_order
              } : null
            };
          })
        );

        return {
          ...order.toObject(),
          products: productsWithImages
        };
      })
    );

    res.status(200).json({
      success: true,
      data: ordersWithImages,
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

// Get Orders by User ID (URL Params) - New API
// export const getOrdersByUserId = async (req: Request, res: Response): Promise<void> => {
//   try {
//     const { userId } = req.params;
//     const { page, limit, status } = req.query;

//     // Validate userId
//     if (!userId || !mongoose.Types.ObjectId.isValid(userId)) {
//       res.status(400).json({ success: false, message: "Valid user ID is required" });
//       return;
//     }

//     console.log(`📋 Getting orders for user ID: ${userId}`);

//     const parsedPage = parseInt(page as string) || 1;
//     const parsedLimit = parseInt(limit as string) || 10;
//     const skip = (parsedPage - 1) * parsedLimit;

//     // Build filter condition
//     let filterCondition: any = { user: userId };

//     // Add status filtering if provided
//     if (status && status !== 'all') {
//       // For individual product status filtering, we would need aggregation
//       // For now, keeping it simple without status filtering
//       console.log(`Status filter: ${status} (not implemented for individual products)`);
//     }

//     // Get total count
//     const total = await Order.countDocuments(filterCondition);

//     // Get user orders
//     const orders = await Order.find(filterCondition)
//       .populate('products.product', 'name images price')
//       .populate('address')
//       .sort({ createdAt: -1 })
//       .skip(skip)
//       .limit(parsedLimit);

//     console.log(`📊 Found ${orders.length} orders for user ${userId} (Total: ${total})`);

//     // Add images to each order's products (similar to cart API)
//     const ordersWithImages = await Promise.all(
//       orders.map(async (order: any) => {
//         const productsWithImages = await Promise.all(
//           order.products.map(async (item: any) => {
//             // Get images for this variant using variantId
//             const images = await ProductImage.find({
//               variantObjectid: item.variantId
//             }).sort({ sort_order: 1 });

//             // Get the primary image or first image
//             const primaryImage = images.find(img => img.is_primary) || images[0];

//             return {
//               ...item.toObject(),
//               image: primaryImage ? {
//                 _id: primaryImage._id,
//                 image: primaryImage.image,
//                 is_primary: primaryImage.is_primary,
//                 sort_order: primaryImage.sort_order
//               } : null
//             };
//           })
//         );

//         return {
//           ...order.toObject(),
//           products: productsWithImages
//         };
//       })
//     );

//     res.status(200).json({
//       success: true,
//       message: `Retrieved ${ordersWithImages.length} orders for user`,
//       data: ordersWithImages,
//       pagination: {
//         total,
//         currentPage: parsedPage,
//         totalPages: Math.ceil(total / parsedLimit),
//         limit: parsedLimit,
//       },
//       filters: {
//         status: status || 'all'
//       }
//     });

//   } catch (error) {
//     console.error("Error fetching user orders:", error);
//     res.status(500).json({
//       success: false,
//       message: "Something went wrong",
//       error: (error as Error).message,
//     });
//   }
// };

// Get Single Order by ID
export const getOrderById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { orderId } = req.params;

    // Validate orderId
    if (!mongoose.Types.ObjectId.isValid(orderId)) {
      res.status(400).json({ success: false, message: "Invalid order ID" });
      return;
    }

    // Fetch order with full details
    const order = await Order.findById(orderId)
      .populate('products.product', 'name price images description')
      .populate('user', 'email phone_number')
      .populate('address');

    if (!order) {
      res.status(404).json({ success: false, message: "Order not found" });
      return;
    }

    // Add images to order's products (similar to cart API)
    const productsWithImages = await Promise.all(
      (order as any).products.map(async (item: any) => {
        // Get images for this variant using variantId
        const images = await ProductImage.find({
          variantObjectid: item.variantId
        }).sort({ sort_order: 1 });

        // Get the primary image or first image
        const primaryImage = images.find(img => img.is_primary) || images[0];

        return {
          ...item.toObject(),
          image: primaryImage ? {
            _id: primaryImage._id,
            image: primaryImage.image,
            is_primary: primaryImage.is_primary,
            sort_order: primaryImage.sort_order
          } : null
        };
      })
    );

    const orderWithImages = {
      ...(order as any).toObject(),
      products: productsWithImages
    };

    res.status(200).json({
      success: true,
      data: orderWithImages
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

// Get Orders by User ID (REST endpoint with URL params)
export const getOrdersByUserIdParams = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.params;
    const { page, limit, status } = req.query;

    // Validate userId
    if (!userId || !mongoose.Types.ObjectId.isValid(userId)) {
      res.status(400).json({ success: false, message: "Valid user ID is required" });
      return;
    }

    const parsedPage = parseInt(page as string) || 1;
    const parsedLimit = parseInt(limit as string) || 10;
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

    // Add images to each order's products (similar to cart API)
    const ordersWithImages = await Promise.all(
      orders.map(async (order: any) => {
        const productsWithImages = await Promise.all(
          order.products.map(async (item: any) => {
            // Get images for this variant using variantId
            const images = await ProductImage.find({
              variantObjectid: item.variantId
            }).sort({ sort_order: 1 });

            // Get the primary image or first image
            const primaryImage = images.find(img => img.is_primary) || images[0];

            return {
              ...item.toObject(),
              image: primaryImage ? {
                _id: primaryImage._id,
                image: primaryImage.image,
                is_primary: primaryImage.is_primary,
                sort_order: primaryImage.sort_order
              } : null
            };
          })
        );

        return {
          ...order.toObject(),
          products: productsWithImages
        };
      })
    );

    res.status(200).json({
      success: true,
      data: ordersWithImages,
      pagination: {
        page: parsedPage,
        limit: parsedLimit,
        total,
        totalPages: Math.ceil(total / parsedLimit)
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
