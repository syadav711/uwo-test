const Users = require("../../models/user");
const { Router } = require("express");

const router = Router();

router.post("/login", async (req, res) => {
  const user = await Users.findUser(req.body.email, req.body.password);
  if (!user) {
    res.sendStatus(404);
    return;
  }
  res.send(user);
});

router.get("/status", async (req, res) => {
  const token = req.headers["token"];
  if (token) {
    res.send(`logined user with token ${token}`);
    return;
  }
  res.send("please completed login first");
});

module.exports = router;
