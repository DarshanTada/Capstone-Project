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
exports.deletePreference = exports.updatePreference = exports.getPreferencesByUserId = exports.getAllPreferences = exports.createPreference = void 0;
const preference_model_1 = __importDefault(require("./preference.model"));
const dotenv_1 = __importDefault(require("dotenv"));
const multer_1 = require("../utils/common/multer");
dotenv_1.default.config();
exports.createPreference = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const data = req.body;
            if (!data.user_objectId) {
                res.status(400).json({ success: false, message: 'user_objectId is required.' });
                return;
            }
            const parseArrayFields = ['style', 'occasion', 'festivals', 'color_tones'];
            parseArrayFields.forEach((key) => {
                if (data[key] && typeof data[key] === 'string') {
                    data[key] = data[key].split(',').map((item) => item.trim());
                }
            });
            const newPref = new preference_model_1.default(data);
            yield newPref.save();
            res.status(201).json({ success: true, data: newPref });
        }
        catch (error) {
            console.error('Create Preference Error:', error);
            res.status(500).json({ success: false, message: error.message });
        }
    })
];
const getAllPreferences = (_req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const prefs = yield preference_model_1.default.find();
        res.status(200).json({ success: true, data: prefs });
    }
    catch (error) {
        console.error('Get Preferences Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getAllPreferences = getAllPreferences;
const getPreferencesByUserId = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { userId } = req.params;
        if (!userId) {
            res.status(400).json({ success: false, message: 'userId is required in params.' });
            return;
        }
        const prefs = yield preference_model_1.default.find({ user_objectId: userId });
        if (prefs.length === 0) {
            res.status(404).json({ success: false, message: 'No preferences found for this user.' });
            return;
        }
        res.status(200).json({ success: true, data: prefs });
    }
    catch (error) {
        console.error('Get Preferences by User ID Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getPreferencesByUserId = getPreferencesByUserId;
exports.updatePreference = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { id } = req.params;
            const data = req.body;
            const parseArrayFields = ['style', 'occasion', 'festivals', 'color_tones'];
            parseArrayFields.forEach((key) => {
                if (data[key] && typeof data[key] === 'string') {
                    data[key] = data[key].split(',').map((item) => item.trim());
                }
            });
            const updated = yield preference_model_1.default.findByIdAndUpdate(id, data, { new: true });
            if (!updated) {
                res.status(404).json({ success: false, message: 'Preference not found.' });
                return;
            }
            res.status(200).json({ success: true, data: updated });
        }
        catch (error) {
            console.error('Update Preference Error:', error);
            res.status(500).json({ success: false, message: error.message });
        }
    })
];
const deletePreference = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        const deleted = yield preference_model_1.default.findByIdAndDelete(id);
        if (!deleted) {
            res.status(404).json({ success: false, message: 'Preference not found.' });
            return;
        }
        res.status(200).json({ success: true, message: 'Preference deleted.' });
    }
    catch (error) {
        console.error('Delete Preference Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.deletePreference = deletePreference;
