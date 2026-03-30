const getPosts = async (_req, res) => {
  res.json({
    posts: [],
    message: "Community feed endpoint ready",
  });
};

const createPost = async (req, res) => {
  res.status(201).json({
    message: "Post creation endpoint ready",
    post: req.body,
  });
};

module.exports = {
  getPosts,
  createPost,
};

