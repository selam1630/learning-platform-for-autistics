const prisma = require("../lib/prisma");

const getModules = async (_req, res, next) => {
  try {
    const modules = await prisma.lessonModule.findMany({
      where: { status: "published" },
      orderBy: { createdAt: "asc" },
    });

    res.json({ modules });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getModules,
};
