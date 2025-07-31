import express, { Router } from "express";
export const UserRoutes: Router = express.Router();
import { upload } from '../utils/common/multer';
import { loginOrRegisterUser, updateUser, registerAdmin, loginAdmin, getUserById, getAllUsers, logoutUser } from '../userModule/user.controller'
import { sendBulkEmailToUsers, sendPromotionalEmailToUser } from '../userModule/user.controller';

UserRoutes.post('/sendBulkEmailToUsers', sendBulkEmailToUsers);
UserRoutes.post('/sendPromotionalEmail', sendPromotionalEmailToUser);


// api/user/register
UserRoutes.post('/loginOrRegisterUser', loginOrRegisterUser);
UserRoutes.put('/updateUser', updateUser);
UserRoutes.post("/registerAdmin", registerAdmin);
UserRoutes.post('/loginAdmin', loginAdmin);
UserRoutes.post('/logout', logoutUser);
UserRoutes.post('/userById', upload.none(), getUserById);
UserRoutes.post('/users', getAllUsers);

