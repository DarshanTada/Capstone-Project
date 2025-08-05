// Send individual promotional email to a user
import nodemailer from 'nodemailer';
import { Request, Response } from 'express';

export const sendPromotionalEmailToUser = async (req: Request, res: Response): Promise<void> => {
  const { to, subject, message } = req.body;
  if (!to || !subject || !message) {
    res.status(400).json({ success: false, message: 'Missing required fields.' });
    return;
  }
  try {
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });
    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to,
      subject,
      html: message,
    });
    res.json({ success: true, message: 'Email sent successfully!' });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to send email.', error: err });
  }
};

export const sendBulkEmailToUsers = async (req: Request, res: Response): Promise<void> => {
  try {
    const { emails, subject, message } = req.body;
    if (!Array.isArray(emails) || emails.length === 0) {
      res.status(400).json({ success: false, message: 'Emails array is required.' });
      return;
    }
    if (!subject || !message) {
      res.status(400).json({ success: false, message: 'Subject and message are required.' });
      return;
    }

    // Get all users with email address in the provided list
    const users = await User.find({ email: { $in: emails } }).select('email').lean();
    const validEmails = users.map(u => u.email).filter(Boolean);
    if (validEmails.length === 0) {
      res.status(404).json({ success: false, message: 'No valid users found for provided emails.' });
      return;
    }

    // Setup nodemailer transporter (use your SMTP config)
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    // Send email to each user
    const sendPromises = validEmails
      .filter((email): email is string => typeof email === 'string' && !!email)
      .map(email =>
        transporter.sendMail({
          from: process.env.EMAIL_USER,
          to: email,
          subject,
          text: message,
        })
      );
    await Promise.all(sendPromises);

    res.status(200).json({ success: true, message: `Email sent to ${validEmails.length} users.` });
  } catch (error: any) {
    console.error('Bulk Email Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};
import User from './user.model';
import Preference from './preference.model';
import RelationProfile from './relationProfile.model';
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
// import multer from "multer";
import { upload } from '../utils/common/multer'
import bcrypt from 'bcryptjs'


dotenv.config()
const JWT_SECRET = process.env.JWT_SECRET || "mySuperSecretKey123!";
// const upload = multer({ dest: "uploads/" });

export const loginOrRegisterUser = [
  upload.none(), // Handles form-data with only text fields
  async (req: Request, res: Response): Promise<void> => {
    try {
      const { phone_number } = req.body;

      if (!phone_number) {
        res.status(400).json({ success: false, message: "Phone number is required." });
        return;
      }

      // Normalize phone number
      const normalizedPhoneNumber = phone_number.trim();

      // Try to find the user
      let user = await User.findOne({ phone_number: normalizedPhoneNumber });

      let isNewUser = false;

      // If user doesn't exist, register them
      if (!user) {
        user = new User({ phone_number: normalizedPhoneNumber });
        await user.save();
        isNewUser = true;

        // Create default preference for new user
        const defaultPreference = new Preference({
          user: user._id,
          // All fields will use their default values or be empty
        });
        await defaultPreference.save();
      }

      // Create JWT token
      const token = jwt.sign(
        { userId: user._id, phone_number: user.phone_number },
        JWT_SECRET,
        { expiresIn: "7d" }
      );

      // Get user's preference for response
      const userPreference = await Preference.findOne({ user: user._id });

      // Get all relation profiles for this user with populated preference data
      const relationProfiles = await RelationProfile.find({ user: user._id })
        .populate({
          path: 'preference',
          model: 'Preference'
        })
        .lean();

      // Format relation profiles according to your structure
      const formattedRelationProfiles = relationProfiles.map((profile: any) => ({
        preference: profile.preference,
        isActive: profile.isActive,
        userId: profile.user
      }));

      // Find the active relation profile preference (if any)
      const activeRelationProfile = relationProfiles.find((profile: any) => profile.isActive);
      const activePreference = activeRelationProfile?.preference || userPreference;

      // Get user data without sensitive fields
      const userData = await User.findById(user._id).select('-password -token').lean();

      res.status(200).json({
        success: true,
        message: isNewUser ? "User registered successfully." : "Login successful.",
        token,
        isNewUser: isNewUser, // Flag to indicate if user is new
        data: {
          user: userData,
          relationProfile: formattedRelationProfiles,
          preference: activePreference // Return active preference or user's own preference
        }
      });
    } catch (error: any) {
      console.error("User Auth Error:", error);
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
        phone_number,
        email,
        role,
        username,
        gender,
        age,
        height,
        body_type,
        skin_tone,
        style,
        occasion,
        festivals,
        color_tones,
        size,
        undertone,
        userPhoto,
        avartarURL,
      } = req.body;

      // Get current user to check if they're updating to the same values
      const currentUser = await User.findById(userId);
      if (!currentUser) {
        res.status(404).json({ success: false, message: "User not found" });
        return;
      }

      // ✅ Allow any phone number or email update without validation
      // Users can update their details freely

      // Update User data (removed name field)
      const userUpdateFields: any = {
        ...(phone_number && { phone_number: phone_number.trim() }),
        ...(email && { email: email.trim().toLowerCase() }),
        ...(role && { role })
      };

      let updatedUser = null;
      if (Object.keys(userUpdateFields).length > 0) {
        updatedUser = await User.findByIdAndUpdate(userId, userUpdateFields, {
          new: true,
        }).select('-password -token');

        if (!updatedUser) {
          res.status(404).json({ success: false, message: "User not found" });
          return;
        }
      } else {
        updatedUser = await User.findById(userId).select('-password -token');
      }

      // Update or Create User's Preference
      const preferenceUpdateFields: any = {
        ...(username && { username }),
        ...(gender && { gender }),
        ...(age && { age }),
        ...(height && { height }),
        ...(body_type && { body_type }),
        ...(skin_tone && { skin_tone }),
        ...(style && { style: Array.isArray(style) ? style : [style] }),
        ...(occasion && { occasion: Array.isArray(occasion) ? occasion : [occasion] }),
        ...(festivals && { festivals: Array.isArray(festivals) ? festivals : [festivals] }),
        ...(color_tones && { color_tones: Array.isArray(color_tones) ? color_tones : [color_tones] }),
        ...(size && { size }),
        ...(undertone && { undertone }),
        ...(userPhoto && { userPhoto }),
        ...(avartarURL && { avartarURL })
      };

      let updatedPreference = null;
      if (Object.keys(preferenceUpdateFields).length > 0) {
        // Update existing preference or create new one
        updatedPreference = await Preference.findOneAndUpdate(
          { user: userId },
          { ...preferenceUpdateFields, user: userId },
          { new: true, upsert: true } // Create if doesn't exist
        );
      } else {
        updatedPreference = await Preference.findOne({ user: userId });
      }

      // Get all relation profiles for response (read-only, no creation/updates)
      const allRelationProfiles = await RelationProfile.find({ user: userId })
        .populate('preference')
        .lean();

      // Format relation profiles according to your structure
      const formattedRelationProfiles = allRelationProfiles.map((profile: any) => ({
        preference: profile.preference,
        isActive: profile.isActive,
        userId: profile.user
      }));

      // Find the active relation profile preference (if any)
      const activeRelationProfile = allRelationProfiles.find((profile: any) => profile.isActive);
      const activePreference = activeRelationProfile?.preference || updatedPreference;

      res.status(200).json({
        success: true,
        message: "User updated successfully",
        data: {
          user: updatedUser,
          relationProfile: formattedRelationProfiles,
          preference: activePreference
        }
      });
    } catch (error: any) {
      console.error("Update User Error:", error);
      res.status(500).json({ success: false, message: error.message });
    }
  },
];

export const registerAdmin = [
  upload.none(), // Handle form-data with text fields only
  async (req: Request, res: Response): Promise<void> => {
    try {
      const {
        email,
        password
      } = req.body;

      // Validate required fields
      if (!email || !password) {
        res.status(400).json({ success: false, message: "Email and password are required." });
        return;
      }

      // Normalize email
      const normalizedEmail = email.trim().toLowerCase();

      // ✅ Check if email already exists (manual validation)
      const existingUser = await User.findOne({ email: normalizedEmail });
      if (existingUser) {
        res.status(409).json({
          success: false,
          message: `Email '${normalizedEmail}' is already registered. Please use a different email.`
        });
        return;
      }

      // Create new admin user
      const newUser = new User({
        email: normalizedEmail,
        password: await bcrypt.hash(password, 10), // Hash password
        role: "admin" // Set role as Admin by default
      });

      // Save user
      await newUser.save();

      // Create default preference for admin (like regular user registration)
      const defaultPreference = new Preference({
        user: newUser._id,
        // All fields will use their default values or be empty
      });
      await defaultPreference.save();

      // Generate JWT token
      const token = jwt.sign(
        { userId: newUser._id, email: (newUser as any).email, role: (newUser as any).role },
        JWT_SECRET,
        { expiresIn: "7d" }
      );

      // Save token in user
      (newUser as any).token = token;
      await newUser.save();

      // Get user data without sensitive fields
      const userData = await User.findById(newUser._id).select('-password -token').lean();

      res.status(201).json({
        success: true,
        message: "Admin registered successfully.",
        token,
        data: {
          user: userData,
          relationProfile: [], // Empty array like in loginOrRegisterUser
          preference: defaultPreference // Return the created preference
        }
      });
    } catch (error: any) {
      console.error("Register Admin Error:", error);
      res.status(500).json({ success: false, message: error.message });
    }
  }
];


// Admin Login
export const loginAdmin = [
  upload.none(), // Handle form-data with text fields only
  async (req: Request, res: Response): Promise<void> => {
    try {
      const { email, password } = req.body

      if (!email || !password) {
        res.status(400).json({ message: 'Email and password are required.' });
        return;
      }

      // Normalize email for lookup
      const normalizedEmail = email.trim().toLowerCase();

      const user = await User.findOne({ email: normalizedEmail })
      if (!user) {
        res.status(401).json({ message: 'User not found. Please register first.' });
        return;
      }

      if (!user.password) {
        res.status(401).json({ message: 'No password set for this user.' });
        return;
      }

      const isMatch = await bcrypt.compare(password, user.password)
      if (!isMatch) {
        res.status(401).json({ message: 'Invalid password.' });
        return;
      }
      const token = jwt.sign(
        { userId: user._id, email: user.email, role: user.role },
        JWT_SECRET,
        { expiresIn: '1d' }
      )

      // Get user's preference for response
      const userPreference = await Preference.findOne({ user: user._id });

      res.status(200).json({
        message: 'Login successful',
        accessToken: token,
        user: { _id: user._id, email: user.email, role: user.role },
        preferenceId: userPreference?._id, // Include preferenceId in response
      })
    } catch (err: any) {
      res.status(500).json({ message: err.message })
      return;
    }
  }
]


export const getUserById = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.body.userId || req.params.id || req.query.userId;

    if (!userId) {
      res.status(400).json({
        success: false,
        message: 'userId is required in body, params, or query.'
      });
      return;
    }

    // Get user data
    const user = await User.findById(userId)
      .select('-password -token') // Remove sensitive data
      .lean();

    if (!user) {
      res.status(404).json({
        success: false,
        message: 'User not found.'
      });
      return;
    }

    // Get user's own preference
    const userPreference = await Preference.findOne({ user: userId }).lean();

    // Get all relation profiles for this user with populated preference data
    const relationProfiles = await RelationProfile.find({ user: userId })
      .populate({
        path: 'preference',
        model: 'Preference'
      })
      .lean();

    // Format relation profiles according to your structure
    const formattedRelationProfiles = relationProfiles.map((profile: any) => ({
      preference: profile.preference,
      isActive: profile.isActive,
      userId: profile.user
    }));

    // Find the active relation profile preference (if any)
    const activeRelationProfile = relationProfiles.find((profile: any) => profile.isActive);
    const activePreference = activeRelationProfile?.preference || userPreference;

    res.status(200).json({
      success: true,
      message: 'User data fetched successfully.',
      data: {
        user: user,
        relationProfile: formattedRelationProfiles,
        preference: activePreference // Return active preference or user's own preference
      }
    });
  } catch (error: any) {
    console.error("Get User By ID Error:", error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching user.',
      error: error.message
    });
  }
};

