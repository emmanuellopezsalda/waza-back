import { Router } from "express";
import { getChats, postChat } from "../controllers/chats.controllers.js";

const routesChats = Router();

routesChats.get("/:id_user_1", getChats)
routesChats.post("/", postChat);

export default routesChats;