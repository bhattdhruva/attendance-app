const { generateSecret, generateURI, verify } = require('otplib');
const qrcode = require('qrcode');
const SuperAdmin = require('../models/SuperAdmin');
const AuthAuditLog = require('../models/AuthAuditLog');

// @desc      Setup MFA (Generate Secret & QR Code)
// @route     POST /api/v1/auth/mfa/setup
// @access    Private (Super Admin)
exports.setupMfa = async (req, res, next) => {
  try {
    const admin = req.admin; // from protectSuperAdmin middleware

    // Generate secret
    const secret = generateSecret();
    
    // In production, encrypt this secret before saving it. For now, saving directly for simplicity.
    admin.encryptedMfaSecret = secret;
    await admin.save();

    // Generate otpauth URL
    const otpauthUrl = generateURI({ accountName: admin.email, issuer: 'HRMS Attendance App', secret });
    
    // Generate QR Code data URL
    const qrCodeUrl = await qrcode.toDataURL(otpauthUrl);

    // Audit log
    await AuthAuditLog.create({
      adminId: admin._id,
      eventType: 'MFA_SETUP_STARTED',
      success: true,
      ipAddress: req.ip,
      userAgent: req.headers['user-agent'],
    });

    res.status(200).json({
      success: true,
      data: {
        secret: secret,
        qrCodeUrl: qrCodeUrl,
      }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

// @desc      Verify & Enable MFA
// @route     POST /api/v1/auth/mfa/enable
// @access    Private (Super Admin)
exports.enableMfa = async (req, res, next) => {
  try {
    const { code } = req.body;
    const admin = req.admin;

    if (!code) {
      return res.status(400).json({ success: false, error: 'Please provide the 6-digit code' });
    }

    if (!admin.encryptedMfaSecret) {
      return res.status(400).json({ success: false, error: 'MFA setup not initiated' });
    }

    // Verify token
    const isValid = verify({ token: code, secret: admin.encryptedMfaSecret });

    if (!isValid) {
      // Audit log failure
      await AuthAuditLog.create({
        adminId: admin._id,
        eventType: 'MFA_SETUP_FAILED',
        success: false,
        ipAddress: req.ip,
        userAgent: req.headers['user-agent'],
      });
      return res.status(400).json({ success: false, error: 'Invalid authenticator code' });
    }

    // Enable MFA
    admin.mfaEnabled = true;
    await admin.save();

    // Mark current session as MFA verified
    if (req.sessionId) {
      const AdminSession = require('../models/AdminSession');
      await AdminSession.findByIdAndUpdate(req.sessionId, { mfaVerified: true });
    }

    // Audit log success
    await AuthAuditLog.create({
      adminId: admin._id,
      eventType: 'MFA_ENABLED',
      success: true,
      ipAddress: req.ip,
      userAgent: req.headers['user-agent'],
    });

    res.status(200).json({ success: true, message: 'Two-Factor Authentication enabled successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

// @desc      Verify MFA Code for Login
// @route     POST /api/v1/auth/mfa/verify
// @access    Private (Super Admin - Partial Session)
exports.verifyMfa = async (req, res, next) => {
  try {
    const { code } = req.body;
    const admin = req.admin;

    if (!code) {
      return res.status(400).json({ success: false, error: 'Please provide the 6-digit code' });
    }

    if (!admin.mfaEnabled || !admin.encryptedMfaSecret) {
      return res.status(400).json({ success: false, error: 'MFA is not enabled for this account' });
    }

    // Verify token
    const isValid = verify({ token: code, secret: admin.encryptedMfaSecret });

    if (!isValid) {
      await AuthAuditLog.create({
        adminId: admin._id,
        eventType: 'MFA_VERIFY_FAILED',
        success: false,
        ipAddress: req.ip,
        userAgent: req.headers['user-agent'],
      });
      return res.status(400).json({ success: false, error: 'Invalid authenticator code' });
    }

    // Mark current session as verified
    if (req.sessionId) {
      const AdminSession = require('../models/AdminSession');
      await AdminSession.findByIdAndUpdate(req.sessionId, { mfaVerified: true });
    }

    // Audit log success
    await AuthAuditLog.create({
      adminId: admin._id,
      eventType: 'MFA_VERIFIED',
      success: true,
      ipAddress: req.ip,
      userAgent: req.headers['user-agent'],
    });

    res.status(200).json({ success: true, message: 'MFA Verified Successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

// @desc      Disable MFA
// @route     POST /api/v1/auth/mfa/disable
// @access    Private (Super Admin)
exports.disableMfa = async (req, res, next) => {
  try {
    const admin = req.admin;

    if (!admin.mfaEnabled) {
      return res.status(400).json({ success: false, error: 'MFA is not currently enabled.' });
    }

    admin.mfaEnabled = false;
    admin.encryptedMfaSecret = undefined;
    await admin.save();

    // Audit log
    const AuthAuditLog = require('../models/AuthAuditLog');
    await AuthAuditLog.create({
      adminId: admin._id,
      eventType: 'MFA_DISABLED',
      success: true,
      ipAddress: req.ip,
      userAgent: req.headers['user-agent'],
    });

    res.status(200).json({ success: true, message: 'Two-Factor Authentication has been disabled.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};
