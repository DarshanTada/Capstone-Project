import express from 'express';
import {
  createOrder,
  getAllOrders,
  getOrderById,
  getOrdersByUserId,
  updateProductStatus,
  cancelProduct
} from './order.controller';
import { upload } from '../utils/common/multer';

export const OrderRouter = express.Router();

// Order Management
OrderRouter.post('/createOrder', upload.none(), createOrder);
OrderRouter.get('/getOrder/:orderId', getOrderById);
OrderRouter.post('/getAllOrders', upload.none(), getAllOrders);
OrderRouter.post('/getUserOrders', upload.none(), getOrdersByUserId);

// Product Status Management within Orders
OrderRouter.post('/updateProductStatus', upload.none(), updateProductStatus);
OrderRouter.post('/cancelProduct', upload.none(), cancelProduct);

export default OrderRouter;
