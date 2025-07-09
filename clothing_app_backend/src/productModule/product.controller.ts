import { Request, Response, NextFunction } from 'express';
import Product from '../productModule/product.model';
import ProductVariant from '../productModule/productVariant.model';
import ProductImage from '../productModule/productImage.model';
import CareInstruction from '../productModule/careInstruction.model';
import Festival from '../festivalModule/festival.model';
import Season from '../seasonModule/season.model';
import dotenv from "dotenv";
import { upload } from '../utils/common/multer';

dotenv.config()


