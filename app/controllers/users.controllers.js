import { db } from "../config/db.js";

export const getUsers = async(req, res) => {
    try {
        const request = await db.query("SELECT * FROM users");
        res.json(request[0]);
    } catch (err) {
        res.json(err);
    }
}
export const login = async(req, res) => {
    const {name_, phone} = req.body;
    try {
        const request = await db.query("CALL SP_LOGIN(?,?)", [name_, phone])
        res.json(request[0][0])
    } catch (err) {
        res.json(err)
    }
}   