import express from 'express';
import { upload } from '../utils/common/multer';
import { addAddress, getAllAddressesByUserId, updateAddress, deleteAddress } from './address.controller';

export const AddressRouter = express.Router();

AddressRouter.post('/addAddress', upload.none(), addAddress);
AddressRouter.post('/getAddressesByuserId', upload.none(), getAllAddressesByUserId);
AddressRouter.post('/updateAddress', upload.none(), updateAddress);
AddressRouter.post('/deleteAddress', upload.none(), deleteAddress);
export default AddressRouter;
