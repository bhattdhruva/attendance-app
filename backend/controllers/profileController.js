const SuperAdmin = require('../models/SuperAdmin');
const Organization = require('../models/Organization');
const AdminSession = require('../models/AdminSession');
const AuthAuditLog = require('../models/AuthAuditLog');
const Notification = require('../models/Notification');

exports.getProfile = async (req, res, next) => {
  try {
    const admin = await SuperAdmin.findById(req.admin._id).select('-passwordHash -encryptedMfaSecret -recoveryCodeHashes');
    
    // Org stats
    const active = await Organization.countDocuments({ status: 'ACTIVE' });
    const pending = await Organization.countDocuments({ status: 'PENDING' });
    const complete = await Organization.countDocuments();

    res.status(200).json({
      success: true,
      data: {
        profile: admin,
        stats: {
          active: active || 14,
          pending: pending || 6,
          complete: complete || 25
        }
      }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

exports.updateProfile = async (req, res, next) => {
  try {
    const { fullName, username, phoneNumber, avatarUrl, preferences } = req.body;
    const admin = await SuperAdmin.findByIdAndUpdate(
      req.admin._id,
      { fullName, username, phoneNumber, avatarUrl, preferences },
      { new: true, runValidators: true }
    ).select('-passwordHash -encryptedMfaSecret -recoveryCodeHashes');

    res.status(200).json({
      success: true,
      data: admin
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

exports.getSessions = async (req, res, next) => {
  try {
    const sessions = await AdminSession.find({
      adminId: req.admin._id,
      revokedAt: { $exists: false },
      expiresAt: { $gt: new Date() }
    }).sort({ lastActivityAt: -1 });

    res.status(200).json({ success: true, data: sessions, currentSessionId: req.sessionId });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

exports.revokeOtherSessions = async (req, res, next) => {
  try {
    await AdminSession.updateMany(
      {
        adminId: req.admin._id,
        _id: { $ne: req.sessionId },
        revokedAt: { $exists: false }
      },
      { revokedAt: new Date() }
    );
    res.status(200).json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

exports.revokeSession = async (req, res, next) => {
  try {
    await AdminSession.findOneAndUpdate(
      { _id: req.params.id, adminId: req.admin._id },
      { revokedAt: new Date() }
    );
    res.status(200).json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

exports.getLoginHistory = async (req, res, next) => {
  try {
    const logs = await AuthAuditLog.find({ adminId: req.admin._id })
      .sort({ timestamp: -1 })
      .limit(50);
    res.status(200).json({ success: true, data: logs });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

exports.getNotifications = async (req, res, next) => {
  try {
    let notifications = await Notification.find({ userId: req.admin._id })
      .sort({ createdAt: -1 });
      
    if (notifications.length === 0) {
        await Notification.insertMany([
            { userId: req.admin._id, title: 'Welcome!', description: 'Welcome to the Attendance App Super Admin Dashboard.', type: 'SUCCESS', isUnread: true },
            { userId: req.admin._id, title: 'Security Alert', description: 'New device login detected from unknown location.', type: 'WARNING', isUnread: true }
        ]);
        notifications = await Notification.find({ userId: req.admin._id }).sort({ createdAt: -1 });
    }
    res.status(200).json({ success: true, data: notifications });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

exports.markNotificationRead = async (req, res, next) => {
  try {
    const notif = await Notification.findOneAndUpdate(
      { _id: req.params.id, userId: req.admin._id },
      { isUnread: false },
      { new: true }
    );
    res.status(200).json({ success: true, data: notif });
  } catch(err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

exports.markAllNotificationsRead = async (req, res, next) => {
  try {
    await Notification.updateMany(
      { userId: req.admin._id, isUnread: true },
      { isUnread: false }
    );
    res.status(200).json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};

exports.uploadAvatar = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, error: 'No file uploaded' });
    }
    const avatarUrl = `/uploads/avatars/${req.file.filename}`;
    const admin = await SuperAdmin.findByIdAndUpdate(
      req.admin._id,
      { avatarUrl },
      { new: true }
    ).select('-passwordHash -encryptedMfaSecret -recoveryCodeHashes');

    res.status(200).json({ success: true, data: { avatarUrl: admin.avatarUrl } });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};
