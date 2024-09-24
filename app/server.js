import express from 'express';
import routes from './routes/index.js';
import cors from 'cors';
import createWebSocketServer from './sockets/websocket.js';
// import { createRequire } from 'module';
// const require = createRequire(import.meta.url);
// const WebSocket = require('ws');

const server = express();
// const wss = new WebSocket.Server({ port: 3200 });

server.use(express.json());
server.set("port", process.env.PORT || 3000);
server.use(cors());

// wss.on('connection', (ws) => {
//     console.log('Nuevo cliente conectado');
    
//     ws.on('message', (message) => {
//         console.log(`Mensaje recibido: ${message}`);        
//         wss.clients.forEach(client => {
//             if (client.readyState === WebSocket.OPEN) {
//                 client.send(message.toString());
//             }
//         });
//     });

//     ws.on('close', () => {
//         console.log('Cliente desconectado');
//     });
// });
server.use("/", routes);
createWebSocketServer();
export default server;
