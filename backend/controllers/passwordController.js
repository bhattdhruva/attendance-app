const crypto = require('crypto');
const argon2 = require('argon2');
const SuperAdmin = require('../models/SuperAdmin');
const PasswordResetToken = require('../models/PasswordResetToken');
const AuthAuditLog = require('../models/AuthAuditLog');

// @desc      Forgot Password
// @route     POST /api/v1/auth/forgot-password
// @access    Public
exports.forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;

    const admin = await SuperAdmin.findOne({ email, status: 'ACTIVE' });
    if (!admin) {
      // Return 200 anyway to prevent email enumeration
      return res.status(200).json({ success: true, message: 'If the email exists, a reset link was sent.' });
    }

    // Generate random plain token
    const resetToken = crypto.randomBytes(32).toString('hex');
    const resetTokenHash = crypto.createHash('sha256').update(resetToken).digest('hex');

    // Create reset token in DB (expires in 15 mins)
    await PasswordResetToken.create({
      adminId: admin._id,
      tokenHash: resetTokenHash,
      expiresAt: new Date(Date.now() + 15 * 60 * 1000)
    });

    // Construct Reset URL
    const resetUrl = `attendanceapp://reset-password?token=${resetToken}&email=${email}`;
    const message = `You are receiving this email because you (or someone else) has requested the reset of a password. Please click on the following link to reset your password:\n\n${resetUrl}\n\nIf you did not request this, please ignore this email.`;

    const sendEmail = require('../utils/sendEmail');
    try {
      await sendEmail({
        email: admin.email,
        subject: 'Password Reset Token',
        message: message,
      });
    } catch (error) {
      console.error('Email sending failed:', error);
      // Still continue so they can get the token in response for local testing
    }

    // Audit log
    await AuthAuditLog.create({
      adminId: admin._id,
      eventType: 'PASSWORD_RESET_REQUESTED',
      success: true,
      ipAddress: req.ip,
      userAgent: req.headers['user-agent'],
    });

    // Note: Returning the token in the API response for testing purposes since no SMTP is setup.
    // In production, this token should ONLY be sent via email.
    res.status(200).json({ 
      success: true, 
      message: 'Reset link generated (Testing Mode)',
      token: resetToken,
      email: email
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

// @desc      Reset Password
// @route     POST /api/v1/auth/reset-password
// @access    Public
exports.resetPassword = async (req, res, next) => {
  try {
    const { email, token, newPassword } = req.body;

    if (!email || !token || !newPassword) {
      return res.status(400).json({ success: false, error: 'Invalid request' });
    }

    const admin = await SuperAdmin.findOne({ email, status: 'ACTIVE' });
    if (!admin) {
      return res.status(400).json({ success: false, error: 'Invalid or expired token' });
    }

    // Hash token from request and find in DB
    const tokenHash = crypto.createHash('sha256').update(token).digest('hex');
    const resetRecord = await PasswordResetToken.findOne({
      adminId: admin._id,
      tokenHash,
      usedAt: { $exists: false },
      expiresAt: { $gt: new Date() }
    });

    if (!resetRecord) {
      return res.status(400).json({ success: false, error: 'Invalid or expired token' });
    }

    // Hash new password
    admin.passwordHash = await argon2.hash(newPassword, { type: argon2.argon2id });
    await admin.save();

    // Mark token as used
    resetRecord.usedAt = new Date();
    await resetRecord.save();

    // Audit log
    await AuthAuditLog.create({
      adminId: admin._id,
      eventType: 'PASSWORD_RESET_COMPLETED',
      success: true,
      ipAddress: req.ip,
      userAgent: req.headers['user-agent'],
    });

    res.status(200).json({ success: true, message: 'Password has been reset successfully.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

// @desc      Change Password (when already logged in)
// @route     POST /api/v1/auth/change-password
// @access    Private (Super Admin)
exports.changePassword = async (req, res, next) => {
  try {
    const { currentPassword, newPassword } = req.body;
    const admin = req.admin;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({ success: false, error: 'Please provide current and new password' });
    }

    // Verify current password
    const isMatch = await argon2.verify(admin.passwordHash, currentPassword);
    if (!isMatch) {
      await AuthAuditLog.create({
        adminId: admin._id,
        eventType: 'PASSWORD_CHANGE_FAILED',
        success: false,
        ipAddress: req.ip,
        userAgent: req.headers['user-agent'],
      });
      return res.status(401).json({ success: false, error: 'Current password is incorrect' });
    }

    // Hash and update new password
    admin.passwordHash = await argon2.hash(newPassword, { type: argon2.argon2id });
    await admin.save();

    // Audit log
    await AuthAuditLog.create({
      adminId: admin._id,
      eventType: 'PASSWORD_CHANGED',
      success: true,
      ipAddress: req.ip,
      userAgent: req.headers['user-agent'],
    });

    res.status(200).json({ success: true, message: 'Password changed successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};
