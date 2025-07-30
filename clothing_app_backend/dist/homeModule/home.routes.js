"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.HomeRouter = void 0;
const express_1 = __importDefault(require("express"));
const home_controller_1 = require("./home.controller");
exports.HomeRouter = express_1.default.Router();
exports.HomeRouter.get('/home', home_controller_1.getHomeData);
exports.default = exports.HomeRouter;
