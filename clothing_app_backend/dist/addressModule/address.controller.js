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
exports.deleteAddress = exports.updateAddress = exports.getAllAddressesByUserId = exports.addAddress = void 0;
const address_model_1 = __importDefault(require("./address.model"));
const user_model_1 = __importDefault(require("../userModule/user.model"));
const addAddress = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { type, full_name, house_number, address, city, zip, provience, userId } = req.body;
        if (!type ||
            !full_name ||
            !house_number ||
            !address ||
            !city ||
            !zip ||
            !provience ||
            !userId) {
            res.status(400).json({
                success: false,
                message: 'All fields including userId are required.'
            });
            return;
        }
        const user = yield user_model_1.default.findById(userId);
        if (!user) {
            res.status(404).json({
                success: false,
                message: 'User not found.'
            });
            return;
        }
        const newAddress = yield address_model_1.default.create({
            type,
            full_name,
            house_number,
            address,
            city,
            zip,
            provience,
            userId
        });
        const populatedAddress = yield address_model_1.default.findById(newAddress._id).populate('userId');
        res.status(201).json({
            success: true,
            message: 'Address added successfully.',
            data: populatedAddress
        });
    }
    catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error while adding address.',
            error: error.message
        });
    }
});
exports.addAddress = addAddress;
const getAllAddressesByUserId = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { userId } = req.body;
        if (!userId) {
            res.status(400).json({
                success: false,
                message: 'userId is required in form-data.'
            });
            return;
        }
        const addresses = yield address_model_1.default.find({ userId })
            .populate('userId')
            .lean();
        res.status(200).json({
            success: true,
            message: 'Addresses fetched successfully.',
            data: addresses
        });
    }
    catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error while fetching addresses.',
            error: error.message
        });
    }
});
exports.getAllAddressesByUserId = getAllAddressesByUserId;
const updateAddress = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { addressId, type, full_name, house_number, address, city, zip, provience, userId } = req.body;
        if (!addressId) {
            res.status(400).json({
                success: false,
                message: 'addressId is required in form-data.'
            });
            return;
        }
        const updateFields = {};
        if (type)
            updateFields.type = type;
        if (full_name)
            updateFields.full_name = full_name;
        if (house_number)
            updateFields.house_number = house_number;
        if (address)
            updateFields.address = address;
        if (city)
            updateFields.city = city;
        if (zip)
            updateFields.zip = zip;
        if (provience)
            updateFields.provience = provience;
        if (userId)
            updateFields.userId = userId;
        const updatedAddress = yield address_model_1.default.findByIdAndUpdate(addressId, { $set: updateFields }, { new: true }).populate('userId').lean();
        if (!updatedAddress) {
            res.status(404).json({
                success: false,
                message: 'Address not found.'
            });
            return;
        }
        res.status(200).json({
            success: true,
            message: 'Address updated successfully.',
            data: updatedAddress
        });
    }
    catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error while updating address.',
            error: error.message
        });
    }
});
exports.updateAddress = updateAddress;
const deleteAddress = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { addressId } = req.body;
        if (!addressId) {
            res.status(400).json({
                success: false,
                message: 'addressId is required in form-data.'
            });
            return;
        }
        const deletedAddress = yield address_model_1.default.findByIdAndDelete(addressId);
        if (!deletedAddress) {
            res.status(404).json({
                success: false,
                message: 'Address not found.'
            });
            return;
        }
        res.status(200).json({
            success: true,
            message: 'Address deleted successfully.',
            data: deletedAddress
        });
    }
    catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error while deleting address.',
            error: error.message
        });
    }
});
exports.deleteAddress = deleteAddress;
