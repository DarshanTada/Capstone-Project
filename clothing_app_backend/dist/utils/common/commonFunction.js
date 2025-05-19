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
exports.thirdParam = void 0;
exports.addMonths = addMonths;
exports.getDaysArray = getDaysArray;
exports.addDays = addDays;
exports.removeDays = removeDays;
exports.generateRandomNumber = generateRandomNumber;
exports.sortDays = sortDays;
exports.getDetailsFromPincode = getDetailsFromPincode;
exports.getMonthString = getMonthString;
exports.numberToPositionString = numberToPositionString;
exports.getTimePeriod = getTimePeriod;
exports.get12HrFormat = get12HrFormat;
const geocoder_1 = require("../../utils/geocoder");
function addMonths(date, months) {
    var d = date.getDate();
    date.setMonth(date.getMonth() + +months);
    if (date.getDate() != d) {
        date.setDate(0);
    }
    return date;
}
function getDaysArray(start, end) {
    for (var arr = [], dt = new Date(start); dt <= new Date(end); dt.setDate(dt.getDate() + 1)) {
        arr.push(new Date(dt));
    }
    return arr;
}
;
function addDays(date, day) {
    return new Date(date.setDate(date.getDate() + day));
}
function removeDays(date, day) {
    return new Date(date.setDate(date.getDate() - day));
}
function generateRandomNumber(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
}
function sortDays(unsortedDays) {
    let daysSort = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    let sortedDays = [];
    daysSort.forEach((value) => {
        if (unsortedDays.includes(value)) {
            sortedDays.push(value);
        }
    });
    return sortedDays;
}
function getDetailsFromPincode(pincode) {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            const data = yield geocoder_1.geocoder.geocode(pincode);
            return {
                city: data[0]['city'] == null ? '' : data[0]['city'],
                state: data[0]['administrativeLevels']['level1long'],
            };
        }
        catch (error) {
            return {
                'city': '',
                'state': '',
            };
        }
    });
}
function getMonthString(month) {
    switch (month) {
        case 1: return 'Jan';
        case 2: return 'Feb';
        case 3: return 'Mar';
        case 4: return 'Apr';
        case 5: return 'May';
        case 6: return 'Jun';
        case 7: return 'Jul';
        case 8: return 'Aug';
        case 9: return 'Sep';
        case 10: return 'Oct';
        case 11: return 'Nov';
        case 12: return 'Dec';
        default: return '';
    }
}
function numberToPositionString(number) {
    if (number >= 11 && number <= 13) {
        return `${number}th`;
    }
    else if (number.toString().endsWith('1')) {
        return `${number}st`;
    }
    else if (number.toString().endsWith('2')) {
        return `${number}nd`;
    }
    else if (number.toString().endsWith('3')) {
        return `${number}rd`;
    }
    else {
        return `${number}th`;
    }
}
function getTimePeriod(time) {
    if (time >= 12) {
        return `pm`;
    }
    else {
        return `am`;
    }
}
function get12HrFormat(time) {
    if (time >= 13 && time <= 24) {
        if (time == 13.0) {
            return 1.0;
        }
        else if (time == 13.3) {
            return 1.3;
        }
        else if (time == 14.0) {
            return 2.0;
        }
        else if (time == 14.3) {
            return 2.3;
        }
        else if (time == 15.0) {
            return 3.0;
        }
        else if (time == 15.3) {
            return 3.3;
        }
        else if (time == 16.0) {
            return 4.0;
        }
        else if (time == 16.3) {
            return 4.3;
        }
        else if (time == 17.0) {
            return 5.0;
        }
        else if (time == 17.3) {
            return 5.3;
        }
        else if (time == 18.0) {
            return 6.0;
        }
        else if (time == 18.3) {
            return 6.3;
        }
        else if (time == 19.0) {
            return 7.0;
        }
        else if (time == 19.3) {
            return 7.3;
        }
        else if (time == 20.0) {
            return 8.0;
        }
        else if (time == 20.3) {
            return 8.3;
        }
        else if (time == 21.0) {
            return 9.0;
        }
        else if (time == 21.3) {
            return 9.3;
        }
        else if (time == 22.0) {
            return 10.0;
        }
        else if (time == 22.3) {
            return 10.3;
        }
        else if (time == 23.0) {
            return 11.0;
        }
        else if (time == 23.3) {
            return 11.3;
        }
        else if (time == 24.0) {
            return 0.0;
        }
        else if (time == 24.3) {
            return 0.3;
        }
    }
    else {
        return time;
    }
}
exports.thirdParam = { new: true, runValidators: true };
