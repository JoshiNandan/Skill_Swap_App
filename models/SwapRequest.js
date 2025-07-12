const mongoose = require("mongoose");

const swapRequestSchema = new mongoose.Schema({
  fromUserId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  toUserId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  skillOffered: {
    type: String,
    required: true
  },
  skillWanted: {
    type: String,
    required: true
  },
  message: String,
  status: {
    type: String,
    enum: ['pending', 'accepted', 'rejected', 'completed'],
    default: 'pending'
  },
  meetingDetails: {
    date: Date,
    time: String,
    location: String,
    notes: String
  },
  feedback: {
    fromUserFeedback: {
      rating: Number,
      comment: String,
      date: Date
    },
    toUserFeedback: {
      rating: Number,
      comment: String,
      date: Date
    }
  }
}, { timestamps: true });

module.exports = mongoose.model("SwapRequest", swapRequestSchema);