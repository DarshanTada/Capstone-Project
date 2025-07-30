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
exports.getAllIntro = exports.createIntro = exports.uploadIntroImage = void 0;
const intro_model_1 = __importDefault(require("./intro.model"));
const multer_1 = require("../utils/common/multer");
exports.uploadIntroImage = multer_1.upload.fields([{ name: 'image', maxCount: 1 }]);
const createIntro = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a, _b;
    try {
        const { title, intro_description } = req.body;
        const files = req.files;
        const imageBuffer = (_b = (_a = files === null || files === void 0 ? void 0 : files['image']) === null || _a === void 0 ? void 0 : _a[0]) === null || _b === void 0 ? void 0 : _b.buffer;
        console.error(imageBuffer);
        if (!title || !intro_description || !imageBuffer) {
            res.status(400).json({
                success: false,
                message: 'Title, intro description, and an image file are required.',
            });
            return;
        }
        const newIntro = new intro_model_1.default({
            title,
            intro_description,
            image: imageBuffer,
        });
        yield newIntro.save();
        res.status(201).json({ success: true, data: newIntro });
    }
    catch (error) {
        console.error('Error saving intro:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.createIntro = createIntro;
const getAllIntro = (_req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const categories = yield intro_model_1.default.find();
        const formatted = categories.map((cat) => {
            var _a;
            return ({
                _id: cat._id,
                title: cat.title,
                intro_description: cat.intro_description,
                image: ((_a = cat.image) === null || _a === void 0 ? void 0 : _a.toString('base64')) || null,
            });
        });
        res.status(200).json({ success: true, data: formatted });
    }
    catch (error) {
        console.error('Get Introduction Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getAllIntro = getAllIntro;
