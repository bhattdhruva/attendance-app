const express = require('express');
const { login, logout, getMe } = require('../controllers/authController');
const { forgotPassword, resetPassword, changePassword } = require('../controllers/passwordController');
const { setupMfa, enableMfa, verifyMfa, disableMfa } = require('../controllers/mfaController');
const { protectSuperAdmin } = require('../middleware/authMiddleware');

const router = express.Router();

// Public Routes
router.post('/login', login);
router.post('/forgot-password', forgotPassword);
router.post('/reset-password', resetPassword);

// Protected Super Admin Routes
router.post('/logout', protectSuperAdmin, logout);
router.get('/me', protectSuperAdmin, getMe);
router.post('/change-password', protectSuperAdmin, changePassword);
router.post('/mfa/setup', protectSuperAdmin, setupMfa);
router.post('/mfa/enable', protectSuperAdmin, enableMfa);
router.post('/mfa/verify', protectSuperAdmin, verifyMfa);
router.post('/mfa/disable', protectSuperAdmin, disableMfa);

module.exports = router;
