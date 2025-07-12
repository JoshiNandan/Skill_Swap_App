const express = require("express");
const dotenv = require("dotenv");
const connectDB = require("./config/db");
const cors = require("cors");

dotenv.config();
connectDB();

const app = express();

// ✅ Corrected CORS configuration
app.use(cors({
  origin: [
    "http://localhost:5000",
    "http://192.168.141.225:5000" // ✅ Your local IP address
  ],
  credentials: true
}));

// ✅ Middleware to parse JSON bodies
app.use(express.json());

// Routes
app.use("/api/auth", require("./routes/auth"));
app.use("/api/users", require("./routes/users"));
app.use("/api/swaps", require("./routes/swaps"));
app.use("/api/admin", require("./routes/admin"));

// ✅ Bind to 0.0.0.0 so other devices on the network can access
const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server running at http://192.168.141.225:${PORT}`);
});
