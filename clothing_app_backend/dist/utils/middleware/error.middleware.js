"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorHandler = void 0;
const errorResponse_1 = require("../errorResponse");
const errorHandler = (err, req, res, next) => {
    let error = Object.assign({}, err);
    error.message = err.message;
    console.log(err);
    if (err.name === 'CastError') {
        const message = `Resource not found`;
        error = new errorResponse_1.ErrorResponse(message, 404);
    }
    if (err.code === 11000) {
        const message = 'Duplicate field value entered';
        error = new errorResponse_1.ErrorResponse(message, 400);
    }
    if (err.name === 'ValidationError') {
        const message = Object.values(err.errors).map((val) => val.message);
        error = new errorResponse_1.ErrorResponse(message, 400);
    }
    res.status(error.statusCode || 500).json({
        success: false,
        message: error.message || 'Server Error',
        statusCode: error.statusCode
    });
};
exports.errorHandler = errorHandler;
