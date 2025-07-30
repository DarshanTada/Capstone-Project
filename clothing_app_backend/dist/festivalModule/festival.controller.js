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
exports.deleteFestival = exports.updateFestival = exports.getAllFestivals = exports.createFestival = void 0;
const festival_model_1 = __importDefault(require("../festivalModule/festival.model"));
const dotenv_1 = __importDefault(require("dotenv"));
const multer_1 = require("../utils/common/multer");
dotenv_1.default.config();
exports.createFestival = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { festival_name, isEnable } = req.body;
            if (!festival_name || isEnable === undefined) {
                res
                    .status(400)
                    .json({
                    success: false,
                    message: "festival_name and isEnable are required.",
                });
                return;
            }
            const newFestival = new festival_model_1.default({
                festival_name,
                isEnable,
            });
            yield newFestival.save();
            res.status(201).json({ success: true, data: newFestival });
        }
        catch (error) {
            console.error("Create Festival Error:", error);
            res.status(500).json({ success: false, message: error.message });
        }
    }),
];
const getAllFestivals = (_req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const festivals = yield festival_model_1.default.find();
        res.status(200).json({ success: true, data: festivals });
    }
    catch (error) {
        console.error('Get Festivals Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getAllFestivals = getAllFestivals;
exports.updateFestival = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { id } = req.params;
            const { festival_name, isEnable } = req.body;
            const updatedFestival = yield festival_model_1.default.findByIdAndUpdate(id, { festival_name, isEnable }, { new: true });
            if (!updatedFestival) {
                res.status(404).json({ success: false, message: 'Festival not found.' });
                return;
            }
            res.status(200).json({ success: true, data: updatedFestival });
        }
        catch (error) {
            console.error('Update Festival Error:', error);
            res.status(500).json({ success: false, message: error.message });
        }
    })
];
const deleteFestival = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        const deleted = yield festival_model_1.default.findByIdAndDelete(id);
        if (!deleted) {
            res.status(404).json({ success: false, message: 'Festival not found.' });
            return;
        }
        res.status(200).json({ success: true, message: 'Festival deleted.' });
    }
    catch (error) {
        console.error('Delete Festival Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.deleteFestival = deleteFestival;
