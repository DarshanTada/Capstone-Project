import { Request, Response } from 'express';
import Category from './category.model';
import Product from '../productModule/product.model';
import ProductVariant from '../productModule/productVariant.model';
import ProductImage from '../productModule/productImage.model';
import Banner from '../bannerModule/banner.model';
import { upload } from '../utils/common/multer';

export const uploadCategoryImage = upload.fields([
  { name: 'image', maxCount: 1 },
]);

// Create Category
export const createCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name } = req.body;
    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageFile = files?.['image']?.[0];

    if (!name) {
      res.status(400).json({
        success: false,
        message: "Category name is required.",
      });
      return;
    }

    console.log('req.body:', req.body);
    console.log('req.files:', req.files);

    let imageBase64: string | undefined;

    if (imageFile && imageFile.buffer) {
      imageBase64 = `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`;
    }

    const newCategory = new Category({
      name,
      ...(imageBase64 && { image: imageBase64 }),
    });

    await newCategory.save();

    res.status(200).json({ success: true, data: newCategory });
  } catch (error: any) {
    console.error('Create Category Error:', error);
    res.status(500).json({ success: false, message: `Create Category Error: ${error.message}` });
  }
};

// Update Category
export const updateCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { name } = req.body;
    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageFile = files?.['image']?.[0];

    const updateData: any = {};

    if (name !== undefined) updateData.name = name;

    if (imageFile) {
      const imageBase64 = `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`;
      updateData.image = imageBase64;
    }

    const updatedCategory = await Category.findByIdAndUpdate(id, updateData, {
      new: true,
      runValidators: true
    });

    if (!updatedCategory) {
      res.status(404).json({ success: false, message: 'Category not found' });
      return;
    }

    res.status(200).json({
      success: true,
      message: 'Category updated successfully',
      data: updatedCategory
    });
  } catch (error: any) {
    console.error('Update Category Error:', error);
    res.status(500).json({ success: false, message: `Update Category Error: ${error.message}` });
  }
};

// Read all Categories
export const getAllCategories = async (req: Request, res: Response): Promise<void> => {
  try {
    const categories = await Category.find();

    const formatted = categories.map((cat) => ({
      _id: cat._id,
      name: cat.name,
      image: cat.image || null,
    }));

    res.status(200).json({ success: true, data: formatted });
  } catch (error: any) {
    console.error('Get Category Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get Products by Category with specific structure (POST version)
export const getProductsByCategoryPost = async (req: Request, res: Response): Promise<void> => {
  try {
    const { bodyType, gender } = req.body;

    // Build match condition for products based on bodyType and gender
    let topMatchCondition: any = { productType: 'top' };
    let bottomMatchCondition: any = { productType: 'bottom' };

    if (bodyType) {
      topMatchCondition['subcategory.body_type'] = bodyType;
      bottomMatchCondition['subcategory.body_type'] = bodyType;
    }

    if (gender) {
      // Match gender in both subcategory and product
      topMatchCondition['subcategory.gender'] = gender;
      topMatchCondition['gender'] = gender;
      bottomMatchCondition['subcategory.gender'] = gender;
      bottomMatchCondition['gender'] = gender;
    }

    // Get 6 random top products (filtered by bodyType and gender if provided)
    const topProducts = await Product.aggregate([
      {
        $lookup: {
          from: 'subcategories',
          localField: 'subcategory_id',
          foreignField: '_id',
          as: 'subcategory'
        }
      },
      {
        $match: topMatchCondition
      },
      { $sample: { size: 6 } }
    ]);

    // Get 6 random bottom products (filtered by bodyType and gender if provided)
    const bottomProducts = await Product.aggregate([
      {
        $lookup: {
          from: 'subcategories',
          localField: 'subcategory_id',
          foreignField: '_id',
          as: 'subcategory'
        }
      },
      {
        $match: bottomMatchCondition
      },
      { $sample: { size: 6 } }
    ]);

    // Populate product details for tops
    const populatedTopProducts = await Product.populate(topProducts, [
      // { path: 'category_id' },
      // { path: 'subcategory_id' },
      // { path: 'care_instruction_objectId' },
      // { path: 'season_objectId' },
      // { path: 'festival_objectId' }
    ]);

    // Populate product details for bottoms
    const populatedBottomProducts = await Product.populate(bottomProducts, [
      // { path: 'category_id' },
      // { path: 'subcategory_id' },
      // { path: 'care_instruction_objectId' },
      // { path: 'season_objectId' },
      // { path: 'festival_objectId' }
    ]);

    // Get variants and images for top products
    const topProductIds = populatedTopProducts.map(p => p._id);
    const topVariants = await ProductVariant.find({ productObjectId: { $in: topProductIds } });
    const topImages = await ProductImage.find({ productObjectId: { $in: topProductIds } });

    // Get variants and images for bottom products
    const bottomProductIds = populatedBottomProducts.map(p => p._id);
    const bottomVariants = await ProductVariant.find({ productObjectId: { $in: bottomProductIds } });
    const bottomImages = await ProductImage.find({ productObjectId: { $in: bottomProductIds } });

    // Enrich top products with variants and images
    const enrichedTopProducts = populatedTopProducts.map(product => {
      const productVariants = topVariants.filter(v => String(v.productObjectId) === String(product._id));
      const productImages = topImages.filter(img => String(img.productObjectId) === String(product._id));
      return { ...product, variants: productVariants, images: productImages };
    });

    // Enrich bottom products with variants and images
    const enrichedBottomProducts = populatedBottomProducts.map(product => {
      const productVariants = bottomVariants.filter(v => String(v.productObjectId) === String(product._id));
      const productImages = bottomImages.filter(img => String(img.productObjectId) === String(product._id));
      return { ...product, variants: productVariants, images: productImages };
    });

    // Get ALL seasonal banners with type "seasonal"
    const banners = await Banner.find({ is_active: true, type: "seasonal" });

    // Get categories filtered by gender if provided
    let categories;
    if (gender) {
      // Get ALL categories that have subcategories with matching gender
      categories = await Category.aggregate([
        {
          $lookup: {
            from: 'subcategories',
            localField: '_id',
            foreignField: 'category_id',
            as: 'subcategories'
          }
        },
        {
          $match: {
            'subcategories.gender': gender
          }
        },
        {
          $project: {
            _id: 1,
            name: 1,
            image: 1
          }
        }
      ]);
    } else {
      // Get ALL categories if no gender filter
      categories = await Category.find();
    }

    // Build response structure
    const response = [
      {
        name: "Top",
        products: enrichedTopProducts
      },
      {
        name: "Bottom", 
        products: enrichedBottomProducts
      },
      {
        banners: banners
      },
      {
        category: categories.map(category => ({
          _id: category._id,
          name: category.name,
          image: category.image || null
        }))
      }
    ];

    res.status(200).json({
      success: true,
      data: response,
      filters: {
        bodyType: bodyType || 'all',
        gender: gender || 'all'
      }
    });

  } catch (error: any) {
    console.error('Get Products by Category Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete Category
export const deleteCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const deleted = await Category.findByIdAndDelete(req.params.id);
    if (!deleted) {
      res.status(404).json({ success: false, message: 'Category not found' });
      return;
    }
    res.status(200).json({ success: true, message: 'Category deleted successfully' });
  } catch (err: any) {
    res.status(500).json({ success: false, message: err.message });
  }
};

