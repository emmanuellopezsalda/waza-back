import { Router } from "express";
import { createMessage, getLastMessage, getMessages } from "../controllers/messages.controllers.js";

const routesMessages = Router();

routesMessages.get("/:id_chat", getMessages);
routesMessages.get("/last_message/:id_chat", getLastMessage);
routesMessages.post("/", createMessage);

export default routesMessages;