import express, { Router } from "express";
export const UserRoutes: Router = express.Router();
import { upload } from '../utils/common/multer';
import { loginOrRegisterUser, updateUser, loginUser, registerAdmin, loginAdmin, getUserById, getAllUsers } from '../userModule/user.controller'


// api/user/register
UserRoutes.post('/loginOrRegisterUser',loginOrRegisterUser);
UserRoutes.put('/updateUser',updateUser);
UserRoutes.put('/login',loginUser);
UserRoutes.post("/registerAdmin",registerAdmin);
UserRoutes.post('/loginAdmin',loginAdmin);
UserRoutes.post('/user', upload.none(), getUserById);
UserRoutes.post('/users', getAllUsers);