// Logout User
export const logoutUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      res.status(401).json({ 
        success: false, 
        message: "Unauthorized - No token provided" 
      });
      return;
    }

    const token = authHeader.split(" ")[1];
    
    // Verify the token
    const decoded: any = jwt.verify(token, JWT_SECRET);
    const userId = decoded.userId;

    // Find the user and clear their token
    const user = await User.findById(userId);
    
    if (!user) {
      res.status(404).json({
        success: false,
        message: "User not found"
      });
      return;
    }

    // Clear the user's token from database
    await User.findByIdAndUpdate(userId, { 
      $unset: { token: 1 } // Remove token field
    });

    res.status(200).json({
      success: true,
      message: "Logout successful"
    });

  } catch (error: any) {
    console.error("Logout Error:", error);
    
    // Handle JWT specific errors
    if (error.name === 'JsonWebTokenError') {
      res.status(401).json({
        success: false,
        message: "Invalid token"
      });
      return;
    }
    
    if (error.name === 'TokenExpiredError') {
      res.status(401).json({
        success: false,
        message: "Token expired"
      });
      return;
    }

    res.status(500).json({
      success: false,
      message: "Server error during logout",
      error: error.message
    });
  }
};

export const getAllUsers = async (req: Request, res: Response): Promise<void> => {
  try {
    // Get all users with their preferences
    const users = await User.find()
      .populate({
        path: 'preference',
        model: 'Preference'
      })
      .select('-password -token') // 🔒 remove sensitive fields
      .lean();

    // For each user, get their relation profiles and format the response
    const formattedUsers = await Promise.all(
      users.map(async (user: any) => {
        // Get user's own preference if not populated
        let userPreference = user.preference;
        if (!userPreference) {
          userPreference = await Preference.findOne({ user: user._id }).lean();
        }

        // Get all relation profiles for this user
        const relationProfiles = await RelationProfile.find({ user: user._id })
          .populate({
            path: 'preference',
            model: 'Preference'
          })
          .lean();

        // Format relation profiles
        const formattedRelationProfiles = relationProfiles.map((profile: any) => ({
          preference: profile.preference,
          isActive: profile.isActive,
          userId: profile.user
        }));

        // Find the active relation profile preference (if any)
        const activeRelationProfile = relationProfiles.find((profile: any) => profile.isActive);
        const activePreference = activeRelationProfile?.preference || userPreference;

        return {
          user: {
            _id: user._id,
            phone_number: user.phone_number,
            email: user.email,
            role: user.role,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt
          },
          relationProfile: formattedRelationProfiles,
          preference: activePreference
        };
      })
    );

    res.status(200).json({
      success: true,
      message: 'All users fetched successfully.',
      data: formattedUsers
    });
  } catch (error: any) {
    console.error("Get All Users Error:", error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching users.',
      error: error.message
    });
  }
};

