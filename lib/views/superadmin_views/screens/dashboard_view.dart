import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/colors.dart';
import '../../../widgets/bottomnavbar.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentNavIndex = 0;
  String _selectedOrgFilter = 'All Organizations';
  String _selectedPeriod = 'Today';

  final List<String> _orgFilterOptions = const [
    // 'All Organizations',
    // 'Apex Logix Corp',
    // 'Novatech Global',
    'Vanguard Logistics',
    'BioHealth Labs',
    'CyberShield Systems',
  ];

  final List<CustomNavBarItem> _dashboardNavItems = const [
    CustomNavBarItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: 'Dashboard',
    ),
    CustomNavBarItem(
      icon: Icons.business_outlined,
      activeIcon: Icons.business_rounded,
      label: 'Orgs',
    ),
    CustomNavBarItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Reports',
    ),
    CustomNavBarItem(
      icon: Icons.more_horiz_rounded,
      activeIcon: Icons.more_horiz_rounded,
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Full-screen gradient — always fills every pixel
      backgroundColor: AppColors.superAdminDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.superAdminPrimary,
              AppColors.superAdminDark,
            ],
          ),
        ),
        child: Stack(
          children: [
            // ── Greeting content – always visible behind the sheet ────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildGreetingContent(context),
            ),

            // ── Draggable white sheet ─────────────────────────────
            DraggableScrollableSheet(
              initialChildSize: 0.62,
              minChildSize: 0.28,   // go low → full greeting visible
              maxChildSize: 0.97,
              snap: true,
              snapSizes: const [0.28, 0.62, 0.97],
              builder: (ctx, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 32,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // Drag handle
                        SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 16),
                              child: Container(
                                width: 44,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.textMuted.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Content
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _buildOrgFilterRow(),
                              const SizedBox(height: 12),
                              _buildPeriodTabs(),
                              const SizedBox(height: 16),
                              _buildRevenueCard(),
                              const SizedBox(height: 20),
                              _buildSectionHeader('PLATFORM OVERVIEW', actionText: 'View all →'),
                              const SizedBox(height: 10),
                              _buildPlatformOverviewCard(),
                              const SizedBox(height: 20),
                              _buildSubscriptionOverviewCard(),
                              const SizedBox(height: 20),
                              _buildAttentionRequiredCard(),
                              const SizedBox(height: 20),
                              _buildRecentOrganizationsCard(),
                              const SizedBox(height: 20),
                              _buildRecentPlatformActivityCard(),
                              const SizedBox(height: 20),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        items: _dashboardNavItems,
        activeColor: AppColors.superAdminPrimary,
      ),
      );
  }

  // MARK: - Greeting Content (rendered behind the draggable sheet)
  Widget _buildGreetingContent(BuildContext context) {

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: brand pill + notification + avatar
            Row(
              children: [
               Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       const Icon(
                        Icons.verified_user_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                        const SizedBox(width: 6),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.onlineBadge,
                          shape: BoxShape.circle,
                        ),
                      ),
                    
                     
                    ],
                  ),
                ),
                const Spacer(),
                // Notification
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        top: 7,
                        right: 7,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.notificationBadge,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Avatar
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.25),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'AM',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const SizedBox(height: 6),
            // Main greeting with icon and green online badge dot
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    'Good Afternoon,\nAlex ! 👋',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                ),
                
              ],
            ),
            const SizedBox(height: 20),

            // ── Quick Action: Add Organization ──────────────────────
            GestureDetector(
              onTap: () {
                // TODO: Navigate to Add Organization screen
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                 
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_business_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '+ Add Organization',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Quick',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - 1. Filter Functionality & Reset Row
  Widget _buildOrgFilterRow() {
    final displayText = _selectedOrgFilter == 'All Organizations'
        ? 'All Organizations (128)'
        : _selectedOrgFilter;

    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _showOrgFilterModal,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _selectedOrgFilter != 'All Organizations'
                        ? AppColors.superAdminPrimary.withValues(alpha: 0.4)
                        : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.business_center_outlined,
                        size: 16,
                        color: AppColors.superAdminPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        displayText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => setState(() => _selectedOrgFilter = 'All Organizations'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'Reset',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showOrgFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Organization Scope',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                ...List.generate(_orgFilterOptions.length, (index) {
                  final org = _orgFilterOptions[index];
                  final isSelected = _selectedOrgFilter == org;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    leading: Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? AppColors.superAdminPrimary : AppColors.textMuted,
                      size: 20,
                    ),
                    title: Text(
                      org,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.superAdminPrimary : AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      setState(() => _selectedOrgFilter = org);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // MARK: - Period Tabs
  Widget _buildPeriodTabs() {
    final periods = ['Today', 'This Week', 'This Month', 'Custom'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.superAdminPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.superAdminPrimary.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    period,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // MARK: - 2. Platform Overview — Four Individual Cards (2×2 grid)
  Widget _buildPlatformOverviewCard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPlatformCard(
                icon: Icons.apartment_rounded,
                iconColor: AppColors.superAdminPrimary,
                bgColor: const Color(0xFFEFF6FF),
                iconBg: const Color(0xFFDBEAFE),
                title: 'Total Organizations',
                count: '128',
                badge: '+6.7%',
                badgeColor: const Color(0xFF0284C7),
                badgeBg: const Color(0xFFE0F2FE),
                sub: '+8 this month',
                link: 'Org Directory →',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPlatformCard(
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFECFDF5),
                iconBg: const Color(0xFFD1FAE5),
                title: 'Active Organizations',
                count: '112',
                badge: '87.5%',
                badgeColor: const Color(0xFF059669),
                badgeBg: const Color(0xFFD1FAE5),
                sub: 'Healthy standing',
                link: null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPlatformCard(
                icon: Icons.hourglass_top_outlined,
                iconColor: const Color(0xFFF59E0B),
                bgColor: const Color(0xFFFFFBEB),
                iconBg: const Color(0xFFFDE68A),
                title: 'Trial Organizations',
                count: '10',
                badge: '3 ending',
                badgeColor: const Color(0xFFB45309),
                badgeBg: const Color(0xFFFEF3C7),
                sub: '3 ending soon',
                link: null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPlatformCard(
                icon: Icons.pause_circle_outline_rounded,
                iconColor: const Color(0xFF64748B),
                bgColor: const Color(0xFFF1F5F9),
                iconBg: const Color(0xFFE2E8F0),
                title: 'Inactive / Suspended',
                count: '6',
                badge: null,
                badgeColor: null,
                badgeBg: null,
                sub: 'Factual status',
                link: null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlatformCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color iconBg,
    required String title,
    required String count,
    String? badge,
    Color? badgeColor,
    Color? badgeBg,
    required String sub,
    String? link,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          if (link != null) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {},
              child: Text(
                link,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.superAdminPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // MARK: - 3. Subscription Overview (Core Pillar Card)
  Widget _buildSubscriptionOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Subscription Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                   
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: const [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.superAdminPrimary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.superAdminPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 4-grid stats
          Row(
            children: [
              Expanded(
                child: _buildSubGridItem(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF3B82F6),
                  bgColor: const Color(0xFFEFF6FF),
                  title: 'Active',
                  count: '92',
                  percent: '(80.7%)',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSubGridItem(
                  icon: Icons.hourglass_top_outlined,
                  iconColor: const Color(0xFF6366F1),
                  bgColor: const Color(0xFFEEF2FF),
                  title: 'Trial Mode',
                  count: '10',
                  percent: '(8.8%)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSubGridItem(
                  icon: Icons.notifications_active_outlined,
                  iconColor: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFFFBEB),
                  title: 'Expiring Soon',
                  count: '8',
                  percent: '(7.0%)',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSubGridItem(
                  icon: Icons.highlight_off_rounded,
                  iconColor: const Color(0xFF64748B),
                  bgColor: const Color(0xFFF1F5F9),
                  title: 'Expired',
                  count: '4',
                  percent: '(3.5%)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Segmented proportion bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 7,
              child: Row(
                children: const [
                  Expanded(flex: 81, child: ColoredBox(color: Color(0xFF0D9488))),
                  Expanded(flex: 9, child: ColoredBox(color: Color(0xFF6366F1))),
                  Expanded(flex: 7, child: ColoredBox(color: Color(0xFFF59E0B))),
                  Expanded(flex: 4, child: ColoredBox(color: Color(0xFFB45309))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        
        ],
      ),
    );
  }

  Widget _buildSubGridItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String count,
    required String percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      count,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      percent,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - 4. Platform Revenue & Distribution Chart
  Widget _buildRevenueCard() {
    String revenueTotal;
    String revenueChange;
    double baseRevenue;
    final List<Map<String, dynamic>> channels;

    switch (_selectedPeriod) {
      case 'Today':
        revenueTotal = '\$4,850';
        revenueChange = '+8.2% vs yesterday';
        baseRevenue = 4850;
        channels = [
          {'name': 'Online Sales (E-commerce)', 'shortName': 'Online Sales', 'percent': 35, 'color': AppColors.chartAmber, 'explode': 10.0},
          {'name': 'In-Store Retail', 'shortName': 'In-Store Retail', 'percent': 22, 'color': AppColors.chartPurple, 'explode': 8.0},
          {'name': 'Digital Advertising', 'shortName': 'Digital Adv.', 'percent': 16, 'color': AppColors.chartMint, 'explode': 0.0},
          {'name': 'Social Media Marketing', 'shortName': 'Social Media', 'percent': 10, 'color': AppColors.chartTeal, 'explode': 0.0},
          {'name': 'Print Media & Events', 'shortName': 'Print & Events', 'percent': 7, 'color': AppColors.chartSkyBlue, 'explode': 0.0},
          {'name': 'Email Campaigns', 'shortName': 'Email Campaigns', 'percent': 6, 'color': AppColors.chartOrange, 'explode': 0.0},
          {'name': 'Miscellaneous', 'shortName': 'Miscellaneous', 'percent': 4, 'color': AppColors.chartIndigo, 'explode': 12.0},
        ];
        break;
      case 'This Week':
        revenueTotal = '\$34,120';
        revenueChange = '+10.5% vs last wk';
        baseRevenue = 34120;
        channels = [
          {'name': 'Online Sales (E-commerce)', 'shortName': 'Online Sales', 'percent': 32, 'color': AppColors.chartAmber, 'explode': 10.0},
          {'name': 'In-Store Retail', 'shortName': 'In-Store Retail', 'percent': 24, 'color': AppColors.chartPurple, 'explode': 8.0},
          {'name': 'Digital Advertising', 'shortName': 'Digital Adv.', 'percent': 15, 'color': AppColors.chartMint, 'explode': 0.0},
          {'name': 'Social Media Marketing', 'shortName': 'Social Media', 'percent': 14, 'color': AppColors.chartTeal, 'explode': 0.0},
          {'name': 'Print Media & Events', 'shortName': 'Print & Events', 'percent': 8, 'color': AppColors.chartSkyBlue, 'explode': 0.0},
          {'name': 'Email Campaigns', 'shortName': 'Email Campaigns', 'percent': 4, 'color': AppColors.chartOrange, 'explode': 0.0},
          {'name': 'Miscellaneous', 'shortName': 'Miscellaneous', 'percent': 3, 'color': AppColors.chartIndigo, 'explode': 12.0},
        ];
        break;
      case 'Custom':
        revenueTotal = '\$92,400';
        revenueChange = '+11.1% custom range';
        baseRevenue = 92400;
        channels = [
          {'name': 'Online Sales (E-commerce)', 'shortName': 'Online Sales', 'percent': 28, 'color': AppColors.chartAmber, 'explode': 10.0},
          {'name': 'In-Store Retail', 'shortName': 'In-Store Retail', 'percent': 26, 'color': AppColors.chartPurple, 'explode': 8.0},
          {'name': 'Digital Advertising', 'shortName': 'Digital Adv.', 'percent': 18, 'color': AppColors.chartMint, 'explode': 0.0},
          {'name': 'Social Media Marketing', 'shortName': 'Social Media', 'percent': 11, 'color': AppColors.chartTeal, 'explode': 0.0},
          {'name': 'Print Media & Events', 'shortName': 'Print & Events', 'percent': 9, 'color': AppColors.chartSkyBlue, 'explode': 0.0},
          {'name': 'Email Campaigns', 'shortName': 'Email Campaigns', 'percent': 5, 'color': AppColors.chartOrange, 'explode': 0.0},
          {'name': 'Miscellaneous', 'shortName': 'Miscellaneous', 'percent': 3, 'color': AppColors.chartIndigo, 'explode': 12.0},
        ];
        break;
      case 'This Month':
      default:
        revenueTotal = '\$148,250';
        revenueChange = '+12.4% vs last mo';
        baseRevenue = 148250;
        channels = [
          {'name': 'Online Sales (E-commerce)', 'shortName': 'Online Sales', 'percent': 30, 'color': AppColors.chartAmber, 'explode': 10.0},
          {'name': 'In-Store Retail', 'shortName': 'In-Store Retail', 'percent': 25, 'color': AppColors.chartPurple, 'explode': 8.0},
          {'name': 'Digital Advertising', 'shortName': 'Digital Adv.', 'percent': 15, 'color': AppColors.chartMint, 'explode': 0.0},
          {'name': 'Social Media Marketing', 'shortName': 'Social Media', 'percent': 12, 'color': AppColors.chartTeal, 'explode': 0.0},
          {'name': 'Print Media & Events', 'shortName': 'Print & Events', 'percent': 8, 'color': AppColors.chartSkyBlue, 'explode': 0.0},
          {'name': 'Email Campaigns', 'shortName': 'Email Campaigns', 'percent': 5, 'color': AppColors.chartOrange, 'explode': 0.0},
          {'name': 'Miscellaneous', 'shortName': 'Miscellaneous', 'percent': 5, 'color': AppColors.chartIndigo, 'explode': 12.0},
        ];
        break;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Revenue Distribution by Sales Channel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.superAdminDeepPurple,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Platform Revenue Scope: $_selectedPeriod',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.badgeSuccessBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  revenueChange,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.badgeSuccessText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Total Revenue metric banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL PLATFORM REVENUE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        revenueTotal,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.superAdminNavy,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.superAdminPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.pie_chart_rounded, size: 13, color: AppColors.superAdminPrimary),
                      SizedBox(width: 4),
                      Text(
                        'Channel Breakdown',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.superAdminPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Pie Chart Render matching reference design
          SizedBox(
            height: 300,
            width: double.infinity,
            child: CustomPaint(
              painter: _RevenueDistributionPieChartPainter(channels: channels),
            ),
          ),
          const SizedBox(height: 16),

          // Detailed Channel Performance Breakdown
          const Text(
            'Channel Performance Breakdown',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: channels.map((ch) {
              final pct = ch['percent'] as int;
              final color = ch['color'] as Color;
              final name = ch['name'] as String;
              final amt = (baseRevenue * (pct / 100.0)).round();

              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
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
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '\$$amt',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$pct%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  // MARK: - Attention Required
  Widget _buildAttentionRequiredCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB45309),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Attention Required',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '3 Pending Ops',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB45309),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Factual platform maintenance and lifecycle notices',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),

        _buildAttentionItem(
          icon: Icons.credit_card_off_rounded,
          iconBg: const Color(0xFFFFF7ED),
          iconColor: const Color(0xFFEA580C),
          title: 'Subscriptions Expiring ...',
          subtitle: 'Expiring within the 7-day grace ...',
          buttonLabel: 'View',
          buttonColor: const Color(0xFF78350F),
        ),
        const SizedBox(height: 8),

        _buildAttentionItem(
          icon: Icons.timer_outlined,
          iconBg: const Color(0xFFF1F5F9),
          iconColor: const Color(0xFF64748B),
          title: 'Trial Ending Soon (3 or...',
          subtitle: 'Ending in 48 hours without pa...',
          buttonLabel: 'View',
          buttonColor: const Color(0xFFCBD5E1),
          buttonTextColor: const Color(0xFF334155),
        ),
        const SizedBox(height: 8),

        _buildAttentionItem(
          icon: Icons.receipt_long_rounded,
          iconBg: const Color(0xFFFFF1F2),
          iconColor: const Color(0xFFE11D48),
          title: 'Failed Invoice Webh...',
          subtitle: 'Stripe automated retry fail...',
          buttonLabel: 'Resolve',
          buttonColor: const Color(0xFF991B1B),
        ),
      ],
    );
  }

  Widget _buildAttentionItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required Color buttonColor,
    Color buttonTextColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: buttonTextColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(60, 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              buttonLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: buttonTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - Recent Organizations
  Widget _buildRecentOrganizationsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Recent Organizations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Recently activated tenant accounts',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: const [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.superAdminPrimary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppColors.superAdminPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _buildOrgRow(
            initials: 'AL',
            initialsBg: const Color(0xFFDBEAFE),
            initialsColor: const Color(0xFF1E40AF),
            name: 'Apex Logix Corp',
            tier: 'Enterprise Tier',
            status: 'Active',
            statusBg: const Color(0xFFBAE6FD),
            statusColor: const Color(0xFF0284C7),
            date: '24 Oct 2025',
          ),
          const Divider(height: 20, color: AppColors.borderLight),

          _buildOrgRow(
            initials: 'NG',
            initialsBg: const Color(0xFFE0E7FF),
            initialsColor: const Color(0xFF3730A3),
            name: 'Novatech Global',
            tier: 'HyperScale Tier',
            status: 'Active',
            statusBg: const Color(0xFFBAE6FD),
            statusColor: const Color(0xFF0284C7),
            date: '17 Oct 2025',
          ),
          const Divider(height: 20, color: AppColors.borderLight),

          _buildOrgRow(
            initials: 'VL',
            initialsBg: const Color(0xFFFFEDD5),
            initialsColor: const Color(0xFF9A3412),
            name: 'Vanguard Logistics',
            tier: 'Enterprise Pro',
            status: 'Trial (2d)',
            statusBg: const Color(0xFFFED7AA),
            statusColor: const Color(0xFFC2410C),
            date: '10 Oct 2025',
          ),
        ],
      ),
    );
  }

  Widget _buildOrgRow({
    required String initials,
    required Color initialsBg,
    required Color initialsColor,
    required String name,
    required String tier,
    required String status,
    required Color statusBg,
    required Color statusColor,
    required String date,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: initialsBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: initialsColor,
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
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tier,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          date,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // MARK: - Recent Platform Activity
  Widget _buildRecentPlatformActivityCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Recent Platform Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Immutable system & cluster ledger',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: const [
                    Text(
                      'Audit Logs',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.superAdminPrimary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppColors.superAdminPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildTimelineItem(
            title: 'Organization Provisioned',
            detail: 'Vanguard Logistics (ORD-0280) provisioned by Elena Rostova',
            time: '2h ago',
            isLast: false,
          ),
          _buildTimelineItem(
            title: 'Subscription Renewed',
            detail: 'BioHealth Labs renewed Enterprise Pro license (\$4,200/yr)',
            time: '5h ago',
            isLast: false,
          ),
          _buildTimelineItem(
            title: 'Annual Enterprise Expansion',
            detail: 'Novatech Global upgraded +500 seats (\$14,290 ARR)',
            time: '7h ago',
            isLast: false,
          ),
          _buildTimelineItem(
            title: 'Security Token Bound',
            detail: 'Alex Mercer enrolled hardware FIDO2 key to root session',
            time: '1d ago',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String detail,
    required String time,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3A8A),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: AppColors.borderLight,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  


  Widget _buildSectionHeader(String title, {String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: 0.8,
          ),
        ),
        if (actionText != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.superAdminPrimary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Custom painter to replicate the exact Pie Chart with exploded slices,
/// embedded percentages, leader lines, node dots, and labels.
class _RevenueDistributionPieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> channels;

  _RevenueDistributionPieChartPainter({required this.channels});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width * 0.30, size.height * 0.30);

    double startAngle = -math.pi * 0.65;

    for (var ch in channels) {
      final percent = (ch['percent'] as int).toDouble();
      final sweepAngle = 2 * math.pi * (percent / 100.0);
      final explodeDist = (ch['explode'] as double? ?? 0.0);
      final color = ch['color'] as Color;
      final name = ch['shortName'] as String;

      final midAngle = startAngle + sweepAngle / 2;

      final sliceCenter = Offset(
        center.dx + explodeDist * math.cos(midAngle),
        center.dy + explodeDist * math.sin(midAngle),
      );

      final slicePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final rect = Rect.fromCircle(center: sliceCenter, radius: radius);
      canvas.drawArc(rect, startAngle, sweepAngle, true, slicePaint);

      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawArc(rect, startAngle, sweepAngle, true, borderPaint);

      // Percentage text inside slice
      final textRadius = radius * 0.58;
      final textX = sliceCenter.dx + textRadius * math.cos(midAngle);
      final textY = sliceCenter.dy + textRadius * math.sin(midAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${percent.toInt()}%',
          style: TextStyle(
            color: Colors.white,
            fontSize: percent >= 15 ? 15 : (percent >= 10 ? 12 : 10),
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
      );

      // Callout Leader Line & Node Dot
      final p1 = Offset(
        sliceCenter.dx + radius * 0.82 * math.cos(midAngle),
        sliceCenter.dy + radius * 0.82 * math.sin(midAngle),
      );

      final p2 = Offset(
        sliceCenter.dx + (radius + 18) * math.cos(midAngle),
        sliceCenter.dy + (radius + 18) * math.sin(midAngle),
      );

      final isRightSide = math.cos(midAngle) >= 0;
      final p3 = Offset(
        p2.dx + (isRightSide ? 20.0 : -20.0),
        p2.dy,
      );

      final dotOnSlice = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(p1, 3.0, dotOnSlice);

      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final linePath = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy);
      canvas.drawPath(linePath, linePaint);

      final nodeDot = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(p3, 3.5, nodeDot);

      final labelPainter = TextPainter(
        text: TextSpan(
          text: name,
          style: const TextStyle(
            color: Color(0xFF334155),
            fontSize: 9.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();

      final labelX = isRightSide ? p3.dx + 4 : p3.dx - labelPainter.width - 4;
      final labelY = p3.dy - labelPainter.height / 2;
      labelPainter.paint(canvas, Offset(labelX, labelY));

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

