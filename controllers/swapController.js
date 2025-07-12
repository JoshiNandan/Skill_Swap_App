const SwapRequest = require("../models/SwapRequest");

exports.requestSwap = async (req, res) => {
  try {
    const { toUserId, skillOffered, skillRequested } = req.body;
    const swap = new SwapRequest({
      fromUserId: req.user._id,
      toUserId,
      skillOffered,
      skillRequested
    });
    await swap.save();
    res.status(201).json({ message: "Swap request sent", swap });
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.getMySwaps = async (req, res) => {
  try {
    const swaps = await SwapRequest.find({
      $or: [{ fromUserId: req.user._id }, { toUserId: req.user._id }]
    }).populate("fromUserId", "name").populate("toUserId", "name");

    res.json(swaps);
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.acceptSwap = async (req, res) => {
  try {
    const swap = await SwapRequest.findById(req.params.id);
    if (!swap) return res.status(404).json({ message: "Swap not found" });

    if (String(swap.toUserId) !== req.user._id.toString())
      return res.status(403).json({ message: "Unauthorized" });

    swap.status = "accepted";
    await swap.save();
    res.json({ message: "Swap accepted", swap });
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.rejectSwap = async (req, res) => {
  try {
    const swap = await SwapRequest.findById(req.params.id);
    if (!swap) return res.status(404).json({ message: "Swap not found" });

    if (String(swap.toUserId) !== req.user._id.toString())
      return res.status(403).json({ message: "Unauthorized" });

    swap.status = "rejected";
    await swap.save();
    res.json({ message: "Swap rejected", swap });
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.deleteSwap = async (req, res) => {
  try {
    const swap = await SwapRequest.findById(req.params.id);
    if (!swap) return res.status(404).json({ message: "Swap not found" });

    if (String(swap.fromUserId) !== req.user._id.toString())
      return res.status(403).json({ message: "Unauthorized" });

    await swap.deleteOne();
    res.json({ message: "Swap request deleted" });
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
};