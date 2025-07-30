import mongoose from "mongoose";

export const STATUS = {
  PENDING: "Pending",
  PROCESSING: "Processing",
  SHIPPED: "Shipped",
  DELIVERED: "Delivered",
  CANCELLED: "Cancelled",
};

export const PAYMENTMETHOD = {
  CREDITCARD: "Credit Card",
  PAYPAL: "PayPal",
  APPLEPAY: "Apple Pay",
  GOOGLEPAY: "Google Pay",
};

const productItemSchema = new mongoose.Schema({
  product: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Product",
    required: true,
  },
  variantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "ProductVariant",
    required: true,
  },
  quantity: {
    type: Number,
    required: true,
  },
  size: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    enum: Object.values(STATUS),
    default: STATUS.PENDING,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  cancelReason: {
    type: String,
    default: null,
  },
  isCancelled: {
    type: Boolean,
    default: false,
  },
}, {
  _id: true,
  timestamps: true,
});

const orderSchema = new mongoose.Schema({
  products: [productItemSchema],
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  address: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Address",
    required: true,
  },
  paymentMethod: {
    type: String,
    enum: Object.values(PAYMENTMETHOD),
    default: PAYMENTMETHOD.CREDITCARD,
    required: true,
  },
  totalAmount: {
    type: Number,
    required: true,
  }
}, {
  timestamps: true,
});

const Order = mongoose.model("Order", orderSchema);
export default Order;
