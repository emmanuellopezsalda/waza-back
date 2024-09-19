import { Router } from "express";
import { createMessage, getMessages } from "../controllers/messages.controllers.js";

const routesMessages = Router();

routesMessages.get("/:id_chat", getMessages);
routesMessages.post("/", createMessage);

export default routesMessages;