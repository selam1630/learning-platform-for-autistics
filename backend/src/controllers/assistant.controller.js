const askAssistant = async (req, res) => {
  const { question } = req.body;

  res.json({
    question,
    answer:
      "This is a placeholder expert-backed response. Next, we can map frequent caregiver questions to reviewed guidance.",
    safetyNote:
      "This assistant should support caregivers but not replace medical diagnosis or emergency care.",
  });
};

module.exports = {
  askAssistant,
};

