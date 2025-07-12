const router = require("express").Router();
const User = require("../models/User");
const auth = require("../middleware/auth");

// Get profile
router.get("/me", auth, async (req, res) => {
  const user = await User.findById(req.user._id).select("-password");
  res.json(user);
});

// Update profile
router.put("/me", auth, async (req, res) => {
  await User.findByIdAndUpdate(req.user._id, req.body);
  res.send("Profile updated");
});

// Search users by skill
router.get("/search", async (req, res) => {
  const { skill } = req.query;
  const users = await User.find({
    isPublic: true,
    skillsOffered: { $regex: skill, $options: "i" }
  }).select("name skillsOffered profilePhoto");
  res.json(users);
});

module.exports = router;