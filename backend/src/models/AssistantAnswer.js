const mongoose = require("mongoose");

const assistantAnswerSchema = new mongoose.Schema(
  {
    questionKey: {
      type: String,
      required: true,
      unique: true,
    },
    language: {
      type: String,
      default: "am",
    },
    questionVariants: {
      type: [String],
      default: [],
    },
    answer: {
      type: String,
      required: true,
    },
    reviewedByExpert: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("AssistantAnswer", assistantAnswerSchema);
