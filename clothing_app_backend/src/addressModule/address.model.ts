// models/Address.ts
import mongoose from 'mongoose';

const addressSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ['home', 'work', 'friend', 'other'],
    required: true
  },
  full_name: {
    type: String,
    required: true
  },
  house_number: {
    type: String,
    required: true
  },
  address: {
    type: String,
    required: true
  },
  city: {
    type: String,
    required: true
  },
  zip: {
    type: String,
    required: true
  },
  provience: {
    type: String,
    enum: [
      'Alberta',
      'British Columbia',
      'Manitoba',
      'New Brunswick',
      'Newfoundland and Labrador',
      'Nova Scotia',
      'Ontario',
      'Prince Edward Island',
      'Quebec',
      'Saskatchewan',
      'Northwest Territories',
      'Nunavut',
      'Yukon'
    ],
    required: true
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  }
});

const Address = mongoose.model('Address', addressSchema);
export default Address;
