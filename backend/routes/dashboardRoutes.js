const express = require('express');
const { getSuperAdminDashboard } = require('../controllers/dashboardController');
const { protectSuperAdmin } = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/superadmin', protectSuperAdmin, getSuperAdminDashboard);

module.exports = router;
