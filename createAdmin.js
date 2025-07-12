const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
require("dotenv").config();
const User = require("./models/User");

mongoose.connect(process.env.MONGO_URI)
  .then(async () => {
    const existing = await User.findOne({ email: "admin@skillapp.com" });
    if (existing) {
      console.log("Admin already exists.");
      process.exit(0);
    }

    const hashed = await bcrypt.hash("admin123", 10);

    const admin = new User({
      name: "Admin",
      email: "admin@skillapp.com",
      password: hashed,
      role: "admin"
    });

    await admin.save();
    console.log("✅ Admin created with email: admin@skillapp.com");
    process.exit(0);
  })
  .catch((err) => {
    console.error("DB error", err);
    process.exit(1);
  });