import multer from 'multer';
// import path from 'path';

// ✅ Configure memory storage
const storage = multer.memoryStorage();

// ✅ Export the multer instance using memory storage
export const upload = multer({ storage });
export const uploadCategoryImage = upload.single('image');
export const uploadUpdateCategoryImage = upload.single('image');