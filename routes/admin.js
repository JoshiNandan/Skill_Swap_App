const express = require("express");
const router = express.Router();
const adminController = require("../controllers/adminController");
const User = require("../models/User");
const Message = require("../models/Message"); // Optional: You can define this model if storing broadcast messages
const Swap = require("../models/SwapRequest");

const auth = require("../middleware/auth");
const isAdmin = require("../middleware/isAdmin");

// 🔐 Middleware ensures route is only accessible by authenticated admin
// You must be logged in and have role: "admin" to use these endpoints

// ✅ View all swaps (Controller-based)
router.get("/swaps", auth, isAdmin, adminController.getAllSwaps);

// ✅ Ban user (Controller-based)
router.put("/ban-user/:id", auth, isAdmin, adminController.banUser);

// ✅ Send global broadcast (Controller-based)
router.post("/broadcast", auth, isAdmin, adminController.sendBroadcastMessage);

// ✅ Get platform reports (Controller-based)
router.get("/reports", auth, isAdmin, adminController.getReports);

// ✅ Ban user (Direct version - optional if not using controller)
router.put("/ban/:id", auth, isAdmin, async (req, res) => {
  try {
    await User.findByIdAndUpdate(req.params.id, { banned: true });
    res.send("User banned successfully");
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
});

// ✅ Send global message (Optional: save in DB)
router.post("/message", auth, isAdmin, async (req, res) => {
  try {
    const msg = new Message({ message: req.body.message });
    await msg.save();
    res.send("Message stored");
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
});

// ✅ View swaps (Alternate direct version - optional)
router.get("/all-swaps", auth, isAdmin, async (req, res) => {
  try {
    const swaps = await Swap.find()
      .populate("fromUserId", "name email")
      .populate("toUserId", "name email");
    res.json(swaps);
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;