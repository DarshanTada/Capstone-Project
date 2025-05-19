import { getModelForClass, prop, Ref } from '@typegoose/typegoose';
import { ObjectId } from 'mongodb';


export enum UserRole {
  User = 'User',
}

export class User {
  readonly _id: ObjectId;

  readonly createdAt: Date;

  readonly updatedAt: Date;

  @prop({ trim: true })
  fullName: string;

  @prop({ trim: true })
  email: string;

  @prop()
  phone: string;

  @prop({ default: '1' })
  countryCode: string;

  @prop()
  dob: Date;

  @prop()
  gender: string;

  @prop({ default: 0 })
  totalSavings: number;

  @prop()
  walletBalance: number;

  @prop()
  walletId: string;

  @prop()
  avatar: string;

  @prop()
  fcmTokens: [string];

  @prop({ default: Date.now() })
  lastActiveDate: Date;

  @prop({ default: false })
  completedWalkThrough: boolean;

  @prop({ default: false })
  isLocationAllowed: boolean;

  @prop({ default: false })
  isNotificationAllowed: boolean;

  @prop({ default: true })
  isActive: boolean;

  @prop({ default: 0 })
  activeLoyaltyPoints: number;

  @prop({ default: 0 })
  accumulatedLoyaltyPoints: number;

  @prop({ default: 0 })
  redeemableTxAmount: number;

  @prop()
  lastAwardedPointsDate: Date;

  @prop({ default: false })
  isDeleted: boolean;
}

export const UserModel = getModelForClass(User, {
  schemaOptions: { timestamps: true },
});
