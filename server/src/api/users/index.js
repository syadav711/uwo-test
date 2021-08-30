const Users = require("../../models/user");
const { Router } = require("express");

const router = Router();

router.post("", async (req, res) => {
  const user = await Users.addUser(req.body);
  res.send(user);
});

router.get("", async (req, res) => {
  const users = await Users.allUser();
  res.send(users);
});

module.exports = router;
