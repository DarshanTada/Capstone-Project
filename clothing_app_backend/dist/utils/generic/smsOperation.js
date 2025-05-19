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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendSms = void 0;
const aws_sdk_1 = __importDefault(require("aws-sdk"));
aws_sdk_1.default.config.update({
    accessKeyId: process.env.SES_ACCESSKEY,
    secretAccessKey: process.env.SES_SECRETKEY,
    region: process.env.REGION,
});
const sendSms = (mobileNo, message, campaignId) => __awaiter(void 0, void 0, void 0, function* () {
    var mobileNumber = "+91-" + mobileNo;
    var params = {
        Message: `${message}`,
        PhoneNumber: mobileNumber,
        MessageStructure: "string",
    };
    return new aws_sdk_1.default.SNS({ apiVersion: "2010–03–31" })
        .publish(params)
        .promise()
        .then((message) => __awaiter(void 0, void 0, void 0, function* () {
        console.log(message);
        return message;
    }));
});
exports.sendSms = sendSms;
