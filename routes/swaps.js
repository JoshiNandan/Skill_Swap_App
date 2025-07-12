const router = require("express").Router();
const Swap = require("../models/SwapRequest");
const auth = require("../middleware/auth");

router.post("/request", auth, async (req, res) => {
  try {
    const { toUserId, skillOffered, skillRequested } = req.body;
    const swap = new Swap({
      fromUserId: req.user._id,
      toUserId,
      skillOffered,
      skillWanted: skillRequested // Changed from skillRequested to skillWanted
    });
    await swap.save();
    res.send("Swap requested");
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.get("/my-swaps", auth, async (req, res) => {
  try {
    console.log("GET /my-swaps route hit by user:", req.user._id);
    const swaps = await Swap.find({
      $or: [{ fromUserId: req.user._id }, { toUserId: req.user._id }]
    });
    console.log("Found swaps:", swaps);
    res.json(swaps);
  } catch (error) {
    console.error("Error in /my-swaps:", error);
    res.status(500).json({ error: error.message });
  }
});

router.put("/:id/accept", auth, async (req, res) => {
  try {
    await Swap.findByIdAndUpdate(req.params.id, { status: "accepted" });
    res.send("Swap accepted");
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.put("/:id/reject", auth, async (req, res) => {
  try {
    await Swap.findByIdAndUpdate(req.params.id, { status: "rejected" });
    res.send("Swap rejected");
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.delete("/:id", auth, async (req, res) => {
  try {
    await Swap.findByIdAndUpdate(req.params.id, { status: "deleted" });
    res.send("Swap deleted");
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;