import { Request, Response, NextFunction, RequestHandler } from 'express';
import Product from '../productModule/product.model';
import ProductVariant from '../productModule/productVariant.model';
import ProductImage from '../productModule/productImage.model';
import CareInstruction from '../productModule/careInstruction.model';
import Festival from '../productModule/festival.model';
import Season from '../seasonModule/season.model';
import dotenv from "dotenv";


dotenv.config()

export const getProduct = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const productId = req.params.id;
    const product = await Product.findById(productId)
      .populate('care_instruction_objectId')
      .populate('festival_objectId')
      .populate('season_objectId')
      .lean();

    if (!product) {
      return res.status(404).json({ success: false, message: 'Product not found' });
    }

    // Fetch variants & images
    const variants = await ProductVariant.find({ productObjectId: productId }).lean();
    const images = await ProductImage.find({ productObjectId: productId }).lean();

    return res.status(200).json({ success: true, data: { product, variants, images } });
  } catch (error: any) {
    console.error('Get Product Error:', error);
    return res.status(500).json({ success: false, message: error.message });
  }
};

export const getAllProducts = async (req: Request, res: Response) => {
  try {
    // Fetch all products with populated relations
    const products = await Product.find()
      .populate('care_instruction_objectId')
      .populate('festival_objectId')
      .populate('season_objectId')
      .lean();

    // Fetch variants and images for all products
    const productIds = products.map((p) => p._id);

    const variants = await ProductVariant.find({ productObjectId: { $in: productIds } }).lean();
    const images = await ProductImage.find({ productObjectId: { $in: productIds } }).lean();

    // Map variants and images to respective products
    const variantsMap = variants.reduce((acc, variant) => {
      const key = variant.productObjectId?.toString?.() ?? '';
      acc[key] = acc[key] || [];
      acc[key].push(variant);
      return acc;
    }, {} as Record<string, any[]>);

    const imagesMap = images.reduce((acc, image) => {
      const key = image.productObjectId?.toString?.() ?? '';
      acc[key] = acc[key] || [];
      acc[key].push(image);
      return acc;
    }, {} as Record<string, any[]>);

    // Attach variants and images to each product
    const result = products.map((product) => ({
      ...product,
      variants: variantsMap[product._id.toString()] || [],
      images: imagesMap[product._id.toString()] || [],
    }));

    res.status(200).json({ success: true, data: result });
  } catch (error: any) {
    console.error('Get All Products Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};


// Delete Product by ID and cleanup
export const deleteProduct = async (req: Request, res: Response) => {
  try {
    const productId = req.params.id;

    // Delete product
    const deletedProduct = await Product.findByIdAndDelete(productId);

    if (!deletedProduct) {
      return res.status(404).json({ success: false, message: 'Product not found' });
    }

    // Delete related variants, images, care instruction, festival, season if needed
    await ProductVariant.deleteMany({ productObjectId: productId });
    await ProductImage.deleteMany({ productObjectId: productId });
    await CareInstruction.findByIdAndDelete(deletedProduct.care_instruction_objectId);
    await Festival.findByIdAndDelete(deletedProduct.festival_objectId);
    await Season.findByIdAndDelete(deletedProduct.season_objectId);

    return res.status(200).json({ success: true, message: 'Product deleted successfully' });
  } catch (error: any) {
    console.error('Delete Product Error:', error);
    return res.status(500).json({ success: false, message: error.message });
  }
};

export const createProduct = async (req: Request, res: Response) => {
  try {
    const {
      name,
      description,
      fabric_type,
      category_id,
      availabe_status,
      reviewObjectId,
      gender,
      weight,
      productType,
      care_instruction,
      festival_name,
      season_name,
      variants,
    } = req.body;

    // Save CareInstruction
    let careInstructionId = null;
    if (care_instruction) {
      const files = req.files as Record<string, Express.Multer.File[]>;
      const care = new CareInstruction({
        instruction: care_instruction,
        image: files?.['care_instruction_image']?.[0]?.filename || null,
      });
      await care.save();
      careInstructionId = care._id;
    }

    // Save Festival
    let festivalId = null;
    if (festival_name) {
      const festival = new Festival({ festival_name, isEnable: true });
      await festival.save();
      festivalId = festival._id;
    }

    // Save Season
    let seasonId = null;
    if (season_name) {
      const season = new Season({ season_name, isEnable: true });
      await season.save();
      seasonId = season._id;
    }

    // Save Product
    const product = new Product({
      name,
      description,
      fabric_type,
      category_id,
      availabe_status,
      reviewObjectId,
      gender,
      season_objectId: seasonId,
      festival_objectId: festivalId,
      care_instruction_objectId: careInstructionId,
      weight,
      productType,
    });

    await product.save();

    // Save Variants
    const parsedVariants = JSON.parse(variants || '[]');
    for (const variant of parsedVariants) {
      const files = req.files as Record<string, Express.Multer.File[]>;
      const variantImageFile = files?.['variant_image']?.find((img) => img.originalname === variant.image_name);
      const newVariant = new ProductVariant({
        ...variant,
        productObjectId: product._id,
        variant_image: variantImageFile ? variantImageFile.filename : null,
      });
      await newVariant.save();
    }

    // Save Images
    const imageFiles = (req.files as Record<string, Express.Multer.File[]>)?.['images'] || [];
    for (let i = 0; i < imageFiles.length; i++) {
      const image = new ProductImage({
        productObjectId: product._id,
        image: imageFiles[i].filename,
        is_primary: i === 0,
        sort_order: i,
      });
      await image.save();
    }

    res.status(201).json({ success: true, message: 'Product created successfully', productId: product._id });
  } catch (error: any) {
    console.error('Create Product Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};


// Update Product by ID
export const updateProduct = async (req: Request, res: Response) => {
  try {
    const productId = req.params.id;
    const {
      name,
      description,
      fabric_type,
      category_id,
      availabe_status,
      reviewObjectId,
      gender,
      weight,
      productType,
      care_instruction,
      festival_name,
      season_name,
      variants,
    } = req.body;

    // Update or create CareInstruction
    let careInstructionId = null;
    if (care_instruction) {
      let care = await CareInstruction.findOne({ _id: req.body.care_instruction_objectId });
      if (care) {
        care.instruction = care_instruction;
        const files = req.files as Record<string, Express.Multer.File[]>;
        if (files?.['care_instruction_image']?.[0]) {
          care.image = files['care_instruction_image'][0].filename;
        }
        await care.save();
      } else {
        care = new CareInstruction({
          instruction: care_instruction,
          image: (req.files as Record<string, Express.Multer.File[]>)?.['care_instruction_image']?.[0]?.filename || null,
        });
        await care.save();
      }
      careInstructionId = care._id;
    }

    // Update or create Festival
    let festivalId = null;
    if (festival_name) {
      let festival = await Festival.findOne({ _id: req.body.festival_objectId });
      if (festival) {
        festival.festival_name = festival_name;
        festival.isEnable = true;
        await festival.save();
      } else {
        festival = new Festival({ festival_name, isEnable: true });
        await festival.save();
      }
      festivalId = festival._id;
    }

    // Update or create Season
    let seasonId = null;
    if (season_name) {
      let season = await Season.findOne({ _id: req.body.season_objectId });
      if (season) {
        season.season_name = season_name;
        season.isEnable = true;
        await season.save();
      } else {
        season = new Season({ season_name, isEnable: true });
        await season.save();
      }
      seasonId = season._id;
    }

    // Update Product main
    const updatedProduct = await Product.findByIdAndUpdate(
      productId,
      {
        name,
        description,
        fabric_type,
        category_id,
        availabe_status,
        reviewObjectId,
        gender,
        season_objectId: seasonId,
        festival_objectId: festivalId,
        care_instruction_objectId: careInstructionId,
        weight,
        productType,
      },
      { new: true }
    );

    // Update Variants (simple strategy: delete old and insert new)
    await ProductVariant.deleteMany({ productObjectId: productId });
    const parsedVariants = JSON.parse(variants || '[]');
    for (const variant of parsedVariants) {
      const files = req.files as Record<string, Express.Multer.File[]>;
      const variantImageFile = files?.['variant_image']?.find((img) => img.originalname === variant.image_name);
      const newVariant = new ProductVariant({
        ...variant,
        productObjectId: productId,
        variant_image: variantImageFile ? variantImageFile.filename : null,
      });
      await newVariant.save();
    }

    // Update Product Images (delete old and add new)
    await ProductImage.deleteMany({ productObjectId: productId });
    const imageFiles = (req.files as Record<string, Express.Multer.File[]>)?.['images'] || [];
    for (let i = 0; i < imageFiles.length; i++) {
      const image = new ProductImage({
        productObjectId: productId,
        image: imageFiles[i].filename,
        is_primary: i === 0,
        sort_order: i,
      });
      await image.save();
    }

    res.status(200).json({ success: true, message: 'Product updated successfully', product: updatedProduct });
  } catch (error: any) {
    console.error('Update Product Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};
