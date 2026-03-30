const notFoundHandler = (req, res) => {
  res.status(404).json({
    message: `Route not found: ${req.method} ${req.originalUrl}`,
  });
};

const errorHandler = (error, _req, res, _next) => {
  const statusCode = error.statusCode || 500;

  res.status(statusCode).json({
    message: error.message || "Internal server error",
  });
};

module.exports = {
  notFoundHandler,
  errorHandler,
};

