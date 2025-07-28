import { Request, Response } from 'express';
import Product from '../productModule/product.model';
import ProductVariant from '../productModule/productVariant.model';
import ProductImage from '../productModule/productImage.model';
import mongoose from 'mongoose';


// Get Product Detail API
export const getProductDetail = async (req: Request, res: Response): Promise<void> => {
  try {
    const productId = req.params.id;
    // Populate subcategory inside body_type
        const product = await Product.findById(productId)
            .populate({
                path: 'category_id',
                populate: {
                    path: 'body_type.subcategory',
                }
            })
            .populate('care_instruction_objectId');
    if (!product) {
      res.status(404).json({ success: false, message: 'Product not found.' });
      return;
    }

    // Get variants
    const variants = await ProductVariant.find({ productObjectId: productId });

    // Get images
    const images = await ProductImage.find({ productObjectId: productId });

    // Defensive: check populated fields
    const categoryId = product.category_id?._id || product.category_id;
    // Get similar products (same category, exclude current)
    const similarProducts = await Product.find({
      category_id: categoryId,
      _id: { $ne: productId }
    }).limit(10);

    // Get user preferences from query
    const { skinTone, undertone, bodyType } = req.query;

    // Generate system prompt for askQuestion API
    let systemPrompt = '';
    if (product.productType === 'top') {
      const categoryName = typeof product.category_id === 'object' && 'name' in product.category_id
        ? (product.category_id as any).name
        : '';
      let subcategoryName = '';
      if (Array.isArray(product.bodyType) && product.bodyType[0] && typeof product.bodyType[0] === 'object' && 'subcategory' in product.bodyType[0]) {
        subcategoryName = product.bodyType[0].subcategory?.[0]?.name || '';
      }
      systemPrompt = `Given a user with skin tone: ${skinTone}, undertone: ${undertone}, body type: ${bodyType}, and a top from category: ${categoryName}, subcategory: ${subcategoryName}, suggest the most trendy and matching bottoms available in our catalog. Only recommend products that fit the user's body type and style preferences.`;
    }

    // Call askQuestion API (pseudo, replace with actual call)
    let trendsResponse: any = null;
    if (systemPrompt) {
      // Replace with actual ML API call
      // trendsResponse = await askQuestion(systemPrompt);
      trendsResponse = null; // Placeholder
    }

    // Get matching products according to user preferences and ML response
    // Call askQuestion API for actual matching response
    let matchingAPIResponse = '';
    if (systemPrompt) {
        try {
            const axios = require('axios');
            const baseURL = process.env.PYTHON_SERVER_URL || 'http://localhost:8000';
            const mlRes = await axios.post(`${baseURL}/ask/`, {
                question: 'What bottoms match this top?',
                system_prompt: systemPrompt,
            }, { timeout: 120000 });
            matchingAPIResponse = typeof mlRes.data === 'string' ? mlRes.data : JSON.stringify(mlRes.data);
        } catch (mlErr: any) {
            matchingAPIResponse = 'AI API call failed.';
        }
    }

    let matchingProducts: any[] = [];
    if (product.productType === 'top') {
        // If ML API returns product IDs, fetch those products
        let trendProductIds: string[] = [];
        try {
            const parsedTrend = typeof matchingAPIResponse === 'string' ? JSON.parse(matchingAPIResponse) : matchingAPIResponse;
            if (parsedTrend && parsedTrend.matchingProductIds && Array.isArray(parsedTrend.matchingProductIds)) {
                trendProductIds = parsedTrend.matchingProductIds;
            }
        } catch (e) {
            // If matchingAPIResponse is not JSON, ignore
        }
        if (trendProductIds.length > 0) {
            matchingProducts = await Product.find({ _id: { $in: trendProductIds } });
        } else {
            // Fallback: filter by user preferences
            const matchQuery: any = {
                productType: 'bottom',
            };
            if (bodyType) matchQuery.bodyType = bodyType;
            if (skinTone) matchQuery.skin_tone = skinTone;
            if (undertone) matchQuery.under_tone = undertone;
            matchingProducts = await Product.find(matchQuery).limit(10);
        }
    }

    res.status(200).json({
        success: true,
        data: {
            product,
            variants,
            images,
            similarProducts,
            matchingProducts,
            matchingAPIResponse,
        }
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};


const safeParse = (value: any): any[] => {
  try {
    if (typeof value === "string") {
      const parsed = JSON.parse(value);
      return Array.isArray(parsed) ? parsed : [];
    }
    return Array.isArray(value) ? value : [];
  } catch {
    return [];
  }
};

export const createProduct = async (req: Request, res: Response) => {
  try {
    const {
      name,
      description,
      fabric_type,
      category_id,
      gender,
      bodyType,
      season_objectId,
      festival_objectId,
      care_instruction_objectId,
      productType,
      style,
      variants,
    } = req.body;

    // Parse arrays safely with fallback to []
    const parsedStyle = safeParse(style);
    const parsedVariants = safeParse(variants);
    const parsedSeason = safeParse(season_objectId);
    const parsedFestival = safeParse(festival_objectId);
    const parsedCareInstructions = safeParse(care_instruction_objectId);

    // Create product
    const newProduct = await Product.create({
      name,
      description,
      fabric_type,
      category_id,
      gender,
      bodyType,
      productType,
      style: parsedStyle,
      season_objectId: parsedSeason,
      festival_objectId: parsedFestival,
      care_instruction_objectId: parsedCareInstructions,
    });

    // req.files is an array when using upload.any()
    const filesArray = req.files as Express.Multer.File[] || [];
    const files: Record<string, Express.Multer.File[]> = {};

    // Convert array of files into an object keyed by fieldname
    filesArray.forEach(file => {
      if (!files[file.fieldname]) files[file.fieldname] = [];
      files[file.fieldname].push(file);
    });

    // Loop through variants
    for (let i = 0; i < parsedVariants.length; i++) {
      const variant = parsedVariants[i];

      const savedVariant = await ProductVariant.create({
        ...variant,
        productObjectId: newProduct._id,
      });

      // Store multiple images dynamically for each variant
      let imageIndex = 0;
      while (true) {
        const key = `variant_${i}_image_${imageIndex}`;
        const file = files?.[key]?.[0];
        if (!file) break;

        // Convert buffer to base64 string
        const base64String = file.buffer.toString("base64");
        await ProductImage.create({
          productObjectId: newProduct._id,
          productVariantObjectId: savedVariant._id,
          image: {
            base64: base64String,
            contentType: file.mimetype,
          },
        });

        imageIndex++;
      }
    }

    // Fetch saved variants and images
    const savedVariants = await ProductVariant.find({ productObjectId: newProduct._id });
    const images = await ProductImage.find({ productObjectId: newProduct._id });

    res.status(200).json({
      success: true,
      message: "Product created successfully",
      data: {
        product: newProduct,
        variants: savedVariants,
        images,
      },
    });
  } catch (error) {
    console.error("Error creating product:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

export default createProduct;


export const updateProduct = async (req: Request, res: Response): Promise<void> => {
  try {
    const {
      productId,
      name,
      description,
      fabric_type,
      category_id,
      gender,
      bodyType,
      season_objectId,
      festival_objectId,
      care_instruction_objectId,
      productType,
      style,
      variants,
    } = req.body;

    if (!productId || !mongoose.Types.ObjectId.isValid(productId)) {
      res.status(400).json({ success: false, message: "Invalid product ID" });
      return;
    }

    const product = await Product.findById(productId);
    if (!product) {
      res.status(404).json({ success: false, message: "Product not found" });
      return;
    }

    // Update base product fields
    product.name = name;
    product.description = description;
    product.fabric_type = fabric_type;
    product.category_id = category_id;
    product.gender = gender;
    product.bodyType = bodyType;
    product.productType = productType;
    product.style = safeParse(style);
    product.season_objectId = safeParse(season_objectId);
    product.festival_objectId = safeParse(festival_objectId);
    product.care_instruction_objectId = safeParse(care_instruction_objectId);
    await product.save();

    // Parse uploaded files
    const filesArray = req.files as Express.Multer.File[] || [];
    const files: Record<string, Express.Multer.File[]> = {};
    filesArray.forEach(file => {
      if (!files[file.fieldname]) files[file.fieldname] = [];
      files[file.fieldname].push(file);
    });

    // Update variants and existing images
    const parsedVariants = safeParse(variants);
    for (let i = 0; i < parsedVariants.length; i++) {
      const variant = parsedVariants[i];

      // ✅ Only allow update of existing variants
      if (!variant._id || !mongoose.Types.ObjectId.isValid(variant._id)) {
        res.status(400).json({
          success: false,
          message: `Invalid or missing _id for variant at index ${i}. Only existing variants can be updated.`,
        });
        return;
      }

      const existingVariant = await ProductVariant.findById(variant._id);
      if (!existingVariant) {
        res.status(404).json({
          success: false,
          message: `Variant not found with id: ${variant._id}`,
        });
        return;
      }

      await ProductVariant.findByIdAndUpdate(variant._id, {
        ...variant,
        productObjectId: productId,
      });

      const variantImages = safeParse(variant.images || []);
      for (let j = 0; j < variantImages.length; j++) {
        const imageObj = variantImages[j];

        if (!imageObj._id || !mongoose.Types.ObjectId.isValid(imageObj._id)) {
          res.status(400).json({
            success: false,
            message: `Invalid or missing _id for image at variant index ${i}, image index ${j}. New images cannot be added.`,
          });
          return;
        }

        const fileKey = `variant_${i}_image_${j}`;
        const file = files?.[fileKey]?.[0];

        if (file) {
          const base64String = file.buffer.toString("base64");

          await ProductImage.findByIdAndUpdate(imageObj._id, {
            image: {
              base64: base64String,
              contentType: file.mimetype,
            },
          });
        }
      }
    }

    // Fetch updated data
    const updatedVariants = await ProductVariant.find({ productObjectId: productId });
    const images = await ProductImage.find({ productObjectId: productId });

    res.status(200).json({
      success: true,
      message: "Product, variants, and images updated successfully",
      data: {
        product,
        variants: updatedVariants,
        images,
      },
    });
  } catch (error) {
    console.error("Error updating product:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};


export const getAllProducts = async (req: Request, res: Response): Promise<void> => {
  try {
    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 10;

    const skip = (page - 1) * limit;

    const total = await Product.countDocuments();
    const products = await Product.find()
      .populate('category_id')
      .skip(skip)
      .limit(limit)
      .lean();

    const productIds = products.map(p => p._id);

    // Fetch all variants and images for current products
    const variants = await ProductVariant.find({ productObjectId: { $in: productIds } }).lean();
    const images = await ProductImage.find({ productObjectId: { $in: productIds } }).lean();

    // Attach variants and images to each product
    const enrichedProducts = products.map(product => {
      const productVariants = variants.filter(v => String(v.productObjectId) === String(product._id));
      const productImages = images.filter(img => String(img.productObjectId) === String(product._id));

      return {
        ...product,
        variants: productVariants,
        images: productImages,
      };
    });

    res.status(200).json({
      success: true,
      data: enrichedProducts,
      pagination: {
        total,
        currentPage: page,
        totalPages: Math.ceil(total / limit),
        limit,
      },
    });
  } catch (error) {
    console.error("Error fetching products:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

export const deleteProduct = async (req: Request, res: Response): Promise<void> => {
  const { productId } = req.params;

  if (!mongoose.Types.ObjectId.isValid(productId)) {
    res.status(400).json({ success: false, message: "Invalid product ID" });
    return;
  }

  try {
    const product = await Product.findById(productId);
    if (!product) {
      res.status(404).json({ success: false, message: "Product not found" });
      return;
    }

    // Delete product
    await Product.findByIdAndDelete(productId);

    // Delete related variants
    await ProductVariant.deleteMany({ productObjectId: productId });

    // Delete related images
    await ProductImage.deleteMany({ productObjectId: productId });

    res.status(200).json({
      success: true,
      message: "Product, variants, and images deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting product:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};