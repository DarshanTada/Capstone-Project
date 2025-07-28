import mongoose from "mongoose";


export const REASONS = {
  GENERAL: "General Inquiry",
  ORDER_SUPPORT: "Order Suppor",
  TECHNICAL_ISSUE: "Technical Issue",
  RETURN_EXCHANGE: "Return Exchange",
  ACCOUNT_HELP: "Account Help",
  FEEDBACK: "Feedback"
};


const contactUsSchema = new mongoose.Schema(
  {
    name: String,
    email: String,
    category:  {
      type: String,
      enum: Object.values(REASONS),
      default: REASONS.GENERAL,
      required: true,
    },
    subject: String,
    message: String
  },
  { timestamps: true }
);

const ContactUs = mongoose.model("ContactUs", contactUsSchema);
export default ContactUs;
