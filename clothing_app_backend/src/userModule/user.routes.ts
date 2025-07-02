import express, { Router } from "express";
export const UserRoutes: Router = express.Router();
import { loginOrRegisterUser, updateUser, loginUser, registerUser } from '../userModule/user.controller'
import { upload } from '../utils/common/multer'

// api/user/register
UserRoutes.post('/loginOrRegisterUser',loginOrRegisterUser);

UserRoutes.put('/updateUser',updateUser);

UserRoutes.put('/login',loginUser);

UserRoutes.post("/register", registerUser)

