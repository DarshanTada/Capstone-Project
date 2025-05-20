import express, { Router } from "express";
export const UserRoutes: Router = express.Router();
import { login, register, editProfile, refreshUser } from '../userModule/user.controller'
import { verifyJwtToken } from "./../utils/middleware/verify-jwt-token";

// api/user/login
UserRoutes.get("/login", login);

// // api/user/register
UserRoutes.post("/register", register);

// api/user/refreshUser
UserRoutes.get("/refreshUser", verifyJwtToken, refreshUser);

// api/user/editProfile
UserRoutes.put("/editProfile", verifyJwtToken, editProfile);

// // api/user/editProfile
// UserRoutes.put("/editProfile", verifyJwtToken, editProfile);

// // api/user/updateAddress
// UserRoutes.put("/updateAddress", verifyJwtToken, updateAddress);

// // api/user/deleteFCMToken
// UserRoutes.put("/deleteFCMToken", verifyJwtToken, deleteFCMToken);

// // api/user/deleteAccount
// UserRoutes.put("/deleteAccount", verifyJwtToken, deleteAccount);

