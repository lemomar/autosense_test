import express from "express";
import router from "./routes/index";
import bodyParser from 'body-parser';



const app = express();

app.use(bodyParser.urlencoded({ extended: false }))

// parse application/json
app.use(bodyParser.json())

// Settings
app.set("port", process.env.PORT || 3000);

// middlewares
app.use(express.urlencoded({ extended: false }));

// Routes
app.use(router);

// Static files

export default app;