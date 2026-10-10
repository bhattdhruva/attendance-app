const mongoose = require('mongoose');

const superAdminSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true,
  },
  username: {
    type: String,
  },
  phoneNumber: {
    type: String,
  },
  avatarUrl: {
    type: String,
  },
  preferences: {
    notifications: {
      mute: { type: Boolean, default: false },
      push: { type: Boolean, default: true },
      email: { type: Boolean, default: true }
    },
    settings: {
      security: { type: Boolean, default: true },
      privacy: { type: Boolean, default: true }
    }
  },
  passwordHash: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    default: 'SUPER_ADMIN',
    enum: ['SUPER_ADMIN'],
  },
  status: {
    type: String,
    enum: ['ACTIVE', 'DISABLED', 'LOCKED'],
    default: 'ACTIVE',
  },
  mfaEnabled: {
    type: Boolean,
    default: false,
  },
  encryptedMfaSecret: {
    type: String,
  },
  recoveryCodeHashes: [{
    type: String,
  }],
  failedLoginAttempts: {
    type: Number,
    default: 0,
  },
  lockedUntil: {
    type: Date,
  },
  passwordChangedAt: {
    type: Date,
  },
  lastLoginAt: {
    type: Date,
  },
}, { timestamps: true, collection: 'super_admins' });

module.exports = mongoose.model('SuperAdmin', superAdminSchema);
