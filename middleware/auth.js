const jwt = require("jsonwebtoken");

function auth(req, res, next) {
  let token;
  
  // Check for Authorization header with Bearer token
  const authHeader = req.header("Authorization");
  if (authHeader && authHeader.startsWith("Bearer ")) {
    token = authHeader.split(" ")[1];
  } else {
    // Fallback to x-auth-token header
    token = req.header("x-auth-token");
  }
  
  console.log("Authorization Header:", authHeader);
  console.log("x-auth-token Header:", req.header("x-auth-token"));
  console.log("Extracted Token:", token);

  if (!token) {
    return res.status(401).json({ message: "Access denied. No token provided." });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log("Decoded User:", decoded);
    req.user = decoded;
    next();
  } catch (error) {
    console.log("JWT Verify Error:", error.message);
    res.status(400).json({ message: "Invalid token" });
  }
}

module.exports = auth;