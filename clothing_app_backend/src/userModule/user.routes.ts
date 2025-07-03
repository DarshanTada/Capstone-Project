import express, { Router } from "express";
export const UserRoutes: Router = express.Router();
<<<<<<< HEAD
<<<<<<< HEAD
import { loginOrRegisterUser, updateUser, loginUser, registerUser } from '../userModule/user.controller'
import { upload } from '../utils/common/multer'
=======
import { loginOrRegisterUser, updateUser, loginUser, getAllUsers} from '../userModule/user.controller'
>>>>>>> f0bbcca (role based access)
=======
import { loginOrRegisterUser, updateUser, loginUser, registerAdmin, loginAdmin } from '../userModule/user.controller'

>>>>>>> 848714b (admin regiteration and login)

// api/user/register
UserRoutes.post('/loginOrRegisterUser',loginOrRegisterUser);

UserRoutes.put('/updateUser',updateUser);

UserRoutes.put('/login',loginUser);

<<<<<<< HEAD
<<<<<<< HEAD
UserRoutes.post("/register", registerUser)
=======
UserRoutes.get('/list',getAllUsers);
>>>>>>> f0bbcca (role based access)
=======
UserRoutes.post("/registerAdmin",registerAdmin);
>>>>>>> 848714b (admin regiteration and login)

UserRoutes.post('/loginAdmin',loginAdmin);
