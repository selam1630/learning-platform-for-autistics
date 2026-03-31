const prisma = require("../lib/prisma");

const askAssistant = async (req, res, next) => {
  try {
    const question = (req.body.question || "").trim();
    const normalizedQuestion = question.toLowerCase();

    if (!question) {
      return res.status(400).json({
        message: "A question is required.",
      });
    }

    const answers = await prisma.assistantAnswer.findMany({
      where: { reviewedByExpert: true },
      orderBy: { createdAt: "asc" },
    });

    const match =
      answers.find((item) =>
        item.questionVariants.some((variant) =>
          normalizedQuestion.includes(variant.toLowerCase().replace("?", ""))
        )
      ) ||
      answers.find((item) =>
        item.questionKey.split("-").some((part) => normalizedQuestion.includes(part))
      ) ||
      answers[0];

    res.json({
      question,
      answer: match
        ? match.answer
        : "We do not have a reviewed answer yet. Please try a simpler question about communication, routines, or meltdowns.",
      safetyNote:
        "This assistant supports caregivers with general guidance and does not replace diagnosis, emergency care, or direct therapy.",
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  askAssistant,
};
