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
exports.deleteFromS3Bucket_Buildby_Chat = exports.uploadToS3Bucket_Buildby_Chat = exports.deleteFromS3Bucket = exports.uploadToS3Bucket = exports.getUploadFileUrl = exports.sendMailViaSendGrid = exports.sendMail = void 0;
const aws_sdk_1 = __importDefault(require("aws-sdk"));
const moment_1 = __importDefault(require("moment"));
const sgMail = require('@sendgrid/mail');
const SESConfig = {
    apiVersion: "2010-12-01",
    accessKeyId: process.env.SES_ACCESSKEY,
    secretAccessKey: process.env.SES_SECRETKEY,
    region: process.env.REGION,
};
const sendMail = (params_1, ...args_1) => __awaiter(void 0, [params_1, ...args_1], void 0, function* (params, campaign = false, campaignId = "") {
    new aws_sdk_1.default.SES(SESConfig)
        .sendEmail(params)
        .promise()
        .then((res) => __awaiter(void 0, void 0, void 0, function* () {
        console.log(res);
        return true;
    }));
});
exports.sendMail = sendMail;
const sendMailViaSendGrid = (params_1, ...args_1) => __awaiter(void 0, [params_1, ...args_1], void 0, function* (params, campaign = false, campaignId = "") {
    sgMail.setApiKey(process.env.SENDGRID_API_KEY);
    return new Promise((resolve, reject) => __awaiter(void 0, void 0, void 0, function* () {
        yield sgMail
            .send(params)
            .then(() => __awaiter(void 0, void 0, void 0, function* () {
            console.log('Email sent');
            resolve(true);
        }))
            .catch((error) => {
            console.error(error);
            reject(false);
        });
    }));
});
exports.sendMailViaSendGrid = sendMailViaSendGrid;
const S3 = new aws_sdk_1.default.S3({
    signatureVersion: "v4",
    accessKeyId: process.env.ACCESSKEY,
    secretAccessKey: process.env.SECRETKEY,
    region: process.env.REGION,
    apiVersion: "2006-03-01",
});
const S3_BUILDBY_CHAT = new aws_sdk_1.default.S3({
    signatureVersion: "v4",
    accessKeyId: process.env.ACCESSKEY_BUILDBY_CHAT,
    secretAccessKey: process.env.SECRETKEY_BUILDBY_CHAT,
    region: process.env.REGION_BUILDBY_CHAT,
    apiVersion: "2006-03-01",
});
const getUploadFileUrl = (fileName) => __awaiter(void 0, void 0, void 0, function* () {
    return yield S3.getSignedUrlPromise("putObject", {
        Bucket: process.env.BUCKETNAME,
        Key: `${getLocaiton()}​/${fileName}​`,
        ACL: "public-read",
        Expires: 6000 * 5,
    });
});
exports.getUploadFileUrl = getUploadFileUrl;
function getLocaiton() {
    const yearMonthFolder = (0, moment_1.default)().format("YYYY/MM");
    return `uploads/${yearMonthFolder}`;
}
const uploadToS3Bucket = (fileName, file) => __awaiter(void 0, void 0, void 0, function* () {
    let contentType = "";
    if (fileName.split(".")[fileName.split(".").length - 1] == "pdf") {
        contentType = "application/pdf";
    }
    else if (fileName.split(".")[fileName.split(".").length - 1] == "mp4" ||
        fileName.split(".")[fileName.split(".").length - 1] == "mov" ||
        fileName.split(".")[fileName.split(".").length - 1] == "webm") {
        contentType = `video/${fileName.split(".")[fileName.split(".").length - 1]}`;
    }
    else if (fileName.split(".")[fileName.split(".").length - 1] == "doc" ||
        fileName.split(".")[fileName.split(".").length - 1] == "docx" ||
        fileName.split(".")[fileName.split(".").length - 1] == "csv" ||
        fileName.split(".")[fileName.split(".").length - 1] == "xls" ||
        fileName.split(".")[fileName.split(".").length - 1] == "ods" ||
        fileName.split(".")[fileName.split(".").length - 1] == "xlsx") {
        contentType = "application/msword";
    }
    else {
        contentType = `image/${fileName.split(".")[fileName.split(".").length - 1]}`;
    }
    return new Promise((resolve, reject) => {
        S3.upload({
            Key: fileName,
            Bucket: process.env.BUCKETNAME,
            ACL: process.env.FILEPERMISSION,
            Body: file,
            ContentType: contentType,
        }, (error, data) => {
            if (error) {
                reject(error);
            }
            resolve(data);
        });
    });
});
exports.uploadToS3Bucket = uploadToS3Bucket;
const deleteFromS3Bucket = (fileId) => __awaiter(void 0, void 0, void 0, function* () {
    return new Promise((resolve, reject) => {
        S3.deleteObject({
            Key: fileId,
            Bucket: process.env.BUCKETNAME,
        }, (error, data) => {
            if (error) {
                reject(error);
            }
            resolve(data);
        });
    });
});
exports.deleteFromS3Bucket = deleteFromS3Bucket;
const uploadToS3Bucket_Buildby_Chat = (fileName, file) => __awaiter(void 0, void 0, void 0, function* () {
    let contentType = "";
    if (fileName.split(".")[fileName.split(".").length - 1] == "pdf") {
        contentType = "application/pdf";
    }
    else if (fileName.split(".")[fileName.split(".").length - 1] == "mp4" ||
        fileName.split(".")[fileName.split(".").length - 1] == "mov" ||
        fileName.split(".")[fileName.split(".").length - 1] == "webm") {
        contentType = `video/${fileName.split(".")[fileName.split(".").length - 1]}`;
    }
    else if (fileName.split(".")[fileName.split(".").length - 1] == "doc" ||
        fileName.split(".")[fileName.split(".").length - 1] == "docx" ||
        fileName.split(".")[fileName.split(".").length - 1] == "csv" ||
        fileName.split(".")[fileName.split(".").length - 1] == "xls" ||
        fileName.split(".")[fileName.split(".").length - 1] == "ods" ||
        fileName.split(".")[fileName.split(".").length - 1] == "xlsx") {
        contentType = "application/msword";
    }
    else if (fileName.split(".")[fileName.split(".").length - 1] == "txt") {
        contentType = "text/plain";
    }
    else if (fileName.split(".")[fileName.split(".").length - 1] == "webp") {
        contentType = "application/webp";
    }
    else if (fileName.split(".")[fileName.split(".").length - 1] == "mp4") {
        contentType = "video/mp4";
    }
    else {
        contentType = `image/jpeg`;
        fileName = fileName.split(".")[0] + '.jpeg';
    }
    return new Promise((resolve, reject) => {
        S3_BUILDBY_CHAT.upload({
            Key: fileName,
            Bucket: process.env.BUCKETNAME_BUILDBY_CHAT,
            ACL: process.env.FILEPERMISSION_BUILDBY_CHAT,
            Body: file,
            ContentType: contentType,
        }, (error, data) => {
            if (error) {
                reject(error);
            }
            resolve(data);
        });
    });
});
exports.uploadToS3Bucket_Buildby_Chat = uploadToS3Bucket_Buildby_Chat;
const deleteFromS3Bucket_Buildby_Chat = (fileId) => __awaiter(void 0, void 0, void 0, function* () {
    return new Promise((resolve, reject) => {
        S3_BUILDBY_CHAT.deleteObject({
            Key: fileId,
            Bucket: process.env.BUCKETNAME_BUILDBY_CHAT,
        }, (error, data) => {
            if (error) {
                reject(error);
            }
            resolve(data);
        });
    });
});
exports.deleteFromS3Bucket_Buildby_Chat = deleteFromS3Bucket_Buildby_Chat;
