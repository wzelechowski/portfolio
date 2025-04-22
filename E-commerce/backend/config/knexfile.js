const { dbhost, dbuser, dbpassword, dbname } = require('../.env');
module.exports = {
  client: 'mysql2',
  connection: {
    host: dbhost,
    user: dbuser,
    password: dbpassword,
    database: dbname,
  },
  migrations: {
    directory: '../migrations',
  },
};
