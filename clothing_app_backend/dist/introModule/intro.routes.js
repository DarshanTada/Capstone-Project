"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.IntroRoute = void 0;
const express_1 = __importDefault(require("express"));
const intro_controller_1 = require("../introModule/intro.controller");
exports.IntroRoute = express_1.default.Router();
exports.IntroRoute.post('/intro', intro_controller_1.uploadIntroImage, intro_controller_1.createIntro);
exports.IntroRoute.get('/getIntro', intro_controller_1.getAllIntro);
exports.default = exports.IntroRoute;
