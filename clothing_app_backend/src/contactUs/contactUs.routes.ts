import express from 'express';
import { sendInquiry, getInquiries, deleteInquiry } from './contactUs.controller';
import { replyInquiry } from './contactUs.controller';
import {upload} from '../utils/common/multer'

export const ContactUsRouter = express.Router();

// Send Inquiry (Create)
ContactUsRouter.post('/sendInquiry', upload.none(), sendInquiry);

// Get All Inquiries
ContactUsRouter.get('/getInquiries', getInquiries);

// Delete Inquiry
ContactUsRouter.delete('/deleteInquiry/:id', deleteInquiry);
// Reply to Inquiry
ContactUsRouter.post('/replyInquiry/:id', upload.none(),  replyInquiry);

export default ContactUsRouter;
