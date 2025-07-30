import { Response, Request, NextFunction } from "express";
import { otpRecordModel, OTPStatus } from "./otpRecord.model";
import { createAccessToken } from "./auth.middlewares";
import { uploadToS3Bucket } from "../fileUpload";
import User from "./../../../userModule/user.model"; // Fixed import

const axios = require("axios").default;
const SendOtp = require("sendotp");
const templateId = process.env.MSG91TEMPLATEID;

export const sendOTPtoUser = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { mobileNo, cc = "91" } = req.body;

    let URL;
    if (mobileNo == "8899221111" || mobileNo == "8899331111" || mobileNo == "8899441111") {
      URL = `https://api.msg91.com/api/v5/otp?template_id=${templateId}&mobile=+${cc}${mobileNo}&authkey=${process.env.MSG91AUTHKEY}&otp_length=6&otp=123456`;
    } else {
      URL = `https://api.msg91.com/api/v5/otp?template_id=${templateId}&mobile=+${cc}${mobileNo}&authkey=${process.env.MSG91AUTHKEY}&otp_length=6`;
    }

    //DEV
    res.status(200).send({
      success: true,
      result: { type: "success" },
    });

    // PROD 
    // axios
    //   .get(URL)
    //   .then(async function (response: any) {
    //     await otpRecordModel.create({
    //       mobile: mobileNo,
    //       status: OTPStatus.SUCCESS,
    //       requestId: response.data["request_id"],
    //       log: JSON.stringify(response.data),
    //     });
    //     res.status(200).send({
    //       success: true,
    //       result: response.data,
    //     });
    //   })
    //   .catch(async function (error: any) {
    //     await otpRecordModel.create({
    //       mobile: mobileNo,
    //       status: OTPStatus.FAILED,
    //       log: JSON.stringify(error),
    //     });
    //     res.status(200).send({
    //       success: true,
    //       error: error,
    //     });
    //   });

  } catch (error) {
    res.status(500).send({
      success: false,
      result: error
    });
  }

};

export const resendOTPtoUser = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { mobileNo, type = "text", cc = "91" } = req.body;
    let URL;
    if (mobileNo == "8899221111" || mobileNo == "8899331111" || mobileNo == "8899441111") {
      URL = `https://api.msg91.com/api/v5/otp/retry?authkey=${process.env.MSG91AUTHKEY}&retrytype=${type}&mobile=+${cc}${mobileNo}&otp=123456`;
    } else {
      URL = `https://api.msg91.com/api/v5/otp/retry?authkey=${process.env.MSG91AUTHKEY}&retrytype=${type}&mobile=+${cc}${mobileNo}`;
    }

    // DEV
    // res.status(200).send({
    //   success: true,
    //   result: { type: "success" },
    // });

    // // PROD
    axios
      .get(URL)
      .then(async function (response: any) {


        res.status(200).send({
          success: true,
          result: response.data,
        });
      })
      .catch(async function (error: any) {
        await otpRecordModel.create({
          mobile: mobileNo,
          status: OTPStatus.FAILED,
          log: JSON.stringify(error),
        });
        res.status(200).send({
          success: true,
          error: error,
        });
      });

  } catch (error) {
    res.status(500).send({
      success: false,
      result: error
    });
  }
};

export const verifyOTPofUser = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { mobileNo, otp, cc = "91" } = req.body;

    const URL = `https://api.msg91.com/api/v5/otp/verify?authkey=${process.env.MSG91AUTHKEY}&mobile=+${cc}${mobileNo}&otp=${otp}`;

    //DEV
    res.status(200).send({
      success: true,
      result: { type: "success" },
    });

    // PROD
    // axios
    //   .get(URL)
    //   .then(async function (response: any) {
    //     if (response.data["message"] == "OTP verified success") {
    //       let detail = await otpRecordModel
    //         .findOne({ mobile: mobileNo })
    //         .sort("-createdAt");
    //       if (detail) {
    //         await otpRecordModel.findOneAndUpdate(
    //           { _id: detail._id },
    //           { isVerified: true }
    //         );
    //       }
    //     }
    //     res.status(200).send({
    //       success: true,
    //       result: response.data,
    //     });
    //   })
    //   .catch(function (error: any) {
    //     res.status(200).send({
    //       success: true,
    //       error: error,
    //     });
    //   });

  } catch (error) {
    res.status(500).send({
      success: false,
      result: error
    });
  }
};




