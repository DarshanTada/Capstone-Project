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
exports.editProfile = exports.refreshUser = exports.login = exports.register = void 0;
const user_model_1 = require("./user.model");
const fileUpload_1 = require("./../utils/generic/fileUpload");
const auth_middlewares_1 = require("./../utils/generic/auth/auth.middlewares");
const register = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        let { fullName, email, phone, dob, avatar, gender, fcmToken } = req.body;
        let userQuery = {};
        let existingUser = yield user_model_1.UserModel.findOne({ phone: phone, isActive: true, isDeleted: false });
        if (existingUser) {
            return res.status(200).send({
                success: false,
                message: 'userWithPhoneExists'
            });
        }
        if (req.files != null) {
            if (Object.keys(req.files).length > 0) {
                for (const key in req.files) {
                    let S3Response;
                    let userImageFileName = `${req.files[key].name}`;
                    let userFileData = req.files[key].data;
                    yield (0, fileUpload_1.uploadToS3Bucket)(userImageFileName, userFileData).then((data) => __awaiter(void 0, void 0, void 0, function* () {
                        S3Response = data;
                    }));
                    avatar = S3Response.Location;
                }
            }
        }
        userQuery = {
            fullName,
            email,
            phone,
            dob: new Date(dob),
            gender,
            avatar,
            fcmTokens: fcmToken ? [fcmToken] : [],
        };
        let newUser = yield user_model_1.UserModel.create(userQuery);
        return res.status(200).send({
            success: newUser != null,
            message: newUser != null ? 'registerSuccess' : 'failedToRegister',
            result: newUser,
            accessToken: newUser != null ? yield (0, auth_middlewares_1.createAccessToken)(newUser._id) : null,
        });
    }
    catch (error) {
        return res.status(500).send({
            success: false,
            error: error.message,
            message: 'failedToRegister',
        });
    }
});
exports.register = register;
const login = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        let { phone, fcmToken } = req.query;
        const user = yield user_model_1.UserModel.findOne({ phone: phone, isActive: true, isDeleted: false });
        return res.status(200).send({
            success: true,
            login: user != null,
            result: user,
            accessToken: user != null ? yield (0, auth_middlewares_1.createAccessToken)(user._id) : null,
        });
    }
    catch (error) {
        return res.status(500).send({
            success: false,
            login: false,
            error: error.message,
        });
    }
});
exports.login = login;
const refreshUser = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        let { user } = req.body;
        const refreshedUser = yield user_model_1.UserModel.findById(user);
        return res.status(200).send({
            success: refreshedUser != null,
            result: refreshedUser,
            message: exports.refreshUser != null ? '' : 'failedToRefresh',
        });
    }
    catch (error) {
        return res.status(500).send({
            success: false,
            login: false,
            error: error.message,
            message: 'failedToRefresh',
        });
    }
});
exports.refreshUser = refreshUser;
const editProfile = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        let { fullName, email, dob, avatar, gender, photoRemoved = 'false', user, isLocationAllowed, isNotificationAllowed } = req.body;
        let updatedUser;
        let updateQuery = {};
        if (JSON.parse(photoRemoved)) {
            updateQuery.avatar = '';
        }
        else if (req.files != null) {
            if (Object.keys(req.files).length > 0) {
                for (const key in req.files) {
                    let S3Response;
                    let userImageFileName = `${req.files[key].name}`;
                    let userFileData = req.files[key].data;
                    yield (0, fileUpload_1.uploadToS3Bucket)(userImageFileName, userFileData).then((data) => __awaiter(void 0, void 0, void 0, function* () {
                        S3Response = data;
                    }));
                    updateQuery.avatar = S3Response.Location;
                }
            }
        }
        if (isLocationAllowed || isNotificationAllowed) {
            if (isLocationAllowed) {
                updateQuery.isLocationAllowed = isLocationAllowed;
            }
            if (isNotificationAllowed) {
                updateQuery.isNotificationAllowed = isNotificationAllowed;
            }
        }
        else {
            updateQuery = Object.assign({ fullName,
                isLocationAllowed,
                isNotificationAllowed,
                email, dob: new Date(dob), gender }, updateQuery);
        }
        updatedUser = yield user_model_1.UserModel.findByIdAndUpdate(user, updateQuery, { new: true });
        return res.status(200).send({
            success: updatedUser != null,
            message: updatedUser != null ? 'profileUpdateSuccess' : 'failedToSave',
            result: updatedUser,
        });
    }
    catch (error) {
        return res.status(500).send({
            success: false,
            error: error.message,
            message: 'failedToSave',
        });
    }
});
exports.editProfile = editProfile;
