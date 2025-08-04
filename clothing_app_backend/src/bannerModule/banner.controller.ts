import { Request, Response } from 'express';
import Banner from '../bannerModule/banner.model'; // adjust path accordingly

export const createBanner = async (req: Request, res: Response): Promise<void> => {
  try {
    const {
      title,
      description,
      type,
      redirect_url,
      priority,
      is_active
    } = req.body;

    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageFile = files?.['image']?.[0];

    if (!title || !type || !imageFile) {
      res.status(400).json({
        success: false,
        message: 'title, type, and image are required.'
      });
      return;
    }

    const imageBase64 = `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`;

    const banner = new Banner({
      title,
      description,
      type,
      redirect_url,
      priority: priority ?? 0,
      is_active: is_active ?? true,
      image: imageBase64
    });

    await banner.save();

    res.status(201).json({
      success: true,
      message: 'Banner created successfully',
      data: banner
    });
  } catch (error: any) {
    console.error('Error creating banner:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getBanners = async (req: Request, res: Response): Promise<void> => {
  try {
    const { type, is_active } = req.query;

    const filter: Record<string, any> = {};

    if (type) filter.type = type;
    if (is_active !== undefined) filter.is_active = is_active === 'true';

    const banners = await Banner.find(filter).sort({ priority: -1, created_at: -1 });

    res.status(200).json({
      success: true,
      message: 'Banners fetched successfully',
      data: banners
    });
  } catch (error: any) {
    console.error('Error fetching banners:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

export const updateBanner = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const {
      title,
      description,
      type,
      redirect_url,
      priority,
      is_active
    } = req.body;

    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageFile = files?.['image']?.[0];

    const updateData: any = {};

    if (title !== undefined) updateData.title = title;
    if (description !== undefined) updateData.description = description;
    if (type !== undefined) updateData.type = type;
    if (redirect_url !== undefined) updateData.redirect_url = redirect_url;
    if (priority !== undefined) updateData.priority = priority;
    if (is_active !== undefined) updateData.is_active = is_active === 'true' || is_active === true;

    if (imageFile) {
      const imageBase64 = `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`;
      updateData.image = imageBase64;
    }

    updateData.updated_at = new Date();

    const updatedBanner = await Banner.findByIdAndUpdate(id, updateData, {
      new: true,
      runValidators: true
    });

    if (!updatedBanner) {
      res.status(404).json({ success: false, message: 'Banner not found' });
      return;
    }

    res.status(200).json({
      success: true,
      message: 'Banner updated successfully',
      data: updatedBanner
    });
  } catch (error: any) {
    console.error('Error updating banner:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

export const deleteBanner = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const deletedBanner = await Banner.findByIdAndDelete(id);

    if (!deletedBanner) {
      res.status(404).json({
        success: false,
        message: 'Banner not found',
      });
      return;
    }

    res.status(200).json({
      success: true,
      message: 'Banner deleted successfully',
      data: deletedBanner,
    });
  } catch (error: any) {
    console.error('Error deleting banner:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};