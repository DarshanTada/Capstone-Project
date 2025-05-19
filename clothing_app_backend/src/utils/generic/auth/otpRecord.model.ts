import { getModelForClass, index, prop, Ref } from "@typegoose/typegoose";
import { ObjectId } from "mongodb";

export enum OTPStatus {
  SUCCESS = "SUCCESS",
  FAILED = "FAILED",
}
export class otpRecord {
  readonly _id: ObjectId;

  readonly createdAt: Date;

  @prop()
  mobile: string;

  @prop({ default: 0 })
  resendCount: Number;

  @prop({ default: false })
  isVerified: boolean;

  @prop({ enum: OTPStatus })
  status: OTPStatus;

  @prop()
  requestId: string;

  @prop()
  log: string;

  @prop()
  updatedDate: Date;
}

export const otpRecordModel = getModelForClass(otpRecord, {
  schemaOptions: { timestamps: true },
});
