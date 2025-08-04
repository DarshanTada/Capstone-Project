"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.FestivalRouter = void 0;
const express_1 = __importDefault(require("express"));
const festival_controller_1 = require("./festival.controller");
exports.FestivalRouter = express_1.default.Router();
exports.FestivalRouter.post('/createFestivals', festival_controller_1.createFestival);
exports.FestivalRouter.get('/getFestivals', festival_controller_1.getAllFestivals);
exports.FestivalRouter.put('/updateFestivals/:id', festival_controller_1.updateFestival);
exports.FestivalRouter.delete('/deleteFestivals/:id', festival_controller_1.deleteFestival);
exports.default = exports.FestivalRouter;
