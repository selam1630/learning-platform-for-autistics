const mongoose = require("mongoose");

const lessonModuleSchema = new mongoose.Schema(
  {
    slug: {
      type: String,
      required: true,
      unique: true,
    },
    title: {
      type: String,
      required: true,
    },
    titleAm: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      enum: ["draft", "published"],
      default: "draft",
    },
    offlineReady: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("LessonModule", lessonModuleSchema);

