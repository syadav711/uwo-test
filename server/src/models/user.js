const db = require("../db/db");
const Database = require("nedb-promises");
/**
 * @type { Database }
 */
const users = db.users;

const addUser = async (user) => {
  return users.insert(user);
};

const findUser = async (email, password) => {
  return users.findOne({
    email,
    password,
  });
};

const allUser = async (email, password) => {
  return users.find();
};

module.exports = {
  addUser,
  findUser,
  allUser,
};
