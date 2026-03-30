const mongoose = require("mongoose");

const communityPostSchema = new mongoose.Schema(
  {
    authorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    category: {
      type: String,
      enum: ["communication", "behavior", "daily-life", "school", "general"],
      required: true,
    },
    contentType: {
      type: String,
      enum: ["text", "voice"],
      default: "text",
    },
    content: {
      type: String,
      required: true,
    },
    moderationStatus: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("CommunityPost", communityPostSchema);

