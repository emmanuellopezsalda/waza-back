import { createPool } from "mysql2/promise";

export const db = createPool({
    database: "wazaa",
    user: "root",
    host: "localhost",
    password: "",
    port: 3306
})