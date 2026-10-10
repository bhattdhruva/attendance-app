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

    const activePlans = subscriptions;
    const expiringPlans = await Subscription.countDocuments({ 
       status: 'ACTIVE', 
       endDate: { $lt: new Date(Date.now() + 7*24*60*60*1000) } 
    });

    const revenueAnalytics = {
      Today: {
        active: activePlans.toString(), pending: '0', expiring: expiringPlans.toString(),
        revenueTitle: 'Today\'s Revenue', revenueValue: `$${activePlans * 10}`,
        chartBars: [0.1, 0.2, 0.1, 0.4, 0.3, 0.1, 0.2],
        xLabels: ['8am', '10a', '12p', '2pm', '4pm', '6pm', '8pm']
      },
      Week: {
        active: activePlans.toString(), pending: '0', expiring: expiringPlans.toString(),
        revenueTitle: 'Weekly Revenue', revenueValue: `$${activePlans * 70}`,
        chartBars: [0.4, 0.6, 0.8, 0.5, 0.9, 0.3, 0.2],
        xLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
      },
      Month: {
        active: activePlans.toString(), pending: '0', expiring: expiringPlans.toString(),
        revenueTitle: 'Monthly Revenue', revenueValue: `$${activePlans * 300}`,
        chartBars: [0.6, 0.8, 0.5, 0.7, 0.9, 0.8, 0.9],
        xLabels: ['Wk1', 'Wk2', 'Wk3', 'Wk4', 'Wk5', 'Wk6', 'Wk7']
      },
      Year: {
        active: activePlans.toString(), pending: '0', expiring: expiringPlans.toString(),
        revenueTitle: 'Yearly Revenue', revenueValue: `$${activePlans * 3600}`,
        chartBars: [0.3, 0.5, 0.4, 0.6, 0.7, 0.9, 1.0],
        xLabels: ['Jan', 'Mar', 'May', 'Jul', 'Sep', 'Nov', 'Dec']
      },
      Custom: {
        active: activePlans.toString(), pending: '0', expiring: expiringPlans.toString(),
        revenueTitle: 'Custom Range Revenue', revenueValue: `$${activePlans * 150}`,
        chartBars: [0.5, 0.4, 0.7, 0.6, 0.9, 0.5, 0.8],
        xLabels: ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7']
      }
    };

    const expiringSubscriptions = await Subscription.find({
      status: 'ACTIVE',
      endDate: { $lt: new Date(Date.now() + 7*24*60*60*1000) }
    }).populate('organization', 'name').limit(5);

    const attentionRequired = expiringSubscriptions.map(sub => ({
      title: sub.organization ? sub.organization.name : 'Unknown Organization',
      subtitle: `Subscription expiring on ${sub.endDate ? sub.endDate.toISOString().split('T')[0] : 'soon'}`,
      iconType: 'timer'
    }));

    if (attentionRequired.length === 0) {
      attentionRequired.push({
        title: 'Nexus LLC',
        subtitle: 'Payment failed for Pro Plan',
        iconType: 'credit_card_off'
      });
    }

    const recentActivity = recentOrgsData.slice(0, 5).map(org => ({
      title: 'New Organization',
      subtitle: `${org.name} completed registration`,
      iconType: 'business'
    }));

    if (recentActivity.length === 0) {
      recentActivity.push({
        title: 'System Update',
        subtitle: 'Version 2.4.1 deployed successfully',
        iconType: 'system_update_alt'
      });
    }

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
        revenueAnalytics,
        recentOrganizations: recentOrgs,
        attentionRequired,
        recentActivity
      }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
};
