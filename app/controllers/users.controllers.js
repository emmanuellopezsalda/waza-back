import { db } from "../config/db.js";

export const getUsers = async(req, res) => {
    try {
        const request = await db.query("SELECT * FROM users");
        res.json(request[0]);
    } catch (err) {
        res.json(err);
    }
}   