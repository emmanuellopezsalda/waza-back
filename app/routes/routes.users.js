import { Router } from "express";
import { getUsers } from "../controllers/users.controllers.js";

const routesUsers = Router();

routesUsers.get("/", getUsers);

export default routesUsers;