// Delete User
export const deleteUser = [
  upload.none(), // Handle form-data with text fields only
  async (req: Request, res: Response): Promise<void> => {
    try {
      const authHeader = req.headers.authorization;

      if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ 
          success: false, 
          message: "Unauthorized - No token provided" 
        });
        return;
      }

      const token = authHeader.split(" ")[1];
      
      // Verify the token
      const decoded: any = jwt.verify(token, JWT_SECRET);
      const currentUserId = decoded.userId;

      // Get userId from request body, params, or query
      const userIdToDelete = req.body.userId || req.params.id || req.query.userId;

      if (!userIdToDelete) {
        res.status(400).json({
          success: false,
          message: 'userId is required in body, params, or query.'
        });
        return;
      }

      // Check if user exists
      const userToDelete = await User.findById(userIdToDelete);
      if (!userToDelete) {
        res.status(404).json({
          success: false,
          message: 'User not found.'
        });
        return;
      }

      // Get current user to check permissions
      const currentUser = await User.findById(currentUserId);
      if (!currentUser) {
        res.status(401).json({
          success: false,
          message: 'Current user not found.'
        });
        return;
      }

      // Check permissions: Admin can delete any user, Users can only delete themselves
      if (currentUser.role !== 'admin' && currentUserId !== userIdToDelete) {
        res.status(403).json({
          success: false,
          message: 'Forbidden - You can only delete your own account or you need admin privileges.'
        });
        return;
      }

      // Delete related data first
      // Delete user's preferences
      await Preference.deleteMany({ user: userIdToDelete });

      // Delete user's relation profiles
      await RelationProfile.deleteMany({ user: userIdToDelete });

      // Note: You might want to handle other related data like:
      // - Orders associated with this user
      // - Cart items
      // - Addresses
      // Add those deletions here as needed

      // Finally, delete the user
      await User.findByIdAndDelete(userIdToDelete);

      res.status(200).json({
        success: true,
        message: `User ${userToDelete.email || userToDelete.phone_number} deleted successfully.`,
        deletedUserId: userIdToDelete
      });

    } catch (error: any) {
      console.error("Delete User Error:", error);
      
      // Handle JWT specific errors
      if (error.name === 'JsonWebTokenError') {
        res.status(401).json({
          success: false,
          message: "Invalid token"
        });
        return;
      }
      
      if (error.name === 'TokenExpiredError') {
        res.status(401).json({
          success: false,
          message: "Token expired"
        });
        return;
      }

      res.status(500).json({
        success: false,
        message: "Server error while deleting user.",
        error: error.message
      });
    }
  }
];
