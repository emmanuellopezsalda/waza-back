import { db } from "../config/db.js";


export const getMessages = async(req, res) => {
    const {id_chat} = req.params;
    try {
        const request = await db.query("SELECT * FROM messages WHERE id_chat", [id_chat]);
        res.json(request[0]);
    } catch (error) {
        res.json(error);
    }
}

export const createMessage = async(req, res) => {
    const {id_chat, id_sender, message} = req.body;
    try {
        const request = await db.query("INSERT INTO `messages`(`id_chat`, `id_sender`, `message_text`) VALUES (?, ?, ?)", [id_chat, id_sender, message]);
        res.json({message: "MESSAGE SENT"})
    } catch (error) {
        res.json({error: error.message});
    }
}