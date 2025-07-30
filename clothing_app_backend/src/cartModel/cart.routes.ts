import express from 'express';
import {
  addToCart,
  updateCartQuantity,
  removeFromCart,
  getCart,
  clearCart
} from './cart.controller';
import { upload } from '../utils/common/multer';

export const CartRouter = express.Router();

// Cart Management (All using form-data)
CartRouter.post('/addToCart', upload.none(), addToCart);
CartRouter.post('/updateQuantity', upload.none(), updateCartQuantity);
CartRouter.post('/removeFromCart', upload.none(), removeFromCart);
CartRouter.post('/getCart', upload.none(), getCart);
CartRouter.post('/clearCart', upload.none(), clearCart);

export default CartRouter;
