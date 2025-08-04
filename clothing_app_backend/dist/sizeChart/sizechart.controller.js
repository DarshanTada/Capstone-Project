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
Object.defineProperty(exports, "__esModule", { value: true });
exports.addMeasurementGuide = exports.getMeasurementGuides = exports.deleteSizeChart = exports.getAllSizeCharts = exports.createSizeChart = void 0;
const sizechart_model_1 = require("./sizechart.model");
const createSizeChart = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        let sizes = req.body.sizes;
        if (typeof sizes === 'string') {
            try {
                sizes = JSON.parse(sizes);
            }
            catch (_a) {
                sizes = [];
            }
        }
        let category = req.body.category;
        if (typeof category === 'string') {
            try {
                category = JSON.parse(category);
            }
            catch (_b) {
                category = [category];
            }
        }
        const sizeChartData = {
            gender: req.body.gender,
            category,
            fitType: req.body.fitType,
            sizeRange: req.body.sizeRange,
            sizes,
            measurementGuide: req.body.measurementGuide,
        };
        const sizeChart = yield sizechart_model_1.SizeChart.create(sizeChartData);
        res.status(200).json({ success: true, data: sizeChart });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.createSizeChart = createSizeChart;
const getAllSizeCharts = (_req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const sizeCharts = yield sizechart_model_1.SizeChart.find().populate('measurementGuide');
        res.status(200).json({ success: true, data: sizeCharts });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getAllSizeCharts = getAllSizeCharts;
const deleteSizeChart = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        const deleted = yield sizechart_model_1.SizeChart.findByIdAndDelete(id);
        if (!deleted) {
            res.status(404).json({ success: false, message: 'Size chart not found.' });
            return;
        }
        res.status(200).json({ success: true, message: 'Size chart deleted.' });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.deleteSizeChart = deleteSizeChart;
const getMeasurementGuides = (_req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const guides = yield sizechart_model_1.MeasurementGuide.find();
        res.status(200).json({ success: true, data: guides });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getMeasurementGuides = getMeasurementGuides;
const addMeasurementGuide = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { type, instructions } = req.body;
        let parsedInstructions = instructions;
        if (typeof instructions === 'string') {
            try {
                parsedInstructions = JSON.parse(instructions);
            }
            catch (_a) {
                parsedInstructions = [];
            }
        }
        const imageBuffer = req.file ? req.file.buffer : undefined;
        const guide = yield sizechart_model_1.MeasurementGuide.create({
            type,
            image: imageBuffer,
            instructions: parsedInstructions,
        });
        res.status(200).json({ success: true, data: guide });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.addMeasurementGuide = addMeasurementGuide;
