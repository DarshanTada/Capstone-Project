import express, { Router } from "express";
export const UserRoutes: Router = express.Router();
<<<<<<< HEAD
import { loginOrRegisterUser, updateUser, loginUser, registerUser } from '../userModule/user.controller'
import { upload } from '../utils/common/multer'
=======
import { loginOrRegisterUser, updateUser, loginUser, getAllUsers} from '../userModule/user.controller'
>>>>>>> f0bbcca (role based access)

// api/user/register
UserRoutes.post('/loginOrRegisterUser',loginOrRegisterUser);

UserRoutes.put('/updateUser',updateUser);

UserRoutes.put('/login',loginUser);

<<<<<<< HEAD
UserRoutes.post("/register", registerUser)
=======
UserRoutes.get('/list',getAllUsers);
>>>>>>> f0bbcca (role based access)

