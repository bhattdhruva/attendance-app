const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const AdminSession = require('../models/AdminSession');
const SuperAdmin = require('../models/SuperAdmin');

exports.protectSuperAdmin = async (req, res, next) => {
  try {
    let token;
    
    // Support token in HTTP-only cookie OR Authorization header (for mobile apps)
    if (req.cookies && req.cookies.sessionId) {
      token = req.cookies.sessionId;
    } else if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
      token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
      return res.status(401).json({ success: false, error: 'Not authorized to access this route' });
    }

    // Decode token securely
    let decoded;
    try {
      decoded = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
      return res.status(401).json({ success: false, error: 'Session expired or invalid' });
    }

    // Verify opaque session hash in DB
    const sessionTokenHash = crypto.createHash('sha256').update(token).digest('hex');
    const session = await AdminSession.findOne({ 
      sessionTokenHash,
      revokedAt: { $exists: false },
      expiresAt: { $gt: new Date() }
    });

    if (!session) {
      return res.status(401).json({ success: false, error: 'Session invalid or revoked' });
    }

    // Retrieve Admin
    const admin = await SuperAdmin.findById(session.adminId);
    
    if (!admin || admin.status !== 'ACTIVE') {
      return res.status(401).json({ success: false, error: 'Account disabled or not found' });
    }

    if (admin.role !== 'SUPER_ADMIN') {
      return res.status(403).json({ success: false, error: 'Forbidden: Requires Super Admin privileges' });
    }

    // Enforce MFA Verification unless they are hitting MFA setup/verify endpoints
    const bypassMfaPaths = ['/mfa/setup', '/mfa/enable', '/mfa/verify'];
    if (session.mfaVerified === false && !bypassMfaPaths.includes(req.path)) {
      return res.status(403).json({ success: false, error: 'MFA verification required' });
    }

    // Attach to request
    req.admin = admin;
    req.sessionId = session._id;
    
    // Update last activity
    session.lastActivityAt = new Date();
    await session.save();

    next();
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};
