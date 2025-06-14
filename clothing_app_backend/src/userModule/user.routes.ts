import express, { Router } from "express";
export const UserRoutes: Router = express.Router();
import { registerUser, updateUser, loginUser } from '../userModule/user.controller'

// api/user/register
UserRoutes.post('/register',registerUser);

UserRoutes.put('/updateUser',updateUser);

UserRoutes.put('/login',loginUser);

