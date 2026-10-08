import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/colors.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/bottomnavbar.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentNavIndex = 0;

  final List<CustomNavBarItem> _dashboardNavItems = const [
    CustomNavBarItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: 'Dashboard',
    ),
    CustomNavBarItem(
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      label: 'Organizations',
    ),
    CustomNavBarItem(
      icon: Icons.credit_card_outlined,
      activeIcon: Icons.credit_card_rounded,
      label: 'Plans',
    ),
    CustomNavBarItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Analytics',
    ),
    CustomNavBarItem(
      icon: Icons.tune_rounded,
      activeIcon: Icons.tune_rounded,
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        title: '',
        leading: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.business,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'HRMS',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'SUPER ADMIN',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: Color(0xFF2563EB),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            )
          ],
        ),
        showNotificationBadge: true,
        notificationCount: 1,
        avatarInitials: 'SA',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            const SizedBox(height: 24),
            _buildGridCards(),
            const SizedBox(height: 24),
           
        
            _buildSubscriptionAndRevenue(),
            const SizedBox(height: 24),
            _buildRecentOrganizations(),
            const SizedBox(height: 24),
            _buildAlerts(),
            const SizedBox(height: 24),
            _buildRecentActivity(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        items: _dashboardNavItems,
        activeColor: const Color(0xFF2563EB),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning,',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Super Admin',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2563EB),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Here's what's happening with your platform today.",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGridCards() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      children: [
        _buildStatCard('Organizations', '125', '+5 this week', true),
        _buildStatCard('Employees', '18,450', '+120 this week', true),
        _buildStatCard('Managers', '1,240', '+15 this week', true),
        _buildStatCard('Branches', '380', '+2 this week', true),
        _buildStatCard('Departments', '920', '+10 this week', true),
        _buildStatCard('Subscriptions', '110', '+3 this week', true),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String change, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? const Color(0xFF10B981) : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 11,
                    color: isPositive ? const Color(0xFF10B981) : Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContainerCard({required String title, required Widget child, Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildPlatformAttendance() {
    return _buildContainerCard(
      title: 'Platform Attendance',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '94.2%',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2563EB),
              letterSpacing: -1,
            ),
          ),
          const Text(
            'Attendance Rate',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat('Present', '17,381', const Color(0xFF10B981)),
              _buildMiniStat('Absent', '512', Colors.red),
              _buildMiniStat('Leave', '557', Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          _buildChartPlaceholder('[ Attendance Trend Chart ]'),
        ],
      ),
    );
  }

  Widget _buildLeaveOverview() {
    return _buildContainerCard(
      title: 'Leave Overview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat('Total', '6,240', const Color(0xFF2563EB)),
              _buildMiniStat('Pending', '1,240', Colors.orange),
              _buildMiniStat('Approved', '5,000', const Color(0xFF10B981)),
            ],
          ),
          const SizedBox(height: 16),
          _buildChartPlaceholder('[ Leave Trend Chart ]'),
        ],
      ),
    );
  }

  Widget _buildOrganizationGrowth() {
    return _buildContainerCard(
      title: 'Organization Growth',
      child: _buildChartPlaceholder('[ Growth Chart ]'),
    );
  }

  Widget _buildChartPlaceholder(String text) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionAndRevenue() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subscription & Revenue',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(120, 120),
                      painter: DonutChartPainter(),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '110',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'PLANS',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem('Active Plans', '93', const Color(0xFF3B82F6)),
                    const SizedBox(height: 12),
                    _buildLegendItem('MRR', '₹3.4L', const Color(0xFF10B981)),
                    const SizedBox(height: 12),
                    _buildLegendItem('Pending', '12', const Color(0xFFF59E0B)),
                    const SizedBox(height: 12),
                    _buildLegendItem('Expiring', '5', const Color(0xFFEF4444)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF475569),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOrganizations() {
    return _buildContainerCard(
      title: 'Recent Organizations',
      trailing: GestureDetector(
        onTap: () {},
        child: const Text(
          'View All',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2563EB),
          ),
        ),
      ),
      child: Column(
        children: [
          _buildOrgListItem('AT', 'ABC Technologies', 'Enterprise', 'Active', const Color(0xFF2563EB), const Color(0xFFEFF6FF), const Color(0xFF10B981), const Color(0xFFD1FAE5)),
          const SizedBox(height: 12),
          _buildOrgListItem('XS', 'XYZ Solutions', 'Pro', 'Active', const Color(0xFF2563EB), const Color(0xFFEFF6FF), const Color(0xFF10B981), const Color(0xFFD1FAE5)),
        ],
      ),
    );
  }

  Widget _buildOrgListItem(String initials, String name, String subtitle, String status, Color iconColor, Color iconBg, Color statusColor, Color statusBg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: iconColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlerts() {
    return _buildContainerCard(
      title: 'Alerts',
      trailing: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
      child: Column(
        children: [
          _buildListTileItem(Icons.error_outline, '12 subscriptions expiring', Colors.orange),
          const SizedBox(height: 12),
          _buildListTileItem(Icons.payment, '5 payment failures', Colors.red),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return _buildContainerCard(
      title: 'Recent Platform Activity',
      child: Column(
        children: [
          _buildListTileItem(Icons.add_business_outlined, 'Organization created (ABC Tech)', const Color(0xFF2563EB)),
          const SizedBox(height: 12),
          _buildListTileItem(Icons.upgrade, 'Plan upgraded (XYZ Solutions)', const Color(0xFF10B981)),
          const SizedBox(height: 12),
          _buildListTileItem(Icons.autorenew, 'Subscription renewed (Acme Corp)', const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildListTileItem(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 16.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -math.pi / 2;
    const gap = 0.15; // small gap between segments

    void drawSegment(Color color, double fraction) {
      paint.color = color;
      final sweepAngle = (math.pi * 2 * fraction) - gap;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle > 0 ? sweepAngle : 0.01,
        false,
        paint,
      );
      startAngle += (math.pi * 2 * fraction);
    }

    final total = 111.0;
    
    // Active Plans
    drawSegment(const Color(0xFF3B82F6), 93 / total);
    // MRR placeholder
    drawSegment(const Color(0xFF10B981), 1 / total); 
    // Pending
    drawSegment(const Color(0xFFF59E0B), 12 / total);
    // Expiring
    drawSegment(const Color(0xFFEF4444), 5 / total);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
