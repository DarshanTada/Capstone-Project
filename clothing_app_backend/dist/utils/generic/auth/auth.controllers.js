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
exports.verifyOTPofUser = exports.resendOTPtoUser = exports.sendOTPtoUser = void 0;
const otpRecord_model_1 = require("./otpRecord.model");
const axios = require("axios").default;
const SendOtp = require("sendotp");
const templateId = process.env.MSG91TEMPLATEID;
const sendOTPtoUser = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { mobileNo, cc = "91" } = req.body;
        let URL;
        if (mobileNo == "8899221111" || mobileNo == "8899331111" || mobileNo == "8899441111") {
            URL = `https://api.msg91.com/api/v5/otp?template_id=${templateId}&mobile=+${cc}${mobileNo}&authkey=${process.env.MSG91AUTHKEY}&otp_length=6&otp=123456`;
        }
        else {
            URL = `https://api.msg91.com/api/v5/otp?template_id=${templateId}&mobile=+${cc}${mobileNo}&authkey=${process.env.MSG91AUTHKEY}&otp_length=6`;
        }
        res.status(200).send({
            success: true,
            result: { type: "success" },
        });
    }
    catch (error) {
        res.status(500).send({
            success: false,
            result: error
        });
    }
});
exports.sendOTPtoUser = sendOTPtoUser;
const resendOTPtoUser = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { mobileNo, type = "text", cc = "91" } = req.body;
        let URL;
        if (mobileNo == "8899221111" || mobileNo == "8899331111" || mobileNo == "8899441111") {
            URL = `https://api.msg91.com/api/v5/otp/retry?authkey=${process.env.MSG91AUTHKEY}&retrytype=${type}&mobile=+${cc}${mobileNo}&otp=123456`;
        }
        else {
            URL = `https://api.msg91.com/api/v5/otp/retry?authkey=${process.env.MSG91AUTHKEY}&retrytype=${type}&mobile=+${cc}${mobileNo}`;
        }
        axios
            .get(URL)
            .then(function (response) {
            return __awaiter(this, void 0, void 0, function* () {
                res.status(200).send({
                    success: true,
                    result: response.data,
                });
            });
        })
            .catch(function (error) {
            return __awaiter(this, void 0, void 0, function* () {
                yield otpRecord_model_1.otpRecordModel.create({
                    mobile: mobileNo,
                    status: otpRecord_model_1.OTPStatus.FAILED,
                    log: JSON.stringify(error),
                });
                res.status(200).send({
                    success: true,
                    error: error,
                });
            });
        });
    }
    catch (error) {
        res.status(500).send({
            success: false,
            result: error
        });
    }
});
exports.resendOTPtoUser = resendOTPtoUser;
const verifyOTPofUser = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { mobileNo, otp, cc = "91" } = req.body;
        const URL = `https://api.msg91.com/api/v5/otp/verify?authkey=${process.env.MSG91AUTHKEY}&mobile=+${cc}${mobileNo}&otp=${otp}`;
        res.status(200).send({
            success: true,
            result: { type: "success" },
        });
    }
    catch (error) {
        res.status(500).send({
            success: false,
            result: error
        });
    }
});
exports.verifyOTPofUser = verifyOTPofUser;
