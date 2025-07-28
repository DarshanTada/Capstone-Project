import Banner from '../bannerModule/banner.model';
import Category from '../categoryModule/category.model';
import SubCategory from '../subCategoryModule/subCategory.model';
import Product from '../productModule/product.model';
import ProductVariant from '../productModule/productVariant.model';
import { Request, Response } from 'express';
// Home API: Aggregates banners, categories, subcategories, and products with pagination and filtering
export const getHomeData = async (req: Request, res: Response): Promise<void> => {
  try {
    const page = Number(req.query.page) || 1;
    const limit = Number(req.query.limit) || 20;
    const category = req.query.category as string | undefined;
    const subcategory = req.query.subcategory as string | undefined;
    const skinTone = req.query.skinTone as string | undefined;
    const undertone = req.query.undertone as string | undefined;
    const height = req.query.height as string | undefined;
    const bodyType = req.query.bodyType as string | undefined;

    // 1. Banners
    const banners = await Banner.find({});
    const seasonalBanners = await Banner.find({ type: 'seasonal' });

    // 2. Popular Categories
    const popularCategories = await Category.find({ is_popular: true });

    // 3. Chic Starts Here (curated subcategories)
    const chicSubcategories = await SubCategory.find({ is_curated: true });

    // 4. Discounted Products
    const discountedVariants = await ProductVariant.find({ discount: { $gt: 0 } });
    const discountedProductIds = discountedVariants.map(v => v.productObjectId);
    const discountedProducts = await Product.find({ _id: { $in: discountedProductIds } });

    // 5. New Arrivals
    const newVariants = await ProductVariant.find().sort({ createdAt: -1 }).limit(20);
    const newProductIds = newVariants.map(v => v.productObjectId);
    const newArrivals = await Product.find({ _id: { $in: newProductIds } });

    // 6. Best Seller
    const bestSellerVariants = await ProductVariant.find().sort({ sales: -1 }).limit(20);
    const bestSellerProductIds = bestSellerVariants.map(v => v.productObjectId);
    const bestSellers = await Product.find({ _id: { $in: bestSellerProductIds } });

    // 7. Clearance
    const clearanceVariants = await ProductVariant.find({ is_clearance: true });
    const clearanceProductIds = clearanceVariants.map(v => v.productObjectId);
    const clearanceProducts = await Product.find({ _id: { $in: clearanceProductIds } });

    // 8. All Products (with filters and pagination)
    let productQuery: any = {};
    if (category) productQuery.categoryObjectId = category;
    if (subcategory) productQuery.subcategoryObjectId = subcategory;
    if (skinTone) productQuery.skin_tone = skinTone;
    if (undertone) productQuery.under_tone = undertone;
    if (height) productQuery.height = height;
    if (bodyType) productQuery.body_type = bodyType;

    const allProducts = await Product.find(productQuery)
      .skip((page - 1) * limit)
      .limit(limit);
    const totalCount = await Product.countDocuments(productQuery);

    // Attach variants to each product
    const productIds = allProducts.map(p => p._id);
    const allVariants = await ProductVariant.find({ productObjectId: { $in: productIds } });
    const productsWithVariants = allProducts.map(product => {
      const variants = allVariants.filter(v => v.productObjectId && v.productObjectId.toString() === product._id.toString());
      return { ...product.toObject(), variants };
    });

    res.status(200).json({
      success: true,
      data: {
        banners,
        seasonalBanners,
        popularCategories,
        chicSubcategories,
        discountedProducts,
        newArrivals,
        bestSellers,
        clearanceProducts,
        allProducts: productsWithVariants,
      },
      page,
      limit,
      totalCount,
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};
