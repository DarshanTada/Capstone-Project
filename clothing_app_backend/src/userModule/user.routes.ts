import express, { Router } from "express";
export const UserRoutes: Router = express.Router();
import { loginOrRegisterUser, updateUser, loginUser } from '../userModule/user.controller'

// api/user/register
UserRoutes.post('/loginOrRegisterUser',loginOrRegisterUser);

UserRoutes.put('/updateUser',updateUser);

UserRoutes.put('/login',loginUser);

