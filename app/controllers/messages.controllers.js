import { db } from "../config/db.js";


export const getMessages = async(req, res) => {
    const {id_chat, id_user} = req.params;
    try {
        const request = await db.query("CALL SP_GET_CHATS(?, ?)", [id_chat, id_user]);
        res.json(request[0][0]);
    } catch (error) {
        res.json(error);
    }
}

export const createMessage = async(req, res) => {
    const {id_chat, id_sender, message} = req.body;
    try {
        const request = await db.query("CALL SP_INSERT_MESSAGE(?,?,?)", [id_chat, id_sender, message]);
        res.json({
            id_chat: id_chat,
            id_sender: id_sender,
            message: message
        })
    } catch (error) {
        res.json({error: error.message});
    }
}
export const getLastMessage = async(req, res) => {
    const {id_chat, id_user} = req.params;
    try {
        const request = await db.query("CALL SP_LAST_MESSAGE(?, ?)", [id_chat, id_user])
        res.json(request[0])
    } catch (err) {
        console.error(err);
    }
}

export const markMessagesSeen = async (req, res) =>{
    const {id_chat, id_sender} = req.body;
    try {
        const request = await db.query("CALL SP_MARK_SEEN(?,?)", [id_chat, id_sender]);
        res.json("Messages seen");
    } catch (error) {
        console.error(err);
    }
}