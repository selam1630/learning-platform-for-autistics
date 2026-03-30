const express = require("express");

const authRoutes = require("./auth.routes");
const lessonRoutes = require("./lesson.routes");
const communityRoutes = require("./community.routes");
const assistantRoutes = require("./assistant.routes");

const router = express.Router();

router.get("/health", (_req, res) => {
  res.json({
    status: "ok",
    service: "backend",
  });
});

router.use("/auth", authRoutes);
router.use("/lessons", lessonRoutes);
router.use("/community", communityRoutes);
router.use("/assistant", assistantRoutes);

module.exports = router;

