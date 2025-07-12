import express from 'express';
import {
  createProduct,
  updateProduct,
  getAllProducts,
  deleteProduct
} from '../productModule/product.controller';
import { upload } from '../utils/common/multer';

export const ProductRouter = express.Router();

ProductRouter.post(
  '/createProducts',
  upload.any(),
  createProduct
);
ProductRouter.put('/updateProduct/:id', upload.any(), updateProduct);
ProductRouter.get('/getProduct', getAllProducts);
ProductRouter.delete('/deleteProduct/:productId', deleteProduct);

export default ProductRouter;