"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SeasonRoute = void 0;
const express_1 = __importDefault(require("express"));
const season_controller_1 = require("./season.controller");
exports.SeasonRoute = express_1.default.Router();
exports.SeasonRoute.post('/createSeasons', season_controller_1.createSeason);
exports.SeasonRoute.get('/getSeasons', season_controller_1.getAllSeasons);
exports.SeasonRoute.put('/updateSeasons/:id', season_controller_1.updateSeason);
exports.SeasonRoute.delete('/deleteSeasons/:id', season_controller_1.deleteSeason);
exports.default = exports.SeasonRoute;
