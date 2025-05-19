import AWS from "aws-sdk";

AWS.config.update({
  accessKeyId: process.env.SES_ACCESSKEY,
  secretAccessKey: process.env.SES_SECRETKEY,
  region: process.env.REGION,
});

export const sendSms = async (mobileNo: any, message: any,campaignId: any) => {
  // var mobileNo = mobileno;
  var mobileNumber = "+91-" + mobileNo;
  var params = {
    Message: `${message}`,
    PhoneNumber: mobileNumber,
    MessageStructure: "string",
  };
  return new AWS.SNS({ apiVersion: "2010–03–31" })
    .publish(params)
    .promise()
    .then(async (message) => {
      console.log(message);
      return message;
    });
};
