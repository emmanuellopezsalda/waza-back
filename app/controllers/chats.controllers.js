import { db } from "../config/db.js";

export const getChats = async(req, res) => {
    const {id_user_1} = req.params;
    try {
        const request = await db.query(`CALL SP_GET_CHATS_BY_USER(?)`, [id_user_1]);
        res.json(request[0][0]);
    } catch (error) {
        res.json({ error });
    }
}

export const postChat = (req, res) => {
    const {id_user_1, id_user_2} = req.body;
    try {
        const request = db.query("CALL SP_POST_CHAT(?, ?)", [id_user_1, id_user_2]);
        res.json({message: "CHAT CREATED"});
    } catch (error) {
        res.json({message: "ERROR: " + error.message});
    }
}
