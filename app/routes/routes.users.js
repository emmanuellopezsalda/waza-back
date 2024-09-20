import { Router } from "express";
import { getUsers, login } from "../controllers/users.controllers.js";

const routesUsers = Router();

routesUsers.get("/", getUsers);
routesUsers.post("/", login)
export default routesUsers;