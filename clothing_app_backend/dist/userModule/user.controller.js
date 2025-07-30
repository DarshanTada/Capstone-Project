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
exports.getAllUsers = exports.getUserById = exports.loginAdmin = exports.registerAdmin = exports.loginUser = exports.updateUser = exports.loginOrRegisterUser = void 0;
const user_model_1 = __importDefault(require("./user.model"));
const preference_model_1 = __importDefault(require("../preferenceModule/preference.model"));
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
            let user = yield user_model_1.default.findOne({ phone_number });
            let isNewUser = false;
            if (!user) {
                user = new user_model_1.default({ phone_number });
                yield user.save();
                isNewUser = true;
            }
            const token = jsonwebtoken_1.default.sign({ userId: user._id, phone_number: user.phone_number }, JWT_SECRET, { expiresIn: "7d" });
            res.status(200).json({
                success: true,
                message: isNewUser ? "User registered successfully." : "Login successful.",
                token,
                userId: user._id,
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
            const { name, phone_number, email, gender, age, body_type, height, color_palette, size, role, } = req.body;
            const updateFields = Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign(Object.assign({}, (name && { name })), (phone_number && { phone_number })), (email && { email })), (gender && { gender })), (age && { age })), (body_type && { body_type })), (height && { height })), (color_palette && { color_palette })), (size && { size })), (role && { role }));
            const updatedUser = yield user_model_1.default.findByIdAndUpdate(userId, updateFields, {
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
        }
        catch (error) {
            console.error("Update User Error:", error);
            res.status(500).json({ success: false, message: error.message });
        }
    }),
];
exports.loginUser = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { phone_number } = req.body;
            if (!phone_number) {
                res.status(400).json({ success: false, message: "Phone number is required." });
                return;
            }
            const user = yield user_model_1.default.findOne({ phone_number });
            if (!user) {
                res.status(401).json({ success: false, message: "User not found. Please register first." });
                return;
            }
            const token = jsonwebtoken_1.default.sign({ userId: user._id, phone_number: user.phone_number }, JWT_SECRET, { expiresIn: "7d" });
            res.status(200).json({
                success: true,
                message: "Login successful",
                token,
                userId: user._id,
            });
        }
        catch (error) {
            console.error("Login User Error:", error);
            res.status(500).json({ success: false, message: error.message });
        }
    }),
];
exports.registerAdmin = [
    multer_1.upload.single("photo"),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { name, username, phone_number, email, password, gender, age, festival_objectId, body_type, height, color_palette, relation_objectId, size, role, addressObjectId, } = req.body;
            const existingUser = yield user_model_1.default.findOne({ email });
            if (existingUser) {
                res.status(409).json({ success: false, message: "User already exists." });
                return;
            }
            const photo_url = req.file ? req.file.path : undefined;
            const newUser = new user_model_1.default(Object.assign({ name,
                username,
                phone_number,
                email, password: password ? yield bcryptjs_1.default.hash(password, 10) : undefined, gender,
                age,
                festival_objectId,
                body_type,
                height,
                color_palette,
                relation_objectId,
                size,
                addressObjectId, role: role }, (photo_url && { photo_url })));
            yield newUser.save();
            if (!role) {
                res.status(400).json({ success: false, message: "Role is required." });
                return;
            }
            const token = jsonwebtoken_1.default.sign({ userId: newUser._id, email: newUser.email }, JWT_SECRET, { expiresIn: "7d" });
            newUser.token = token;
            yield newUser.save();
            let userObj = typeof newUser.toObject === "function" ? newUser.toObject() : newUser;
            delete userObj.__v;
            res.status(201).json({
                success: true,
                message: "User registered successfully.",
                token,
                user: userObj,
            });
        }
        catch (error) {
            console.error("Register Error:", error);
            res.status(500).json({ success: false, message: error.message });
        }
    })
];
exports.loginAdmin = [
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { email, password } = req.body;
            const user = yield user_model_1.default.findOne({ email });
            if (!user) {
                res.status(401).json({ message: 'User not found. Please register first.' });
                return;
            }
            const isMatch = yield bcryptjs_1.default.compare(password, user.password);
            if (!isMatch) {
                res.status(401).json({ message: 'Invalid password.' });
                return;
            }
            const token = jsonwebtoken_1.default.sign({ userId: user._id, email: user.email, role: user.role }, JWT_SECRET, { expiresIn: '1d' });
            res.status(200).json({
                message: 'Login successful',
                accessToken: token,
                user: { _id: user._id, email: user.email, role: user.role, name: user.name },
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
const getAllUsers = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const users = yield user_model_1.default.find()
            .populate('addressObjectId')
            .populate('festival_objectId')
            .populate('relation_objectId')
            .populate('photo_objectId')
            .populate('preferenceObjectId')
            .select('-password -token')
            .lean();
        res.status(200).json({
            success: true,
            message: 'All users fetched successfully.',
            data: users
        });
    }
    catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error while fetching users.',
            error: error.message
        });
    }
});
exports.getAllUsers = getAllUsers;
