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
exports.deleteSeason = exports.updateSeason = exports.getAllSeasons = exports.createSeason = void 0;
const season_model_1 = __importDefault(require("../seasonModule/season.model"));
const dotenv_1 = __importDefault(require("dotenv"));
const multer_1 = require("../utils/common/multer");
dotenv_1.default.config();
exports.createSeason = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { season_name, isEnable } = req.body;
            if (!season_name || isEnable === undefined) {
                res.status(400).json({ success: false, message: 'season_name and isEnable are required.' });
                return;
            }
            const newSeason = new season_model_1.default({ season_name, isEnable });
            yield newSeason.save();
            res.status(201).json({ success: true, data: newSeason });
        }
        catch (error) {
            console.error('Create Season Error:', error);
            res.status(500).json({ success: false, message: error.message });
        }
    })
];
const getAllSeasons = (_req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const seasons = yield season_model_1.default.find();
        res.status(200).json({ success: true, data: seasons });
    }
    catch (error) {
        console.error('Get Seasons Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getAllSeasons = getAllSeasons;
exports.updateSeason = [
    multer_1.upload.none(),
    (req, res) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const { id } = req.params;
            const { season_name, isEnable } = req.body;
            const updatedSeason = yield season_model_1.default.findByIdAndUpdate(id, { season_name, isEnable }, { new: true });
            if (!updatedSeason) {
                res.status(404).json({ success: false, message: 'Season not found.' });
                return;
            }
            res.status(200).json({ success: true, data: updatedSeason });
        }
        catch (error) {
            console.error('Update Season Error:', error);
            res.status(500).json({ success: false, message: error.message });
        }
    })
];
const deleteSeason = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        const deletedSeason = yield season_model_1.default.findByIdAndDelete(id);
        if (!deletedSeason) {
            res.status(404).json({ success: false, message: 'Season not found.' });
            return;
        }
        res.status(200).json({ success: true, message: 'Season deleted.' });
    }
    catch (error) {
        console.error('Delete Season Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.deleteSeason = deleteSeason;
