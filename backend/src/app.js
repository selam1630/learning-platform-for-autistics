const express = require("express");
const cors = require("cors");

const { env } = require("./config/env");
const apiRouter = require("./routes");
const { notFoundHandler, errorHandler } = require("./middleware/error.middleware");

const app = express();

const isAllowedOrigin = (origin) => {
  if (!origin) {
    return true;
  }

  if (origin === env.clientUrl) {
    return true;
  }

  return /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin);
};

app.use(
  cors({
    origin(origin, callback) {
      if (isAllowedOrigin(origin)) {
        return callback(null, true);
      }

      return callback(new Error(`CORS blocked for origin: ${origin}`));
    },
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
