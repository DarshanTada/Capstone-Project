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
exports.createAccessToken = exports.createAccessTokenForAdmin = void 0;
const jsonwebtoken_1 = require("jsonwebtoken");
const createAccessTokenForAdmin = (userId, type) => __awaiter(void 0, void 0, void 0, function* () {
    let token = (0, jsonwebtoken_1.sign)({ userId, type }, process.env.ACCESS_TOKEN_SECRET_FOR_ADMIN, {});
    return token;
});
exports.createAccessTokenForAdmin = createAccessTokenForAdmin;
const createAccessToken = (userId) => __awaiter(void 0, void 0, void 0, function* () {
    let token = (0, jsonwebtoken_1.sign)({ userId }, process.env.ACCESS_TOKEN_SECRET, {});
    return token;
});
exports.createAccessToken = createAccessToken;
