const prisma = require("../lib/prisma");

const connectDatabase = async () => {
  await prisma.$connect();
  console.log("Prisma connected to MongoDB");
};

module.exports = connectDatabase;
