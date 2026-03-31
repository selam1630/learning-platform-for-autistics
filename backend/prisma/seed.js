const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

const lessonModules = [
  {
    slug: "communication-basics",
    title: "Communication Basics",
    titleAm: "መሰረታዊ ግንኙነት",
    description: "First words, visuals, pointing, and simple response practice.",
    status: "published",
    offlineReady: true,
  },
  {
    slug: "emotions-social-skills",
    title: "Emotions & Social Skills",
    titleAm: "ስሜቶች እና ማህበራዊ ክህሎቶች",
    description: "Help children recognize emotions and common social cues.",
    status: "published",
    offlineReady: true,
  },
  {
    slug: "daily-routines",
    title: "Daily Routines",
    titleAm: "ዕለታዊ ልምዶች",
    description: "Support dressing, eating, and hygiene using visual steps.",
    status: "published",
    offlineReady: true,
  },
];

const assistantAnswers = [
  {
    questionKey: "child-not-speaking",
    questionVariants: [
      "My child is not speaking, what should I do?",
      "How can I help my child speak?",
    ],
    answer:
      "Start with short repeated words, picture cards, gestures, and daily naming routines. Praise every attempt to communicate, even pointing or eye contact.",
    reviewedByExpert: true,
  },
  {
    questionKey: "meltdowns",
    questionVariants: [
      "How do I handle meltdowns?",
      "What should I do during a meltdown?",
    ],
    answer:
      "Reduce noise, keep your voice calm, move to a safe quiet place, and avoid too many instructions. Later, notice the triggers and build a predictable routine.",
    reviewedByExpert: true,
  },
  {
    questionKey: "daily-routines",
    questionVariants: [
      "How do I teach routines?",
      "How can I make daily routines easier?",
    ],
    answer:
      "Use one routine at a time with a small visual sequence. Practice at the same time each day and celebrate small successes with praise or a favorite activity.",
    reviewedByExpert: true,
  },
];

const seed = async () => {
  const parentUser = await prisma.user.upsert({
    where: { phone: "+251911000001" },
    update: {},
    create: {
      fullName: "Selam Parent",
      phone: "+251911000001",
      passwordHash: "demo-password-hash",
      preferredLanguage: "am",
      role: "parent",
    },
  });

  for (const module of lessonModules) {
    await prisma.lessonModule.upsert({
      where: { slug: module.slug },
      update: module,
      create: module,
    });
  }

  for (const answer of assistantAnswers) {
    await prisma.assistantAnswer.upsert({
      where: { questionKey: answer.questionKey },
      update: answer,
      create: answer,
    });
  }

  const communityPosts = [
    {
      authorId: parentUser.id,
      category: "communication",
      contentType: "text",
      content:
        "Using picture cards during breakfast helped my child point to what he wants instead of getting frustrated.",
      moderationStatus: "approved",
    },
    {
      authorId: parentUser.id,
      category: "daily_life",
      contentType: "text",
      content:
        "A simple toothbrush chart made morning hygiene much easier for us this week.",
      moderationStatus: "approved",
    },
  ];

  await prisma.communityPost.deleteMany({
    where: { authorId: parentUser.id },
  });

  await prisma.communityPost.createMany({
    data: communityPosts,
  });

  console.log("Seed data ready");
};

seed()
  .catch((error) => {
    console.error("Seed failed", error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
