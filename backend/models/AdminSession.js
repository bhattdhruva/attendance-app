const mongoose = require('mongoose');

const adminSessionSchema = new mongoose.Schema({
  adminId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'SuperAdmin',
    required: true,
  },
  sessionTokenHash: {
    type: String,
    required: true,
    unique: true,
  },
  expiresAt: {
    type: Date,
    required: true,
    index: { expires: '0s' }, // TTL index
  },
  lastActivityAt: {
    type: Date,
    default: Date.now,
  },
  revokedAt: {
    type: Date,
  },
  userAgent: {
    type: String,
  },
  ipAddress: {
    type: String,
  },
  mfaVerified: {
    type: Boolean,
    default: false,
  },
}, { timestamps: true });

module.exports = mongoose.model('AdminSession', adminSessionSchema);
