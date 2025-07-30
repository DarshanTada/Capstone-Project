import { Request, Response } from 'express';
import Product from '../productModule/product.model';
import ProductVariant from '../productModule/productVariant.model';
import ProductImage from '../productModule/productImage.model';
import mongoose from 'mongoose';

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
      subcategory_id,
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
      subcategory_id,
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

        // Get image metadata from form data
        const isPrimaryKey = `variant_${i}_image_${imageIndex}_is_primary`;
        const sortOrderKey = `variant_${i}_image_${imageIndex}_sort_order`;
        
        const isPrimary = req.body[isPrimaryKey] === 'true' || req.body[isPrimaryKey] === true;
        const sortOrder = parseInt(req.body[sortOrderKey]) || imageIndex + 1;

        // Convert buffer to base64 string
        const base64String = file.buffer.toString("base64");
        await ProductImage.create({
          productObjectId: newProduct._id,
          variantObjectid: savedVariant._id,
          image: {
            base64: base64String,
            contentType: file.mimetype,
          },
          is_primary: isPrimary,
          sort_order: sortOrder
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
      subcategory_id,
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
    product.subcategory_id = subcategory_id;
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
      // .populate('category_id')
      // .populate('subcategory_id')
      // .populate('care_instruction_objectId')
      // .populate('season_objectId')
      // .populate('festival_objectId')
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

// Get Product Detail with similar, matching, and trending products
export const getProductDetail = async (req: Request, res: Response): Promise<void> => {
  try {
    const { productId } = req.params;

    if (!mongoose.Types.ObjectId.isValid(productId)) {
      res.status(400).json({ success: false, message: "Invalid product ID" });
      return;
    }

    // Get main product with populated fields
    const product = await Product.findById(productId)
      // .populate('category_id')
      // .populate('subcategory_id')
      .populate('care_instruction_objectId')
      .populate('season_objectId')
      .populate('festival_objectId')
      .lean();

    if (!product) {
      res.status(404).json({ success: false, message: "Product not found" });
      return;
    }

    // Get variants and images for main product
    const variants = await ProductVariant.find({ productObjectId: productId }).lean();
    const images = await ProductImage.find({ productObjectId: productId }).lean();

    const productDetail = {
      ...product,
      variants,
      images
    };

    // Get similar products (same category and subcategory, excluding current product)
    const similarProductsQuery = await Product.aggregate([
      {
        $match: {
          _id: { $ne: new mongoose.Types.ObjectId(productId) },
          category_id: product.category_id,
          subcategory_id: product.subcategory_id
        }
      },
      {
        $lookup: {
          from: 'subcategories',
          localField: 'subcategory_id',
          foreignField: '_id',
          as: 'subcategory'
        }
      }
    ]);

    const similarProducts = await Product.populate(similarProductsQuery, [
      // { path: 'category_id' },
      // { path: 'subcategory_id' }
    ]);

    // Get variants and images for similar products
    const similarProductIds = similarProducts.map(p => p._id);
    const similarVariants = await ProductVariant.find({ productObjectId: { $in: similarProductIds } }).lean();
    const similarImages = await ProductImage.find({ productObjectId: { $in: similarProductIds } }).lean();

    const enrichedSimilarProducts = similarProducts.map(prod => {
      const prodVariants = similarVariants.filter(v => String(v.productObjectId) === String(prod._id));
      const prodImages = similarImages.filter(img => String(img.productObjectId) === String(prod._id));
      return { ...prod, variants: prodVariants, images: prodImages };
    });

    // Get matching products (opposite productType with same bodyType and gender)
    const oppositeProductType = product.productType === 'top' ? 'bottom' : 'top';
    
    const matchingProductsQuery = await Product.aggregate([
      {
        $lookup: {
          from: 'subcategories',
          localField: 'subcategory_id',
          foreignField: '_id',
          as: 'subcategory'
        }
      },
      {
        $match: {
          _id: { $ne: new mongoose.Types.ObjectId(productId) },
          productType: oppositeProductType,
          gender: product.gender,
          bodyType: product.bodyType
        }
      }
    ]);

    const matchingProducts = await Product.populate(matchingProductsQuery, [
      // { path: 'category_id' },
      // { path: 'subcategory_id' }
    ]);

    // Get variants and images for matching products
    const matchingProductIds = matchingProducts.map(p => p._id);
    const matchingVariants = await ProductVariant.find({ productObjectId: { $in: matchingProductIds } }).lean();
    const matchingImages = await ProductImage.find({ productObjectId: { $in: matchingProductIds } }).lean();

    const enrichedMatchingProducts = matchingProducts.map(prod => {
      const prodVariants = matchingVariants.filter(v => String(v.productObjectId) === String(prod._id));
      const prodImages = matchingImages.filter(img => String(img.productObjectId) === String(prod._id));
      return { ...prod, variants: prodVariants, images: prodImages };
    });

    // Get trending products (products with variants where is_on_trend is true, excluding current product)
    const trendingProductsQuery = await Product.aggregate([
      {
        $lookup: {
          from: 'productvariants',
          localField: '_id',
          foreignField: 'productObjectId',
          as: 'variants'
        }
      },
      {
        $match: {
          _id: { $ne: new mongoose.Types.ObjectId(productId) },
          'variants.is_on_trend': true
        }
      },
      {
        $lookup: {
          from: 'subcategories',
          localField: 'subcategory_id',
          foreignField: '_id',
          as: 'subcategory'
        }
      }
    ]);

    const trendingProducts = await Product.populate(trendingProductsQuery, [
      // { path: 'category_id' },
      // { path: 'subcategory_id' }
    ]);

    // Get variants and images for trending products
    const trendingProductIds = trendingProducts.map(p => p._id);
    const trendingVariants = await ProductVariant.find({ productObjectId: { $in: trendingProductIds } }).lean();
    const trendingImages = await ProductImage.find({ productObjectId: { $in: trendingProductIds } }).lean();

    const enrichedTrendingProducts = trendingProducts.map(prod => {
      const prodVariants = trendingVariants.filter(v => String(v.productObjectId) === String(prod._id));
      const prodImages = trendingImages.filter(img => String(img.productObjectId) === String(prod._id));
      return { ...prod, variants: prodVariants, images: prodImages };
    });

    res.status(200).json({
      success: true,
      data: {
        productDetail: productDetail,
        similarproduct: {
          title: "Similar Products",
          products: enrichedSimilarProducts
        },
        matchingproduct: {
          title: "Matching Products",
          products: enrichedMatchingProducts
        },
        trandingproducts: {
          title: "Trending Products",
          products: enrichedTrendingProducts
        }
      }
    });

  } catch (error) {
    console.error("Error fetching product detail:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};

// Get all trending products (products with variants where is_on_trend is true)
export const getTrendingProducts = async (req: Request, res: Response): Promise<void> => {
  try {
    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 10;
    const skip = (page - 1) * limit;

    // Get products with trending variants using aggregation
    const trendingProductsQuery = await Product.aggregate([
      {
        $lookup: {
          from: 'productvariants',
          localField: '_id',
          foreignField: 'productObjectId',
          as: 'variants'
        }
      },
      {
        $match: {
          'variants.is_on_trend': true
        }
      },
      {
        $lookup: {
          from: 'categories',
          localField: 'category_id',
          foreignField: '_id',
          as: 'category'
        }
      },
      {
        $lookup: {
          from: 'subcategories',
          localField: 'subcategory_id',
          foreignField: '_id',
          as: 'subcategory'
        }
      },
      {
        $lookup: {
          from: 'careinstruction',
          localField: 'care_instruction_objectId',
          foreignField: '_id',
          as: 'care_instruction_objectId'
        }
      },
      {
        $lookup: {
          from: 'seasons',
          localField: 'season_objectId',
          foreignField: '_id',
          as: 'season_objectId'
        }
      },
      {
        $lookup: {
          from: 'festivals',
          localField: 'festival_objectId',
          foreignField: '_id',
          as: 'festival_objectId'
        }
      },
      { $skip: skip },
      { $limit: limit }
    ]);

    // Get total count for pagination
    const totalCountQuery = await Product.aggregate([
      {
        $lookup: {
          from: 'productvariants',
          localField: '_id',
          foreignField: 'productObjectId',
          as: 'variants'
        }
      },
      {
        $match: {
          'variants.is_on_trend': true
        }
      },
      { $count: "total" }
    ]);

    const total = totalCountQuery.length > 0 ? totalCountQuery[0].total : 0;

    // Get product IDs for fetching variants and images
    const productIds = trendingProductsQuery.map(p => p._id);

    // Fetch all variants and images for trending products
    const variants = await ProductVariant.find({ 
      productObjectId: { $in: productIds },
      is_on_trend: true 
    }).lean();
    
    const images = await ProductImage.find({ productObjectId: { $in: productIds } }).lean();

    // Attach variants and images to each product
    const enrichedProducts = trendingProductsQuery.map(product => {
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
    console.error("Error fetching trending products:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: (error as Error).message,
    });
  }
};