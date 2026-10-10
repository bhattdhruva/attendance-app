const Organization = require('../models/Organization');
const User = require('../models/User');
const Branch = require('../models/Branch');
const Department = require('../models/Department');
const Subscription = require('../models/Subscription');
const Attendance = require('../models/Attendance');

exports.getSuperAdminDashboard = async (req, res, next) => {
  try {
    const { search, status, startDate, endDate } = req.query;
    
    let orgQuery = {};
    if (search) {
      orgQuery.name = { $regex: search, $options: 'i' };
    }
    if (status && status !== 'All') {
      orgQuery.status = status.toUpperCase();
    }
    if (startDate && endDate) {
      orgQuery.createdAt = { $gte: new Date(startDate), $lte: new Date(endDate) };
    }

    const organizations = await Organization.countDocuments(orgQuery);
    const employees = await User.countDocuments({ role: 'employee' });
    const managers = await User.countDocuments({ role: 'manager' });
    const branches = await Branch.countDocuments();
    const departments = await Department.countDocuments();
    const subscriptions = await Subscription.countDocuments({ status: 'ACTIVE' });

    const recentOrgsData = await Organization.find(orgQuery).sort({ createdAt: -1 }).limit(10);
    const recentOrgs = recentOrgsData.map(org => ({
      name: org.name,
      status: org.status === 'ACTIVE' ? 'Online' : 'Offline',
      date: org.createdAt.toISOString().split('T')[0],
      image: 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=600&h=400'
    }));

    res.status(200).json({
      success: true,
      data: {
        metrics: {
          organizations: organizations.toString(),
          employees: employees.toString(),
          managers: managers.toString(),
          branches: branches.toString(),
          departments: departments.toString(),
          subscriptions: subscriptions.toString(),
        },
        recentOrganizations: recentOrgs
      }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};
