const mongoose = require('mongoose');

const authAuditLogSchema = new mongoose.Schema({
  adminId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'SuperAdmin',
  },
  eventType: {
    type: String,
    required: true,
  },
  success: {
    type: Boolean,
    required: true,
  },
  requestId: {
    type: String,
  },
  ipAddress: {
    type: String,
  },
  userAgent: {
    type: String,
  },
  metadata: {
    type: mongoose.Schema.Types.Mixed,
  },
}, { timestamps: { createdAt: 'timestamp', updatedAt: false } });

module.exports = mongoose.model('AuthAuditLog', authAuditLogSchema);
