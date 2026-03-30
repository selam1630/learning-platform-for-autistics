const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    fullName: {
      type: String,
      required: true,
      trim: true,
    },
    phone: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    passwordHash: {
      type: String,
      required: true,
    },
    preferredLanguage: {
      type: String,
      default: "am",
    },
    role: {
      type: String,
      enum: ["parent", "caregiver", "moderator", "admin"],
      default: "parent",
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("User", userSchema);

