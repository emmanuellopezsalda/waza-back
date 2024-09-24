import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const WebSocket = require('ws');

const createWebSocketServer = () => {
    const wss = new WebSocket.Server({ port: 3200 });

    wss.on('connection', (ws) => {
        console.log('Nuevo cliente conectado');
        
        ws.on('message', (message) => {
            console.log(`Mensaje recibido: ${message}`);        
            wss.clients.forEach(client => {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(message.toString());
                }
            });
        });
    
        ws.on('close', () => {
            console.log('Cliente desconectado');
        });
    });
};

export default createWebSocketServer;
