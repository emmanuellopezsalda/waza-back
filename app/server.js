import express from 'express';
import routes from './routes/index.js';

const server = express();

server.use(express.json());
server.set("port", process.env.PORT || 3000);
server.use("/", routes)

export default server;