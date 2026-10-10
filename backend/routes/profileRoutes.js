const express = require('express');
const { getProfile, updateProfile, getSessions, revokeOtherSessions, revokeSession, getLoginHistory, getNotifications, markNotificationRead, markAllNotificationsRead, uploadAvatar } = require('../controllers/profileController');
const { protectSuperAdmin } = require('../middleware/authMiddleware');
const upload = require('../middleware/uploadMiddleware');

const router = express.Router();

router.get('/', protectSuperAdmin, getProfile);
router.put('/', protectSuperAdmin, updateProfile);
router.post('/avatar', protectSuperAdmin, upload.single('avatar'), uploadAvatar);
router.get('/sessions', protectSuperAdmin, getSessions);
router.delete('/sessions/others', protectSuperAdmin, revokeOtherSessions);
router.delete('/sessions/:id', protectSuperAdmin, revokeSession);
router.get('/login-history', protectSuperAdmin, getLoginHistory);
router.get('/notifications', protectSuperAdmin, getNotifications);
router.put('/notifications/:id/read', protectSuperAdmin, markNotificationRead);
router.put('/notifications/read-all', protectSuperAdmin, markAllNotificationsRead);

module.exports = router;
