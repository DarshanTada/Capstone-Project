import { NextFunction, request, Request, Response } from "express";
import { verify } from "jsonwebtoken";
import { UserModel } from "./../../userModule/user.model";
// import { EmployeeModel } from "../../adminModule/employeeModule/employee.model";

export const verifyJwtToken = async (
  req: any,
  res: Response,
  next: NextFunction
) => {
  try {
    const { guest } = req.query;

    if (guest && JSON.parse(guest)) {
      return next();

    } else {
      const authorization: string = req.headers.authorization || "";

      if (authorization) {

        const token = authorization.split(" ")[1];
        const payload: any = await verify(token, process.env.ACCESS_TOKEN_SECRET!);


        const user = await UserModel.findById(payload.userId);
        if (user) {
          req.body.userRole = 'User';
          req.body.user = user._id;

          return next();

        } else {
          res.status(401).json({ success: false, message: "You are not authenticated." });
        }

      } else {
        res.status(401).json({ success: false, message: "You are not authenticated." });
      }
    }
  } catch (error) {
    res.status(401).json({ success: false, message: "You are not authenticated." });
  }
};

// export const verifyAdminJwtToken = async (
//   req: any,
//   res: Response,
//   next: NextFunction
// ) => {
//   try {
//     const { guest } = req.query;

//     if (guest && JSON.parse(guest)) {
//       return next();

//     } else {
//       const authorization: string = req.headers.authorization || "";

//       if (authorization) {

//         const token = authorization.split(" ")[1];
//         const payload: any = await verify(token, process.env.ACCESS_TOKEN_SECRET_FOR_ADMIN!);

//         if (payload.type != undefined) {
//           let employeeDetail: any = await EmployeeModel.findById(payload.userId);

//           if (employeeDetail != null) {
//             req.body.requesteeDesignation = payload.type;
//             req.body.requesteeId = payload.userId;
//             return next();
//           } else {
//             res.status(401).json({ success: false, message: "You are not authenticated." });
//           }

//         } else {
//           res.status(401).json({ success: false, message: "You are not authenticated." });
//         }
//       } else {
//         res.status(401).json({ success: false, message: "You are not authenticated." });
//       }
//     }
//   } catch (error) {
//     res.status(401).json({ success: false, message: "You are not authenticated." });
//   }
// };
