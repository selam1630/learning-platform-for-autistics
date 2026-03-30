const dotenv = require("dotenv");

dotenv.config();

const env = {
  port: Number(process.env.PORT) || 5000,
  nodeEnv: process.env.NODE_ENV || "development",
  clientUrl: process.env.CLIENT_URL || "http://localhost:3000",
  databaseUrl:
    process.env.DATABASE_URL || "mongodb://127.0.0.1:27017/ethiopia-autism-support",
  jwtSecret: process.env.JWT_SECRET || "change-me",
};

module.exports = { env };
