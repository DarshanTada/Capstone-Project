import { Request, Response } from 'express';
import Cart from './cart.model';
import User from '../userModule/user.model';
import Product from '../productModule/product.model';
import ProductVariant from '../productModule/productVariant.model';
import ProductImage from '../productModule/productImage.model';
import mongoose from 'mongoose';

// Add Product to Cart or Update Quantity
export const addToCart = async (req: Request, res: Response): Promise<void> => {
  try {
    // Debug: Log the received request body
    console.log("Received request body:", req.body);

    const { userId, variantId, quantity } = req.body;
    const parsedQuantity = parseInt(quantity);

    // Validate required fields
    if (!userId || !variantId || !quantity) {
      res.status(400).json({
        success: false,
        message: "All fields are required: userId, variantId, quantity"
      });
      return;
    }

    // Validate ObjectIds
    if (!mongoose.Types.ObjectId.isValid(userId)) {
      res.status(400).json({ success: false, message: "Invalid user ID" });
      return;
    }

    if (!mongoose.Types.ObjectId.isValid(variantId)) {
      res.status(400).json({ success: false, message: "Invalid variant ID" });
      return;
    }

    // Validate quantity
    if (isNaN(parsedQuantity) || parsedQuantity <= 0) {
      res.status(400).json({ success: false, message: "Quantity must be a positive number" });
      return;
    }

    // Check if user exists
    const userExists = await User.findById(userId);
    if (!userExists) {
      res.status(404).json({ success: false, message: "User not found" });
      return;
    }

    // Get product variant first
    const variant = await ProductVariant.findById(variantId);
    if (!variant) {
      res.status(404).json({ success: false, message: "Product variant not found" });
      return;
    }

    // Check if variant is available
    if (variant.available_status !== 'in_stock') {
      res.status(400).json({ 
        success: false, 
        message: `Product variant is not available. Status: ${variant.available_status}` 
      });
      return;
    }

    // Check if product exists
    const productExists = await Product.findById(variant.productObjectId);
    if (!productExists) {
      res.status(404).json({ success: false, message: "Product not found" });
      return;
    }

    if (variant.stock_qty && variant.stock_qty < parsedQuantity) {
      res.status(400).json({ 
        success: false, 
        message: `Insufficient stock. Available: ${variant.stock_qty}, Requested: ${parsedQuantity}` 
      });
      return;
    }

    // Validate variant price
    const variantPrice = parseFloat(variant.price?.toString() || '0');
    if (isNaN(variantPrice) || variantPrice <= 0) {
      res.status(400).json({ 
        success: false, 
        message: `Invalid variant price for size ${variant.size}` 
      });
      return;
    }

    // Find or create cart for user
    let cart = await Cart.findOne({ user: userId });
    
    if (!cart) {
      cart = new Cart({
        user: userId,
        items: [],
        subTotalAmount: 0
      });
    }

    // Check if the exact same variant already exists in cart
    const existingItemIndex = cart.items.findIndex(
      (item: any) => item.variantId?.toString() === variantId
    );

    console.log(`Checking for existing variant: VariantId ${variantId}`);
    console.log(`Existing item index: ${existingItemIndex}`);

    if (existingItemIndex > -1) {
      // Update existing item quantity (exact same variant)
      const newQuantity = cart.items[existingItemIndex].quantity + parsedQuantity;
      
      console.log(`Updating existing variant: Current qty ${cart.items[existingItemIndex].quantity}, Adding ${parsedQuantity}, New total: ${newQuantity}`);
      
      // Check if total quantity exceeds stock
      if (variant.stock_qty && variant.stock_qty < newQuantity) {
        res.status(400).json({ 
          success: false, 
          message: `Cannot add ${parsedQuantity} more items. Available stock: ${variant.stock_qty}, Current in cart: ${cart.items[existingItemIndex].quantity}` 
        });
        return;
      }

      cart.items[existingItemIndex].quantity = newQuantity;
      cart.items[existingItemIndex].price = variantPrice * newQuantity;
    } else {
      // Add new item to cart (different variant)
      console.log(`Adding new variant: VariantId ${variantId}, Product ${variant.productObjectId}, Size ${variant.size}, Quantity ${parsedQuantity}`);
      cart.items.push({
        product: variant.productObjectId,
        variantId: variantId,
        size: variant.size.toLowerCase(),
        quantity: parsedQuantity,
        price: variantPrice * parsedQuantity
      });
    }

    // Recalculate subtotal
    cart.subTotalAmount = cart.items.reduce((total: number, item: any) => total + item.price, 0);

    await cart.save();

    // Populate cart for response with product images
    const populatedCart = await Cart.findById(cart._id)
      .populate('items.product', 'name description')
      .populate('user', 'name email');

    // Get product images for each cart item
    const cartWithImages = await Promise.all(
      (populatedCart as any).items.map(async (item: any) => {
        // Get variant using the stored variantId
        const itemVariant = await ProductVariant.findById(item.variantId);

        // Get images for this variant
        const images = await ProductImage.find({
          variantObjectid: item.variantId
        }).sort({ sort_order: 1 });

        // Get the primary image or first image
        const primaryImage = images.find(img => img.is_primary) || images[0];

        return {
          ...item.toObject(),
          variant: itemVariant,
          image: primaryImage ? {
            _id: primaryImage._id,
            image: primaryImage.image,
            is_primary: primaryImage.is_primary,
            sort_order: primaryImage.sort_order
          } : null
        };
      })
    );

    res.status(200).json({
      success: true,
      message: "Product added to cart successfully",
      data: {
        user: (populatedCart as any).user,
        items: cartWithImages,
        subTotalAmount: (populatedCart as any).subTotalAmount
      }
    });

  } catch (error) {
    console.error("Error adding to cart:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

// Update Cart Item Quantity
export const updateCartQuantity = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId, variantId, quantity } = req.body;
    const parsedQuantity = parseInt(quantity);

    // Validate required fields
    if (!userId || !variantId || !quantity) {
      res.status(400).json({
        success: false,
        message: "All fields are required: userId, variantId, quantity"
      });
      return;
    }

    // Validate ObjectIds
    if (!mongoose.Types.ObjectId.isValid(userId)) {
      res.status(400).json({ success: false, message: "Invalid user ID" });
      return;
    }

    if (!mongoose.Types.ObjectId.isValid(variantId)) {
      res.status(400).json({ success: false, message: "Invalid variant ID" });
      return;
    }

    // Validate quantity
    if (isNaN(parsedQuantity) || parsedQuantity <= 0) {
      res.status(400).json({ success: false, message: "Quantity must be a positive number" });
      return;
    }

    // Check if user exists
    const userExists = await User.findById(userId);
    if (!userExists) {
      res.status(404).json({ success: false, message: "User not found" });
      return;
    }

    // Get product variant first
    const variant = await ProductVariant.findById(variantId);
    if (!variant) {
      res.status(404).json({ success: false, message: "Product variant not found" });
      return;
    }

    // Check if variant is available
    if (variant.available_status !== 'in_stock') {
      res.status(400).json({ 
        success: false, 
        message: `Product variant is not available. Status: ${variant.available_status}` 
      });
      return;
    }

    // Check if product exists
    const productExists = await Product.findById(variant.productObjectId);
    if (!productExists) {
      res.status(404).json({ success: false, message: "Product not found" });
      return;
    }

    // Find user's cart
    const cart = await Cart.findOne({ user: userId });
    if (!cart) {
      res.status(404).json({ success: false, message: "Cart not found" });
      return;
    }

    // Find the item in cart by variantId
    const itemIndex = cart.items.findIndex(
      (item: any) => item.variantId?.toString() === variantId
    );

    if (itemIndex === -1) {
      res.status(404).json({ success: false, message: "Item not found in cart" });
      return;
    }

    if (variant.stock_qty && variant.stock_qty < parsedQuantity) {
      res.status(400).json({ 
        success: false, 
        message: `Insufficient stock. Available: ${variant.stock_qty}, Requested: ${parsedQuantity}` 
      });
      return;
    }

    // Validate variant price
    const variantPrice = parseFloat(variant.price?.toString() || '0');
    if (isNaN(variantPrice) || variantPrice <= 0) {
      res.status(400).json({ 
        success: false, 
        message: `Invalid variant price for size ${variant.size}` 
      });
      return;
    }

    // Update item quantity and price
    cart.items[itemIndex].quantity = parsedQuantity;
    cart.items[itemIndex].price = variantPrice * parsedQuantity;

    // Recalculate subtotal
    cart.subTotalAmount = cart.items.reduce((total: number, item: any) => total + item.price, 0);

    await cart.save();

    // Populate cart for response with images
    const populatedCart = await Cart.findById(cart._id)
      .populate('items.product', 'name description')
      .populate('user', 'name email');

    // Get product images for each cart item
    const cartWithImages = await Promise.all(
      (populatedCart as any).items.map(async (item: any) => {
        // Get variant using the stored variantId
        const itemVariant = await ProductVariant.findById(item.variantId);

        // Get images for this variant
        const images = await ProductImage.find({
          variantObjectid: item.variantId
        }).sort({ sort_order: 1 });

        // Get the primary image or first image
        const primaryImage = images.find(img => img.is_primary) || images[0];

        return {
          ...item.toObject(),
          variant: itemVariant,
          image: primaryImage ? {
            _id: primaryImage._id,
            image: primaryImage.image,
            is_primary: primaryImage.is_primary,
            sort_order: primaryImage.sort_order
          } : null
        };
      })
    );

    res.status(200).json({
      success: true,
      message: "Cart quantity updated successfully",
      data: {
        user: (populatedCart as any).user,
        items: cartWithImages,
        subTotalAmount: (populatedCart as any).subTotalAmount
      }
    });

  } catch (error) {
    console.error("Error updating cart quantity:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

// Remove Product from Cart
export const removeFromCart = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId, variantId } = req.body;

    // Validate required fields
    if (!userId || !variantId) {
      res.status(400).json({
        success: false,
        message: "All fields are required: userId, variantId"
      });
      return;
    }

    // Validate ObjectIds
    if (!mongoose.Types.ObjectId.isValid(userId)) {
      res.status(400).json({ success: false, message: "Invalid user ID" });
      return;
    }

    if (!mongoose.Types.ObjectId.isValid(variantId)) {
      res.status(400).json({ success: false, message: "Invalid variant ID" });
      return;
    }

    // Check if user exists
    const userExists = await User.findById(userId);
    if (!userExists) {
      res.status(404).json({ success: false, message: "User not found" });
      return;
    }

    // Get product variant first
    const variant = await ProductVariant.findById(variantId);
    if (!variant) {
      res.status(404).json({ success: false, message: "Product variant not found" });
      return;
    }

    // Find user's cart
    const cart = await Cart.findOne({ user: userId });
    if (!cart) {
      res.status(404).json({ success: false, message: "Cart not found" });
      return;
    }

    // Find and remove the item by variantId
    const itemToRemove = cart.items.find(
      (item: any) => item.variantId?.toString() === variantId
    );

    if (!itemToRemove) {
      res.status(404).json({ success: false, message: "Item not found in cart" });
      return;
    }

    cart.items.pull(itemToRemove._id);

    // Recalculate subtotal
    cart.subTotalAmount = cart.items.reduce((total: number, item: any) => total + item.price, 0);

    await cart.save();

    res.status(200).json({
      success: true,
      message: "Product removed from cart successfully",
      data: {
        subTotalAmount: cart.subTotalAmount
      }
    });

  } catch (error) {
    console.error("Error removing from cart:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

// Get User's Cart
export const getCart = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.body;

    // Validate required fields
    if (!userId) {
      res.status(400).json({
        success: false,
        message: "User ID is required"
      });
      return;
    }

    // Validate ObjectId
    if (!mongoose.Types.ObjectId.isValid(userId)) {
      res.status(400).json({ success: false, message: "Invalid user ID" });
      return;
    }

    // Find user's cart
    const cart = await Cart.findOne({ user: userId })
      .populate('items.product', 'name description')
      .populate('user', 'name email');

    if (!cart) {
      // Return empty cart if not found
      res.status(200).json({
        success: true,
        message: "Cart is empty",
        data: {
          user: userId,
          items: [],
          subTotalAmount: 0
        }
      });
      return;
    }

    // Get product images for each cart item
    const cartWithImages = await Promise.all(
      (cart as any).items.map(async (item: any) => {
        // Get variant using the stored variantId
        const itemVariant = await ProductVariant.findById(item.variantId);

        // Get images for this variant
        const images = await ProductImage.find({
          variantObjectid: item.variantId
        }).sort({ sort_order: 1 });

        // Get the primary image or first image
        const primaryImage = images.find(img => img.is_primary) || images[0];

        return {
          ...item.toObject(),
          variant: itemVariant,
          image: primaryImage ? {
            _id: primaryImage._id,
            image: primaryImage.image,
            is_primary: primaryImage.is_primary,
            sort_order: primaryImage.sort_order
          } : null
        };
      })
    );

    res.status(200).json({
      success: true,
      message: "Cart retrieved successfully",
      data: {
        user: (cart as any).user,
        items: cartWithImages,
        subTotalAmount: (cart as any).subTotalAmount
      }
    });

  } catch (error) {
    console.error("Error getting cart:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

// Clear Cart (remove all items)
export const clearCart = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.body;

    // Validate required fields
    if (!userId) {
      res.status(400).json({
        success: false,
        message: "User ID is required"
      });
      return;
    }

    // Validate ObjectId
    if (!mongoose.Types.ObjectId.isValid(userId)) {
      res.status(400).json({ success: false, message: "Invalid user ID" });
      return;
    }

    // Find and clear user's cart
    const cart = await Cart.findOne({ user: userId });
    if (!cart) {
      res.status(404).json({ success: false, message: "Cart not found" });
      return;
    }

    cart.items.splice(0, cart.items.length);
    cart.subTotalAmount = 0;
    await cart.save();

    res.status(200).json({
      success: true,
      message: "Cart cleared successfully",
      data: cart
    });

  } catch (error) {
    console.error("Error clearing cart:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};
