const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  password: String,
  location: String,
  profilePhoto: String,
  skillsOffered: [String],
  skillsWanted: [String],
  availability: [String],
  isPublic: { type: Boolean, default: true },
  role: { type: String, enum: ['user', 'admin'], default: 'user' },
  isBanned: { type: Boolean, default: false },
  feedbacks: [
    {
      fromUserId: mongoose.Schema.Types.ObjectId,
      comment: String,
      stars: Number
    }
  ]
});

module.exports = mongoose.model("User", userSchema);