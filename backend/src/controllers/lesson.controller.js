const getModules = async (_req, res) => {
  res.json({
    modules: [
      {
        id: "communication-basics",
        title: "Communication Basics",
        titleAm: "መሰረታዊ ግንኙነት",
        description: "First words, visuals, and simple responses.",
      },
      {
        id: "emotions-social-skills",
        title: "Emotions & Social Skills",
        titleAm: "ስሜቶች እና ማህበራዊ ክህሎቶች",
        description: "Recognizing emotions and everyday interactions.",
      },
      {
        id: "daily-routines",
        title: "Daily Routines",
        titleAm: "ዕለታዊ ልምዶች",
        description: "Eating, dressing, and hygiene routines.",
      },
    ],
  });
};

module.exports = {
  getModules,
};

