const bodyParser = require("body-parser");
const express = require("express");
const cookieParser = require("cookie-parser");
const router = require("./api/index");
const db = require("./db/db");

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));

// parse application/json
app.use(bodyParser.json({}));
app.use(cookieParser());
app.use("/api", router);

app.listen("3000", () => {
  console.log("Listening to PORT 3000");
});
