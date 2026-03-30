const express = require("express");
const cors = require("cors");

const { env } = require("./config/env");
const apiRouter = require("./routes");
const { notFoundHandler, errorHandler } = require("./middleware/error.middleware");

const app = express();

app.use(
  cors({
    origin: env.clientUrl,
  })
);
app.use(express.json());

app.get("/", (_req, res) => {
  res.json({
    name: "Ethiopia Autism Learning & Support API",
    status: "ok",
  });
});

app.use("/api", apiRouter);
app.use(notFoundHandler);
app.use(errorHandler);

module.exports = app;

