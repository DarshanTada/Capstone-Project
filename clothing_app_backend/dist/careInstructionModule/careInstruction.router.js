"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CareInstructorRouter = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = require("../utils/common/multer");
const careInstruction_controller_1 = require("../careInstructionModule/careInstruction.controller");
exports.CareInstructorRouter = express_1.default.Router();
exports.CareInstructorRouter.post('/create-care-instructions', multer_1.uploadCareImage, careInstruction_controller_1.createCareInstruction);
exports.CareInstructorRouter.post('/get-care-instructions/by-fabric', multer_1.upload.none(), careInstruction_controller_1.getCareInstructionsByFabricType);
exports.default = exports.CareInstructorRouter;
