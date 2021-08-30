const express = require("express");
const UserRouter = require("./users/index");
const AuthRouter = require("./auth/index");

const router = express.Router();

router.use("/users/", UserRouter);
router.use("/auth/", AuthRouter);

module.exports = router;
