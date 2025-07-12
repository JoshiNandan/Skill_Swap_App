const User = require("../models/User");
const SwapRequest = require("../models/SwapRequest");

// ✅ 1. Get All Swaps
exports.getAllSwaps = async (req, res) => {
  try {
    const swaps = await SwapRequest.find()
      .populate("fromUserId", "name email")
      .populate("toUserId", "name email");

    res.json(swaps);
  } catch (err) {
    console.error("❌ getAllSwaps error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
};

// ✅ 2. Ban a User
exports.banUser = async (req, res) => {
  try {
    const user = await User.findByIdAndUpdate(
      req.params.id,
      { isBanned: true }, // ✅ Fixed: Changed from 'banned' to 'isBanned'
      { new: true } // ✅ Return updated user
    );

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ message: "User banned", user });
  } catch (err) {
    console.error("❌ banUser error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
};

exports.sendBroadcastMessage = async (req, res) => {
  try {
    const { message } = req.body;

    if (!message) {
      return res.status(400).json({ message: "Message is required" });
    }

    // In real app: save to DB, send push, etc.
    console.log("📢 Broadcast message from admin:", message);

    res.json({ message: `Broadcast sent: ${message}` });
  } catch (err) {
    console.error("❌ sendBroadcastMessage error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
};

// ✅ 4. Get Reports
exports.getReports = async (req, res) => {
  try {
    const userCount = await User.countDocuments();
    const bannedUsers = await User.countDocuments({ banned: true });

    const swapStats = await SwapRequest.aggregate([
      { $group: { _id: "$status", count: { $sum: 1 } } }
    ]);

    res.json({
      users: userCount,
      bannedUsers,
      swaps: swapStats
    });
  } catch (err) {
    console.error("❌ getReports error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
};