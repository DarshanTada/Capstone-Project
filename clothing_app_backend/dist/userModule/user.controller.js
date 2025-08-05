"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getAllUsers = exports.logoutUser = exports.getUserById = exports.loginAdmin = exports.registerAdmin = exports.updateUser = exports.loginOrRegisterUser = exports.sendBulkEmailToUsers = exports.sendPromotionalEmailToUser = void 0;
const nodemailer_1 = __importDefault(require("nodemailer"));
const sendPromotionalEmailToUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { to, subject, message } = req.body;
    if (!to || !subject || !message) {
        res.status(400).json({ success: false, message: 'Missing required fields.' });
        return;
    }
    try {
        const transporter = nodemailer_1.default.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
        });
        yield transporter.sendMail({
            from: process.env.EMAIL_USER,
            to,
            subject,
            html: message,
        });
        res.json({ success: true, message: 'Email sent successfully!' });
    }
    catch (err) {
        res.status(500).json({ success: false, message: 'Failed to send email.', error: err });
    }
});
exports.sendPromotionalEmailToUser = sendPromotionalEmailToUser;
const sendBulkEmailToUsers = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
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
        const users = yield user_model_1.default.find({ email: { $in: emails } }).select('email').lean();
        const validEmails = users.map(u => u.email).filter(Boolean);
        if (validEmails.length === 0) {
            res.status(404).json({ success: false, message: 'No valid users found for provided emails.' });
            return;
        }
        const transporter = nodemailer_1.default.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
        });
        const sendPromises = validEmails
            .filter((email) => typeof email === 'string' && !!email)
            .map(email => transporter.sendMail({
            from: process.env.EMAIL_USER,
            to: email,
            subject,
            text: message,
        }));
        yield Promise.all(sendPromises);
        res.status(200).json({ success: true, message: `Email sent to ${validEmails.length} users.` });
    }
    catch (error) {
        console.error('Bulk Email Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.sendBulkEmailToUsers = sendBulkEmailToUsers;
const user_model_1 = __importDefault(require("./user.model"));
const preference_model_1 = __importDefault(require("./preference.model"));
const relationProfile_model_1 = __importDefault(require("./relationProfile.model"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const dotenv_1 = __importDefault(require("dotenv"));
const multer_1 = require("../utils/common/multer");
const bcryptjs_1 = __importDefault(require("bcryptjs"));
dotenv_1.default.config();
const JWT_SECRET = process.env.JWT_SECRET || "mySuperSecretKey123!";
exports.loginOrRegisterUser = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { phone_number } = req.body;
            if (!phone_number) {
                res.status(400).json({ success: false, message: "Phone number is required." });
                return;
            }
            const normalizedPhoneNumber = phone_number.trim();
            let user = yield user_model_1.default.findOne({ phone_number: normalizedPhoneNumber });
            let isNewUser = false;
            if (!user) {
                user = new user_model_1.default({ phone_number: normalizedPhoneNumber });
                yield user.save();
                isNewUser = true;
                const defaultPreference = new preference_model_1.default({
                    user: user._id,
                });
                yield defaultPreference.save();
            }
            const token = jsonwebtoken_1.default.sign({ userId: user._id, phone_number: user.phone_number }, JWT_SECRET, { expiresIn: "7d" });
            const userPreference = yield preference_model_1.default.findOne({ user: user._id });
            const relationProfiles = yield relationProfile_model_1.default.find({ user: user._id })
                .populate({
                path: 'preference',
                model: 'Preference'
            })
                .lean();
            const formattedRelationProfiles = relationProfiles.map((profile) => ({
                preference: profile.preference,
                isActive: profile.isActive,
                userId: profile.user
            }));
            const activeRelationProfile = relationProfiles.find((profile) => profile.isActive);
            const activePreference = (activeRelationProfile === null || activeRelationProfile === void 0 ? void 0 : activeRelationProfile.preference) || userPreference;
            const userData = yield user_model_1.default.findById(user._id).select('-password -token').lean();
            res.status(200).json({
                success: true,
                message: isNewUser ? "User registered successfully." : "Login successful.",
                token,
                isNewUser: isNewUser,
                data: {
                    user: userData,
                    relationProfile: formattedRelationProfiles,
                    preference: activePreference
                }
            });
        }
        catch (error) {
            console.error("User Auth Error:", error);
            res.status(500).json({ success: false, message: error.message });
        }
    })
];
exports.updateUser = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const authHeader = req.headers.authorization;
            if (!authHeader || !authHeader.startsWith("Bearer ")) {
                res.status(401).json({ success: false, message: "Unauthorized" });
                return;
            }
            const token = authHeader.split(" ")[1];
            const decoded = jsonwebtoken_1.default.verify(token, JWT_SECRET);
            const userId = decoded.userId;
            const { phone_number, email, role, username, gender, age, height, body_type, skin_tone, style, occasion, festivals, color_tones, size, undertone, userPhoto, avartarURL, } = req.body;
            const currentUser = yield user_model_1.default.findById(userId);
            if (!currentUser) {
                res.status(404).json({ success: false, message: "User not found" });
                return;
            }
            const userUpdateFields = Object.assign(Object.assign(Object.assign({}, (phone_number && { phone_number: phone_number.trim() })), (email && { email: email.trim().toLowerCase() })), (role && { role }));
            let updatedUser = null;
            if (Object.keys(userUpdateFields).length > 0) {
                updatedUser = yield user_model_1.default.findByIdAndUpdate(userId, userUpdateFields, {
                    new: true,
                }).select('-password -token');
                if (!updatedUser) {
                    res.status(404).json({ success: false, message: "User not found" });
                    return;
                }
            }
            else {
                updatedUser = yield user_model_1.default.findById(userId).select('-password -token');
            }
            const preferenceUpdateFields = Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign({}, (username && { username })), (gender && { gender })), (age && { age })), (height && { height })), (body_type && { body_type })), (skin_tone && { skin_tone })), (style && { style: Array.isArray(style) ? style : [style] })), (occasion && { occasion: Array.isArray(occasion) ? occasion : [occasion] })), (festivals && { festivals: Array.isArray(festivals) ? festivals : [festivals] })), (color_tones && { color_tones: Array.isArray(color_tones) ? color_tones : [color_tones] })), (size && { size })), (undertone && { undertone })), (userPhoto && { userPhoto })), (avartarURL && { avartarURL }));
            let updatedPreference = null;
            if (Object.keys(preferenceUpdateFields).length > 0) {
                updatedPreference = yield preference_model_1.default.findOneAndUpdate({ user: userId }, Object.assign(Object.assign({}, preferenceUpdateFields), { user: userId }), { new: true, upsert: true });
            }
            else {
                updatedPreference = yield preference_model_1.default.findOne({ user: userId });
            }
            const allRelationProfiles = yield relationProfile_model_1.default.find({ user: userId })
                .populate('preference')
                .lean();
            const formattedRelationProfiles = allRelationProfiles.map((profile) => ({
                preference: profile.preference,
                isActive: profile.isActive,
                userId: profile.user
            }));
            const activeRelationProfile = allRelationProfiles.find((profile) => profile.isActive);
            const activePreference = (activeRelationProfile === null || activeRelationProfile === void 0 ? void 0 : activeRelationProfile.preference) || updatedPreference;
            res.status(200).json({
                success: true,
                message: "User updated successfully",
                data: {
                    user: updatedUser,
                    relationProfile: formattedRelationProfiles,
                    preference: activePreference
                }
            });
        }
        catch (error) {
            console.error("Update User Error:", error);
            res.status(500).json({ success: false, message: error.message });
        }
    }),
];
exports.registerAdmin = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { email, password } = req.body;
            if (!email || !password) {
                res.status(400).json({ success: false, message: "Email and password are required." });
                return;
            }
            const normalizedEmail = email.trim().toLowerCase();
            const existingUser = yield user_model_1.default.findOne({ email: normalizedEmail });
            if (existingUser) {
                res.status(409).json({
                    success: false,
                    message: `Email '${normalizedEmail}' is already registered. Please use a different email.`
                });
                return;
            }
            const newUser = new user_model_1.default({
                email: normalizedEmail,
                password: yield bcryptjs_1.default.hash(password, 10),
                role: "admin"
            });
            yield newUser.save();
            const defaultPreference = new preference_model_1.default({
                user: newUser._id,
            });
            yield defaultPreference.save();
            const token = jsonwebtoken_1.default.sign({ userId: newUser._id, email: newUser.email, role: newUser.role }, JWT_SECRET, { expiresIn: "7d" });
            newUser.token = token;
            yield newUser.save();
            const userData = yield user_model_1.default.findById(newUser._id).select('-password -token').lean();
            res.status(201).json({
                success: true,
                message: "Admin registered successfully.",
                token,
                data: {
                    user: userData,
                    relationProfile: [],
                    preference: defaultPreference
                }
            });
        }
        catch (error) {
            console.error("Register Admin Error:", error);
            res.status(500).json({ success: false, message: error.message });
        }
    })
];
exports.loginAdmin = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { email, password } = req.body;
            if (!email || !password) {
                res.status(400).json({ message: 'Email and password are required.' });
                return;
            }
            const normalizedEmail = email.trim().toLowerCase();
            const user = yield user_model_1.default.findOne({ email: normalizedEmail });
            if (!user) {
                res.status(401).json({ message: 'User not found. Please register first.' });
                return;
            }
            if (!user.password) {
                res.status(401).json({ message: 'No password set for this user.' });
                return;
            }
            const isMatch = yield bcryptjs_1.default.compare(password, user.password);
            if (!isMatch) {
                res.status(401).json({ message: 'Invalid password.' });
                return;
            }
            const token = jsonwebtoken_1.default.sign({ userId: user._id, email: user.email, role: user.role }, JWT_SECRET, { expiresIn: '1d' });
            const userPreference = yield preference_model_1.default.findOne({ user: user._id });
            res.status(200).json({
                message: 'Login successful',
                accessToken: token,
                user: { _id: user._id, email: user.email, role: user.role },
                preferenceId: userPreference === null || userPreference === void 0 ? void 0 : userPreference._id,
            });
        }
        catch (err) {
            res.status(500).json({ message: err.message });
            return;
        }
    })
];
const getUserById = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const userId = req.body.userId || req.params.id || req.query.userId;
        if (!userId) {
            res.status(400).json({
                success: false,
                message: 'userId is required in body, params, or query.'
            });
            return;
        }
        const user = yield user_model_1.default.findById(userId)
            .select('-password -token')
            .lean();
        if (!user) {
            res.status(404).json({
                success: false,
                message: 'User not found.'
            });
            return;
        }
        const userPreference = yield preference_model_1.default.findOne({ user: userId }).lean();
        const relationProfiles = yield relationProfile_model_1.default.find({ user: userId })
            .populate({
            path: 'preference',
            model: 'Preference'
        })
            .lean();
        const formattedRelationProfiles = relationProfiles.map((profile) => ({
            preference: profile.preference,
            isActive: profile.isActive,
            userId: profile.user
        }));
        const activeRelationProfile = relationProfiles.find((profile) => profile.isActive);
        const activePreference = (activeRelationProfile === null || activeRelationProfile === void 0 ? void 0 : activeRelationProfile.preference) || userPreference;
        res.status(200).json({
            success: true,
            message: 'User data fetched successfully.',
            data: {
                user: user,
                relationProfile: formattedRelationProfiles,
                preference: activePreference
            }
        });
    }
    catch (error) {
        console.error("Get User By ID Error:", error);
        res.status(500).json({
            success: false,
            message: 'Server error while fetching user.',
            error: error.message
        });
    }
});
exports.getUserById = getUserById;
const logoutUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
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
        const decoded = jsonwebtoken_1.default.verify(token, JWT_SECRET);
        const userId = decoded.userId;
        const user = yield user_model_1.default.findById(userId);
        if (!user) {
            res.status(404).json({
                success: false,
                message: "User not found"
            });
            return;
        }
        yield user_model_1.default.findByIdAndUpdate(userId, {
            $unset: { token: 1 }
        });
        res.status(200).json({
            success: true,
            message: "Logout successful"
        });
    }
    catch (error) {
        console.error("Logout Error:", error);
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
});
exports.logoutUser = logoutUser;
const getAllUsers = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const users = yield user_model_1.default.find()
            .populate({
            path: 'preference',
            model: 'Preference'
        })
            .select('-password -token')
            .lean();
        const formattedUsers = yield Promise.all(users.map((user) => __awaiter(void 0, void 0, void 0, function* () {
            let userPreference = user.preference;
            if (!userPreference) {
                userPreference = yield preference_model_1.default.findOne({ user: user._id }).lean();
            }
            const relationProfiles = yield relationProfile_model_1.default.find({ user: user._id })
                .populate({
                path: 'preference',
                model: 'Preference'
            })
                .lean();
            const formattedRelationProfiles = relationProfiles.map((profile) => ({
                preference: profile.preference,
                isActive: profile.isActive,
                userId: profile.user
            }));
            const activeRelationProfile = relationProfiles.find((profile) => profile.isActive);
            const activePreference = (activeRelationProfile === null || activeRelationProfile === void 0 ? void 0 : activeRelationProfile.preference) || userPreference;
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
        })));
        res.status(200).json({
            success: true,
            message: 'All users fetched successfully.',
            data: formattedUsers
        });
    }
    catch (error) {
        console.error("Get All Users Error:", error);
        res.status(500).json({
            success: false,
            message: 'Server error while fetching users.',
            error: error.message
        });
    }
});
exports.getAllUsers = getAllUsers;
