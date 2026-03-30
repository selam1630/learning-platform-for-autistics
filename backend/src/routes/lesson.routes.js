const express = require("express");

const { getModules } = require("../controllers/lesson.controller");

const router = express.Router();

router.get("/modules", getModules);

module.exports = router;

