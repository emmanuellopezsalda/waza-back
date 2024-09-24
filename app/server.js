import express from 'express';
import routes from './routes/index.js';
import cors from 'cors';
import createWebSocketServer from './sockets/websocket.js';

const server = express();

server.use(express.json());
server.set("port", process.env.PORT || 3000);
server.use(cors());
server.use("/", routes);
createWebSocketServer();
export default server;
