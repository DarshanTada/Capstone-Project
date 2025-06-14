import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
    },
    phone_number: {
      type: String,
    },
    email: {
      type: String,
      
      unique: true,
    },
    gender: {
      type: String,
      enum: ["male", "female", "other"],

    },
    age: {
      type: Number,
    },
    festival_objectId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Festival",
    },
    body_type: {
      type: String,
    },
    height: {
      type: Number, // cm or inches depending on your system
    },
    color_palette: {
      type: String,
    },
    relation_objectId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Relation",
    },
    photo_objectId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Photo",
    },
    size: {
      type: String,
    },
    role: {
      type: String,
      enum: ["user", "admin"],
      default: "user",
    },
    addressObjectId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Address", // assuming you have an Address model
    },
  },
  {
    timestamps: true,
  }
);

const User = mongoose.model("User", userSchema);
export default User;


// const festivalSchema = new mongoose.Schema({
//   festival_name: { type: String, required: true },
//   isEnable: { type: Boolean, default: true },
// });
// const Festival = mongoose.model("Festival", festivalSchema);

// const seasonSchema = new mongoose.Schema({
//   season_name: { type: String, required: true },
//   isEnable: { type: Boolean, default: true },
// });
// const Season = mongoose.model("Season", seasonSchema);

// const relationSchema = new mongoose.Schema({
//   userId_objectId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
//   relation: { type: String, required: true },
// });
// const Relation = mongoose.model("Relation", relationSchema);

// const preferenceTypeSchema = new mongoose.Schema({
//   user_objectId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
//   int: { type: Number },
//   type: {
//     type: String,
//     enum: ["gender", "price", "style", "occasion", "color", "body_type", "festival"],
//   },
// });
// const PreferenceType = mongoose.model("PreferenceType", preferenceTypeSchema);

// const preferenceSchema = new mongoose.Schema({
//   preference_objectId: { type: mongoose.Schema.Types.ObjectId, ref: "PreferenceType" },
//   preference: { type: String, required: true },
// });
// const Preference = mongoose.model("Preference", preferenceSchema);

// const photoSchema = new mongoose.Schema({
//   user_ObjectId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
//   image: { type: Buffer },
//   avatar_image: { type: Buffer },
// });
// const Photo = mongoose.model("Photo", photoSchema);


// const addressSchema = new mongoose.Schema(
//   {
//     longitude: {
//       type: Number,
//       required: true,
//     },
//     latitude: {
//       type: Number,
//       required: true,
//     },
//     receiver_name: {
//       type: String,
//       required: true,
//     },
//     house_number: {
//       type: String,
//       required: true,
//     },
//     street_name: {
//       type: String,
//       required: true,
//     },
//     city: {
//       type: String,
//       required: true,
//     },
//     zip: {
//       type: String,
//       required: true,
//     },
//   },
//   {
//     timestamps: true,
//   }
// );

// const Address = mongoose.model("Address", addressSchema);
