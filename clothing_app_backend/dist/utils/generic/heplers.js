"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.extractExtention = extractExtention;
function extractExtention(filename) {
    const regex = /(?:\.([^.]+))?$/;
    const extractedFilename = regex.exec(filename);
    if (extractedFilename) {
        return extractedFilename[1].toLowerCase();
    }
    return undefined;
}
