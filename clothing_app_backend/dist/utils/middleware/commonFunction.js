"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.addMonths = addMonths;
exports.addDays = addDays;
exports.removeDays = removeDays;
exports.subtractOrAddMinutes = subtractOrAddMinutes;
exports.getMinutes = getMinutes;
function addMonths(date, months) {
    var d = date.getDate();
    date.setMonth(date.getMonth() + +months);
    if (date.getDate() != d) {
        date.setDate(0);
    }
    return date;
}
function addDays(date, day) {
    return new Date(date.setDate(date.getDate() + day));
}
function removeDays(date, day) {
    return new Date(date.setDate(date.getDate() - day));
}
function subtractOrAddMinutes(add, numOfMinutes, date = new Date()) {
    if (add) {
        date.setMinutes(date.getMinutes() + numOfMinutes);
    }
    else {
        date.setMinutes(date.getMinutes() - numOfMinutes);
    }
    return date;
}
function getMinutes(duration) {
    let type = duration.split(" ")[1];
    let value = parseInt(duration.split(" ")[0]);
    if (type == 'Minutes') {
        return value;
    }
    else if (type == 'Hour' || type == "Hours") {
        return value * 60;
    }
    else if (type == 'Day' || type == "Days") {
        return value * 24 * 60;
    }
    else {
        return 0;
    }
}
