import { Request, Response } from 'express';
import User from './user.model';
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import multer from "multer";


dotenv.config()
const JWT_SECRET = process.env.JWT_SECRET || "mySuperSecretKey123!";
const upload = multer()


export const registerUser = [
  upload.none(), // ⬅️ This handles form-data with only text fields
  async (req: Request, res: Response): Promise<void> => {
    try {
      const { phone_number } = req.body;

      if (!phone_number) {
        res.status(400).json({ success: false, message: "Phone number is required." });
        return;
      }

      let user = await User.findOne({ phone_number });

      if (!user) {
        user = new User({ phone_number });
        await user.save();
      }

      const token = jwt.sign(
        { userId: user._id, phone_number: user.phone_number },
        JWT_SECRET,
        { expiresIn: "7d" }
      );

      res.status(200).json({
        success: true,
        message: "User registered successfully.",
        token,
        userId: user._id,
      });
    } catch (error: any) {
      console.error("Register User Error:", error);
      res.status(500).json({ success: false, message: error.message });
    }
  }
];

//Update User
export const updateUser = [
  upload.none(), // handle form-data
  async (req: Request, res: Response): Promise<void> => {
    try {
      const authHeader = req.headers.authorization;

      if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ success: false, message: "Unauthorized" });
        return;
      }

      const token = authHeader.split(" ")[1];
      const decoded: any = jwt.verify(token, JWT_SECRET);

      const userId = decoded.userId;

      const {
        name,
        phone_number,
        email,
        gender,
        age,
        body_type,
        height,
        color_palette,
        size,
        role,
      } = req.body;

      const updateFields: any = {
        ...(name && { name }),
        ...(phone_number && { phone_number }),
        ...(email && { email }),
        ...(gender && { gender }),
        ...(age && { age }),
        ...(body_type && { body_type }),
        ...(height && { height }),
        ...(color_palette && { color_palette }),
        ...(size && { size }),
        ...(role && { role })
      };

      const updatedUser = await User.findByIdAndUpdate(userId, updateFields, {
        new: true,
      });

      if (!updatedUser) {
        res.status(404).json({ success: false, message: "User not found" });
        return;
      }

      res.status(200).json({
        success: true,
        message: "User updated successfully",
        data: updatedUser,
      });
    } catch (error: any) {
      console.error("Update User Error:", error);
      res.status(500).json({ success: false, message: error.message });
    }
  },
];

export const loginUser = [
  upload.none(), // for form-data with text only
  async (req: Request, res: Response): Promise<void> => {
    try {
      const { phone_number } = req.body;

      if (!phone_number) {
        res.status(400).json({ success: false, message: "Phone number is required." });
        return;
      }

      const user = await User.findOne({ phone_number });

      if (!user) {
        res.status(401).json({ success: false, message: "User not found. Please register first." });
        return;
      }

      const token = jwt.sign(
        { userId: user._id, phone_number: user.phone_number },
        JWT_SECRET,
        { expiresIn: "7d" }
      );

      res.status(200).json({
        success: true,
        message: "Login successful",
        token,
        userId: user._id,
      });
    } catch (error: any) {
      console.error("Login User Error:", error);
      res.status(500).json({ success: false, message: error.message });
    }
  },
];