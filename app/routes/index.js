import { Router } from "express";
import routesUsers from "./routes.users.js";
import routesChats from "./routes.chats.js";
import routesMessages from "./routes.messages.js";

const routes = Router();

routes.use("/users", routesUsers);
routes.use("/chats", routesChats);
routes.use("/messages", routesMessages);

export default routes;