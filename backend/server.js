const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const helmet = require('helmet');
const mongoSanitize = require('express-mongo-sanitize');
const cookieParser = require('cookie-parser');
const rateLimit = require('express-rate-limit');
const connectDB = require('./config/db');
const path = require('path');

// Load env vars
dotenv.config();

// Connect to database
connectDB();

const app = express();

// Set security headers
app.use(helmet());

// Body parser
app.use(express.json());

// Cookie parser
app.use(cookieParser());

// Serve static uploads
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


// Rate limiting for auth routes to prevent brute force
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 20, // limit each IP to 20 requests per windowMs for auth
  message: { success: false, error: 'Too many authentication attempts, please try again later' }
});

// Enable CORS
app.use(cors({
  origin: process.env.FRONTEND_URL || '*',
  credentials: true,
}));

// Mount routers
app.use('/api/v1/auth', authLimiter, require('./routes/authRoutes'));
app.use('/api/v1/dashboard', require('./routes/dashboardRoutes'));
app.use('/api/v1/profile', require('./routes/profileRoutes'));

app.get('/', (req, res) => {
  res.send('Attendance API is running securely...');
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, console.log(`Server running securely on port ${PORT}`));
