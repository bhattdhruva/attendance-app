const mongoose = require('mongoose');

const SubscriptionSchema = new mongoose.Schema({
  organization: { type: mongoose.Schema.Types.ObjectId, ref: 'Organization', required: true },
  planName: { type: String, required: true },
  startDate: { type: Date, default: Date.now },
  endDate: { type: Date },
  status: { type: String, enum: ['ACTIVE', 'EXPIRED', 'CANCELED'], default: 'ACTIVE' }
});

module.exports = mongoose.model('Subscription', SubscriptionSchema);
