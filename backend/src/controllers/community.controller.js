const prisma = require("../lib/prisma");

const getPosts = async (_req, res, next) => {
  try {
    const posts = await prisma.communityPost.findMany({
      where: { moderationStatus: "approved" },
      include: {
        author: {
          select: {
            fullName: true,
          },
        },
      },
      orderBy: { createdAt: "desc" },
    });

    res.json({
      posts: posts.map((post) => ({
        id: post.id,
        authorName: post.author.fullName,
        category: post.category,
        contentType: post.contentType,
        content: post.content,
      })),
    });
  } catch (error) {
    next(error);
  }
};

const createPost = async (req, res, next) => {
  try {
    const { authorId, category, content, contentType = "text" } = req.body;

    const post = await prisma.communityPost.create({
      data: {
        authorId,
        category,
        content,
        contentType,
        moderationStatus: "approved",
      },
      include: {
        author: {
          select: {
            fullName: true,
          },
        },
      },
    });

    res.status(201).json({
      post: {
        id: post.id,
        authorName: post.author.fullName,
        category: post.category,
        contentType: post.contentType,
        content: post.content,
      },
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getPosts,
  createPost,
};
