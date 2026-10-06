import express from "express";
import dotenv from "dotenv";

dotenv.config();

const app = express();

app.listen(4500, ()=>{
    console.log(`server is running at port http://localhost:4500`);
})