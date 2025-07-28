// controllers/addressController.ts
import { Request, Response } from 'express';
import Address from './address.model';
import User from '../userModule/user.model'; // make sure this model exists

export const addAddress = async (req: Request, res: Response): Promise<void> => {
  try {
    const {
      type,
      full_name,
      house_number,
      address,
      city,
      zip,
      provience,
      userId
    } = req.body;

    // Validate required fields
    if (
      !type ||
      !full_name ||
      !house_number ||
      !address ||
      !city ||
      !zip ||
      !provience ||
      !userId
    ) {
      res.status(400).json({
        success: false,
        message: 'All fields including userId are required.'
      });
      return;
    }

    // Check if user exists
    const user = await User.findById(userId);
    if (!user) {
      res.status(404).json({
        success: false,
        message: 'User not found.'
      });
      return;
    }

    // Save address
    const newAddress = await Address.create({
      type,
      full_name,
      house_number,
      address,
      city,
      zip,
      provience,
      userId
    });

    // Populate user data
    const populatedAddress = await Address.findById(newAddress._id).populate('userId');

    res.status(201).json({
      success: true,
      message: 'Address added successfully.',
      data: populatedAddress
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Server error while adding address.',
      error: error.message
    });
  }
};

export const getAllAddressesByUserId = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.body;

    if (!userId) {
      res.status(400).json({
        success: false,
        message: 'userId is required in form-data.'
      });
      return;
    }

    const addresses = await Address.find({ userId })
      .populate('userId')
      .lean();

    res.status(200).json({
      success: true,
      message: 'Addresses fetched successfully.',
      data: addresses
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Server error while fetching addresses.',
      error: error.message
    });
  }
};

export const updateAddress = async (req: Request, res: Response): Promise<void> => {
  try {
    const {
      addressId,      // The _id of the address document to update
      type,
      full_name,
      house_number,
      address,
      city,
      zip,
      provience,
      userId
    } = req.body;

    if (!addressId) {
      res.status(400).json({
        success: false,
        message: 'addressId is required in form-data.'
      });
      return;
    }

    // Build an update object only with fields that were passed
    const updateFields: any = {};
    if (type) updateFields.type = type;
    if (full_name) updateFields.full_name = full_name;
    if (house_number) updateFields.house_number = house_number;
    if (address) updateFields.address = address;
    if (city) updateFields.city = city;
    if (zip) updateFields.zip = zip;
    if (provience) updateFields.provience = provience;
    if (userId) updateFields.userId = userId;

    const updatedAddress = await Address.findByIdAndUpdate(
      addressId,
      { $set: updateFields },
      { new: true }
    ).populate('userId').lean();

    if (!updatedAddress) {
      res.status(404).json({
        success: false,
        message: 'Address not found.'
      });
      return;
    }

    res.status(200).json({
      success: true,
      message: 'Address updated successfully.',
      data: updatedAddress
    });

  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Server error while updating address.',
      error: error.message
    });
  }
};

export const deleteAddress = async (req: Request, res: Response): Promise<void> => {
  try {
    const { addressId } = req.body;

    if (!addressId) {
      res.status(400).json({
        success: false,
        message: 'addressId is required in form-data.'
      });
      return;
    }

    const deletedAddress = await Address.findByIdAndDelete(addressId);

    if (!deletedAddress) {
      res.status(404).json({
        success: false,
        message: 'Address not found.'
      });
      return;
    }

    res.status(200).json({
      success: true,
      message: 'Address deleted successfully.',
      data: deletedAddress
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Server error while deleting address.',
      error: error.message
    });
  }
};