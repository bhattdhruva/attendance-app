const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const argon2 = require('argon2');
const SuperAdmin = require('../models/SuperAdmin');
const AdminSession = require('../models/AdminSession');
const AuthAuditLog = require('../models/AuthAuditLog');

// @desc      Login Super Admin
// @route     POST /api/v1/auth/login
// @access    Public
exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // Validate email & password
    if (!email || !password) {
      return res.status(400).json({ success: false, error: 'Invalid credentials' });
    }

    // Check for super admin
    const admin = await SuperAdmin.findOne({ email });
    if (!admin) {
      // Create a generic failure log
      await logEvent(null, 'LOGIN_FAILED', false, req, { reason: 'User not found' });
      return res.status(401).json({ success: false, error: 'Invalid credentials' }); // Generic message
    }

    // Check account status
    if (admin.status !== 'ACTIVE') {
      await logEvent(admin._id, 'LOGIN_FAILED', false, req, { reason: 'Account disabled/locked' });
      return res.status(401).json({ success: false, error: 'Account is currently disabled or locked' });
    }

    // Verify password with argon2
    let isMatch = false;
    try {
      isMatch = await argon2.verify(admin.passwordHash, password);
    } catch(e) {
      // Internal error verifying
    }
    
    if (!isMatch) {
      // Increment failed login attempts
      admin.failedLoginAttempts += 1;
      await admin.save();
      await logEvent(admin._id, 'LOGIN_FAILED', false, req, { reason: 'Invalid password' });
      return res.status(401).json({ success: false, error: 'Invalid credentials' });
    }

    // Reset failed attempts on success
    admin.failedLoginAttempts = 0;
    admin.lastLoginAt = new Date();
    await admin.save();

    // Check for MFA requirement
    if (admin.mfaEnabled) {
      // Issue session, but mfaVerified = false
      return sendSessionTokenResponse(admin, req, res, false);
    }

    // Successful login without MFA - Issue session (mfaVerified technically false, but setup is required)
    await sendSessionTokenResponse(admin, req, res, false);



  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

// @desc      Logout (Revoke current session)
// @route     POST /api/v1/auth/logout
// @access    Private (Super Admin)
exports.logout = async (req, res, next) => {
  try {
    if (req.sessionId) {
      await AdminSession.findByIdAndUpdate(req.sessionId, {
        revokedAt: new Date()
      });
      await logEvent(req.admin._id, 'LOGOUT', true, req);
    }

    res.cookie('sessionId', 'none', {
      expires: new Date(Date.now() + 10 * 1000), // expire in 10 seconds
      httpOnly: true,
    });

    res.status(200).json({ success: true, message: 'Logged out successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

// @desc      Get current logged in Super Admin Profile
// @route     GET /api/v1/auth/me
// @access    Private (Super Admin)
exports.getMe = async (req, res, next) => {
  try {
    // Return sanitized profile (exclude sensitive fields)
    const profile = {
      id: req.admin._id,
      fullName: req.admin.fullName,
      email: req.admin.email,
      role: req.admin.role,
      status: req.admin.status,
      mfaEnabled: req.admin.mfaEnabled,
      lastLoginAt: req.admin.lastLoginAt,
    };
    res.status(200).json({ success: true, data: profile });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

// Helper: Generate Token and Store DB Session
const sendSessionTokenResponse = async (admin, req, res, mfaVerified = false) => {
  // Generate a JWT as the opaque token holding only the admin ID
  const token = jwt.sign({ id: admin._id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE || '30d'
  });

  // Hash the token for DB storage
  const sessionTokenHash = crypto.createHash('sha256').update(token).digest('hex');

  // Parse expiration days from env
  const expiresInDays = parseInt(process.env.JWT_EXPIRE || '30');
  const expiresAt = new Date(Date.now() + expiresInDays * 24 * 60 * 60 * 1000);

  // Store in DB
  await AdminSession.create({
    adminId: admin._id,
    sessionTokenHash,
    expiresAt,
    userAgent: req.headers['user-agent'],
    ipAddress: req.ip || req.connection.remoteAddress,
    mfaVerified
  });

  await logEvent(admin._id, 'LOGIN_SUCCESS', true, req);

  // Send cookie
  const options = {
    expires: expiresAt,
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production'
  };

  res.status(200).cookie('sessionId', token, options).json({
    success: true,
    token, // Send token to support Flutter Mobile app which might use Bearer token
    mfaRequired: !mfaVerified && admin.mfaEnabled,
    mfaSetupRequired: !admin.mfaEnabled,
    user: {
      id: admin._id,
      fullName: admin.fullName,
      email: admin.email,
      role: admin.role,
    }
  });
};

// Helper: Audit Logging
const logEvent = async (adminId, eventType, success, req, metadata = {}) => {
  try {
    await AuthAuditLog.create({
      adminId,
      eventType,
      success,
      ipAddress: req.ip || req.connection.remoteAddress,
      userAgent: req.headers['user-agent'],
      metadata,
    });
  } catch (err) {
    console.error('Failed to write audit log:', err);
  }
};
