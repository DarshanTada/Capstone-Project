"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PreferenceRoute = void 0;
const express_1 = __importDefault(require("express"));
const preference_controller_1 = require("./preference.controller");
exports.PreferenceRoute = express_1.default.Router();
exports.PreferenceRoute.post('/createPreference', preference_controller_1.createPreference);
exports.PreferenceRoute.get('/getPreferences', preference_controller_1.getAllPreferences);
exports.PreferenceRoute.get('/user/:userId', preference_controller_1.getPreferencesByUserId);
exports.PreferenceRoute.put('/updatePreference/:id', preference_controller_1.updatePreference);
exports.PreferenceRoute.delete('/deletePreference/:id', preference_controller_1.deletePreference);
exports.default = exports.PreferenceRoute;
