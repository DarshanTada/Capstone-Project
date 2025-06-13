// import { getModelForClass, prop } from '@typegoose/typegoose';
// import { ObjectId } from 'mongodb';

// export enum IntroRole {
//   Intro = 'Intro',
// }

// export class Intro {
//   readonly _id: ObjectId;

//   readonly createdAt: Date;

//   readonly updatedAt: Date;

//   @prop({ trim: true })
//   title: string;

//   @prop({ type: () => [String] })
//   intro_description: string; 

//   @prop({ type: () => [String] })
//   image: string; 
// }

// export const IntroModel = getModelForClass(Intro, {
//   schemaOptions: { timestamps: true },
// });


import mongoose from "mongoose";

const introchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
    },
    intro_description: {
      type: String,
      required: true,
    },
    image: {
      type: Buffer,
    }
  },
  {
    timestamps: true,
  }
);

const Intro = mongoose.model("Intro", introchema);
export default Intro;
