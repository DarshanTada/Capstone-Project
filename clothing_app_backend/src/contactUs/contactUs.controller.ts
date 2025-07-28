import { sendMail } from '../utils/sendMail';
import { Request, Response } from 'express';
import ContactUs from './contactUs.model';

// Send Inquiry

// Reply to Inquiry
export const replyInquiry = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { subject, text } = req.body;
    const inquiry = await ContactUs.findById(id);
    if (!inquiry) {
      res.status(404).json({ success: false, message: 'Inquiry not found.' });
      return;
    }
    if (!inquiry.email || typeof inquiry.email !== 'string') {
      res.status(400).json({ success: false, message: 'Inquiry email is missing or invalid.' });
      return;
    }
    await sendMail({
      to: inquiry.email,
      subject: subject || `Reply to your inquiry: ${inquiry.subject}`,
      text: text || 'Thank you for contacting us. Here is our reply.',
    });
    res.status(200).json({ success: true, message: 'Reply sent to user.' });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const sendInquiry = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name, email, category, subject, message } = req.body;
    if (!name || !email || !category || !subject || !message) {
      res.status(400).json({ success: false, message: 'All fields are required.' });
      return;
    }
    const inquiry = new ContactUs({ name, email, category, subject, message });
    await inquiry.save();

    // Send confirmation email to user
    const { sendMail } = await import('../utils/sendMail');
    await sendMail({
      to: email,
      subject: `Thank you for your inquiry: ${subject}`,
      text: `Hi ${name},\n\nWe received your inquiry regarding "${category}".\n\n${message}\n\nWe will get back to you soon!\n\nBest,\nYoloChic Team`,
    });

    res.status(201).json({ success: true, data: inquiry });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get All Inquiries
export const getInquiries = async (_req: Request, res: Response): Promise<void> => {
  try {
    const inquiries = await ContactUs.find().sort({ createdAt: -1 });
    res.status(200).json({ success: true, data: inquiries });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete Inquiry
export const deleteInquiry = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const deleted = await ContactUs.findByIdAndDelete(id);
    if (!deleted) {
      res.status(404).json({ success: false, message: 'Inquiry not found.' });
      return;
    }
    res.status(200).json({ success: true, message: 'Inquiry deleted.' });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};
