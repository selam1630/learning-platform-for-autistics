const prisma = require("../lib/prisma");

const getDashboard = async (_req, res, next) => {
  try {
    const [modules, posts, guidance] = await Promise.all([
      prisma.lessonModule.findMany({
        where: { status: "published" },
        orderBy: { createdAt: "asc" },
        take: 3,
      }),
      prisma.communityPost.findMany({
        where: { moderationStatus: "approved" },
        include: {
          author: {
            select: {
              fullName: true,
            },
          },
        },
        orderBy: { createdAt: "desc" },
        take: 3,
      }),
      prisma.assistantAnswer.findMany({
        where: { reviewedByExpert: true },
        orderBy: { createdAt: "asc" },
        take: 3,
      }),
    ]);

    res.json({
      hero: {
        title: "Support for families, learning for children.",
        subtitle: "Offline-friendly help in Amharic and Ethiopian context.",
      },
      modules,
      communityPosts: posts.map((post) => ({
        id: post.id,
        authorName: post.author.fullName,
        category: post.category,
        contentType: post.contentType,
        content: post.content,
      })),
      assistantGuidance: guidance.map((item) => ({
        id: item.id,
        question: item.questionVariants[0] || item.questionKey,
        answer: item.answer,
      })),
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getDashboard,
};
