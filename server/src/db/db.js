const { join } = require("path");
const Database = require("nedb-promises");
const db = Database.create({
  autoload: true,
  filename: join(__dirname, "test.db"),
});

db.users = Database.create({
  autoload: true,
  filename: join(__dirname, "test.db"),
});
module.exports = db;
