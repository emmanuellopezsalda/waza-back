import { Router } from "express";
import { createMessage, getLastMessage, getMessages, markMessagesSeen } from "../controllers/messages.controllers.js";

const routesMessages = Router();

routesMessages.get("/chat/:id_chat/user/:id_user", getMessages);
routesMessages.get("/last_message/:id_chat/user/:id_user", getLastMessage);
routesMessages.post("/", createMessage);
routesMessages.put("/", markMessagesSeen);

export default routesMessages;