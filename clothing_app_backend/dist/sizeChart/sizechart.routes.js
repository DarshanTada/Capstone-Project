"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SizeChartRouter = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = require("../utils/common/multer");
const sizechart_controller_1 = require("./sizechart.controller");
exports.SizeChartRouter = express_1.default.Router();
exports.SizeChartRouter.post('/createsizechart', multer_1.upload.none(), sizechart_controller_1.createSizeChart);
exports.SizeChartRouter.post('/addmeasurementguide', multer_1.upload.single('image'), sizechart_controller_1.addMeasurementGuide);
exports.SizeChartRouter.get('/all', sizechart_controller_1.getAllSizeCharts);
exports.SizeChartRouter.delete('/deletesizechart/:id', sizechart_controller_1.deleteSizeChart);
exports.SizeChartRouter.get('/measurementguides', sizechart_controller_1.getMeasurementGuides);
exports.default = exports.SizeChartRouter;
