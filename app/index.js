import server from "./server.js";

server.listen(server.get('port'), (req, res) => {
    console.log(`http://localhost:${server.get('port')}`);
})