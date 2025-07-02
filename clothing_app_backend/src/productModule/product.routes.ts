import express from 'express';
import {
  getAllProducts,
  getProduct,
  deleteProduct,
  createProduct,
  updateProduct
} from '../productModule/product.controller';
import { upload } from '../utils/common/multer'

const router = express.Router();

// GET all products
router.get('/', getAllProducts);

// GET a specific product by ID
// router.get('/:id', getProduct);

// // DELETE a product by ID
// router.delete('/:id', deleteProduct);

// CREATE a new product (with images & variants)
router.post(
  '/',
  upload.fields([
    { name: 'care_instruction_image', maxCount: 1 },
    { name: 'images', maxCount: 10 },
    { name: 'variant_image', maxCount: 10 }
  ]),
  createProduct
);

// UPDATE a product by ID
router.put(
  '/:id',
  upload.fields([
    { name: 'care_instruction_image', maxCount: 1 },
    { name: 'images', maxCount: 10 },
    { name: 'variant_image', maxCount: 10 }
  ]),
  updateProduct
);

