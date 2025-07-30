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
exports.getCareInstructionsByFabricType = exports.createCareInstruction = void 0;
const careInstruction_model_1 = __importDefault(require("../careInstructionModule/careInstruction.model"));
const createCareInstruction = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const { fabricType, instruction } = req.body;
        const files = req.files;
        const imageFile = (_a = files === null || files === void 0 ? void 0 : files['image']) === null || _a === void 0 ? void 0 : _a[0];
        const imageBase64 = imageFile
            ? `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`
            : undefined;
        if (!fabricType || !instruction) {
            res.status(400).json({
                success: false,
                message: 'fabricType and instruction are required.',
            });
            return;
        }
        let careDoc = yield careInstruction_model_1.default.findOne({ fabricType });
        const newInstruction = imageBase64
            ? { instruction, image: imageBase64 }
            : { instruction };
        if (careDoc) {
            careDoc.instructions.push(newInstruction);
        }
        else {
            careDoc = new careInstruction_model_1.default({
                fabricType,
                instructions: [newInstruction]
            });
        }
        yield careDoc.save();
        res.status(201).json({
            success: true,
            message: 'Care instruction added successfully',
            data: careDoc
        });
    }
    catch (error) {
        console.error('Error creating care instruction:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.createCareInstruction = createCareInstruction;
const getCareInstructionsByFabricType = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { fabricType } = req.body;
        if (!fabricType) {
            res.status(400).json({
                success: false,
                message: 'fabricType is required.',
            });
            return;
        }
        const careDoc = yield careInstruction_model_1.default.findOne({ fabricType });
        if (!careDoc) {
            res.status(404).json({
                success: false,
                message: `No care instructions found for fabric type: ${fabricType}`,
            });
            return;
        }
        res.status(200).json({
            success: true,
            data: careDoc,
        });
    }
    catch (error) {
        console.error('Error fetching care instructions:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getCareInstructionsByFabricType = getCareInstructionsByFabricType;
