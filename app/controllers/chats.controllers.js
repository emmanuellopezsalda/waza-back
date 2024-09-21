import { db } from "../config/db.js";

export const getChats = async(req, res) => {
    const {id_user_1} = req.params;
    try {
        const request = await db.query(`SELECT c.id AS chat_id, 
            CASE 
            WHEN c.id_user_1 = ? THEN u2.name 
            WHEN c.id_user_2 = ? THEN u1.name 
            END AS other_user_name
            FROM chats c
            INNER JOIN users u1 ON c.id_user_1 = u1.id
            INNER JOIN users u2 ON c.id_user_2 = u2.id
            WHERE ? IN (c.id_user_1, c.id_user_2);`, [id_user_1, id_user_1, id_user_1]);
        res.json(request[0]);
    } catch (error) {
        res.json({ error });
    }
}

export const postChat = (req, res) => {
    const {id_user_1, id_user_2} = req.body;
    try {
        const request = db.query("INSERT INTO `chats`(`id_user_1`, `id_user_2`) VALUES (?, ?)", [id_user_1, id_user_2]);
        res.json({message: "CHAT CREATED"});
    } catch (error) {
        res.json({message: "ERROR: " + error.message});
    }
}