import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../app/colors.dart';
import '../../../widgets/cards.dart';
import '../../../widgets/listtile.dart';
import '../../../widgets/animated_pulse.dart';
import '../../../widgets/searchbar.dart';

class HomeTab extends StatelessWidget {
  final DashboardController controller;
  final RxString _chartTimeframe = 'Today'.obs;
  final RxBool _isChartExpanded = true.obs;

  HomeTab({Key? key, required this.controller}) : super(key: key);

  Map<String, dynamic> _getData(String timeframe) {
    switch (timeframe) {
      case 'Today':
        return {
          'active': '15', 'pending': '5', 'expiring': '2',
          'revenueTitle': 'Today\'s Revenue', 'revenueValue': '\$1.2k',
          'chartBars': [0.1, 0.2, 0.1, 0.4, 0.3, 0.1, 0.2],
          'xLabels': ['8am', '10a', '12p', '2pm', '4pm', '6pm', '8pm']
        };
      case 'Week':
        return {
          'active': '110', 'pending': '24', 'expiring': '12',
          'revenueTitle': 'Weekly Revenue', 'revenueValue': '\$10.5k',
          'chartBars': [0.4, 0.6, 0.8, 0.5, 0.9, 0.3, 0.2],
          'xLabels': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        };
      case 'Month':
        return {
          'active': '420', 'pending': '85', 'expiring': '45',
          'revenueTitle': 'Monthly Revenue', 'revenueValue': '\$42.5k',
          'chartBars': [0.6, 0.8, 0.5, 0.7, 0.9, 0.8, 0.9],
          'xLabels': ['Wk1', 'Wk2', 'Wk3', 'Wk4', 'Wk5', 'Wk6', 'Wk7']
        };
      case 'Year':
        return {
          'active': '1250', 'pending': '210', 'expiring': '180',
          'revenueTitle': 'Yearly Revenue', 'revenueValue': '\$510.2k',
          'chartBars': [0.3, 0.5, 0.4, 0.6, 0.7, 0.9, 1.0],
          'xLabels': ['Jan', 'Mar', 'May', 'Jul', 'Sep', 'Nov', 'Dec']
        };
      case 'Custom':
        return {
          'active': '340', 'pending': '50', 'expiring': '10',
          'revenueTitle': 'Custom Range Revenue', 'revenueValue': '\$38.4k',
          'chartBars': [0.5, 0.4, 0.7, 0.6, 0.9, 0.5, 0.8],
          'xLabels': ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7']
        };
      default:
        return _getData('Today');
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    DateTimeRange? selectedRange = (controller.filterStartDate.value != null && controller.filterEndDate.value != null) 
      ? DateTimeRange(start: controller.filterStartDate.value!, end: controller.filterEndDate.value!) 
      : null;
    String selectedStatus = controller.filterStatus.value;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.inkDark)),
                const SizedBox(height: 24),
                
                // 1. Organization Dropdown
                const Text('Organization', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.neutralGrey)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0x338385A1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('All Organizations', style: TextStyle(color: AppColors.inkDark, fontWeight: FontWeight.w500)),
                      Icon(Icons.keyboard_arrow_down, color: AppColors.neutralGrey),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 2. Custom Date Range (From and To)
                const Text('Custom Date Range', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.neutralGrey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // FROM DATE
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedRange?.start ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedRange = DateTimeRange(
                                start: picked,
                                end: selectedRange?.end ?? picked,
                              );
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0x338385A1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedRange == null ? 'From' : '${selectedRange!.start.day}/${selectedRange!.start.month}/${selectedRange!.start.year}',
                                style: TextStyle(
                                  color: selectedRange == null ? AppColors.neutralGrey : AppColors.inkDark,
                                  fontSize: 13,
                                ),
                              ),
                              const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryViolet),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // TO DATE
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedRange?.end ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedRange = DateTimeRange(
                                start: selectedRange?.start ?? picked,
                                end: picked,
                              );
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0x338385A1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedRange == null ? 'To' : '${selectedRange!.end.day}/${selectedRange!.end.month}/${selectedRange!.end.year}',
                                style: TextStyle(
                                  color: selectedRange == null ? AppColors.neutralGrey : AppColors.inkDark,
                                  fontSize: 13,
                                ),
                              ),
                              const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryViolet),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Text('Status', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.neutralGrey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildFilterChip('All', selectedStatus, (s) => setState(() => selectedStatus = s))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFilterChip('Active', selectedStatus, (s) => setState(() => selectedStatus = s))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFilterChip('Inactive', selectedStatus, (s) => setState(() => selectedStatus = s))),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.inkDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (selectedRange != null) {
                        _chartTimeframe.value = 'Custom';
                      }
                      controller.applyFilter(selectedStatus, selectedRange?.start, selectedRange?.end);
                      Get.back();
                    },
                    child: const Text('Apply Filters', style: TextStyle(color: AppColors.surfaceCard, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        }
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterChip(String label, String currentStatus, Function(String) onTap) {
    bool isSelected = label == currentStatus;
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.inkDark : AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.surfaceCard : AppColors.inkDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Curved Background using morning palette
              ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryViolet, AppColors.primaryViolet], // Morning Palette Gradient
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Profile Area
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white24,
                                    child: Icon(Icons.person, color: Colors.white, size: 30),
                                  ),
                                  const SizedBox(width: 12),
                                  Obx(() => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.adminName.value,
                                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        'Super Admin • HQ',
                                        style: TextStyle(fontSize: 12, color: Colors.white70),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.offAllNamed('/login');
                                    },
                                    icon: const Icon(Icons.power_settings_new_rounded, color: Colors.white),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              ],
                            ),
                          ],
                        ),
                    ),
                  ),
                ),
              ),
              
              // Floating White Card
              Positioned(
                top: 160,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header of floating card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: const BoxDecoration(
                          color: AppColors.inkDark, // Morning Palette Dark Header
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.layers, color: Colors.white70, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Subscription Overview',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      // Stats in floating card
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Obx(() {
                          final data = _getData(_chartTimeframe.value);
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildFloatingStat('Active', controller.metrics['subscriptions'] ?? '0', 'Plans', AppColors.accentTealDark),
                                  _buildVerticalDivider(),
                                  _buildFloatingStat('Pending', '0', 'Plans', AppColors.accentBlueDark),
                                  _buildVerticalDivider(),
                                  _buildFloatingStat('Expiring', '0', 'Plans', AppColors.accentRedDark),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Rounded MRR box inside floating card
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryViolet, // Morning Palette accent
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data['revenueTitle'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                        const SizedBox(height: 4),
                                        Text(data['revenueValue'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Spacer to push content below the floating card
          const SizedBox(height: 140),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomSearchBar(
              isOpen: true,
              onChanged: controller.onSearchChanged,
              onFilterTap: () => _showFilterBottomSheet(context),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quick Action Icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomActionCard(
                        title: 'Settings',
                        subtitle: 'App preferences',
                        icon: Icons.settings,
                        color: AppColors.accentBlueDark,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomActionCard(
                        title: 'Users',
                        subtitle: 'Active users',
                        icon: Icons.people_alt,
                        color: AppColors.accentTealDark,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomActionCard(
                        title: 'Reports',
                        subtitle: 'View reports',
                        icon: Icons.bar_chart,
                        color: AppColors.accentAmberDark,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomActionCard(
                        title: 'Logs',
                        subtitle: 'Audit logs',
                        icon: Icons.history,
                        color: AppColors.accentRedDark,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Remaining Dashboard Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAnalyticsChart(context),
                const SizedBox(height: 24),
                _buildOrganizationStats(),
                const SizedBox(height: 24),
                _buildRecentOrganizations(),
                const SizedBox(height: 24),
                _buildAttentionRequired(),
                const SizedBox(height: 24),
                _buildRecentPlatformActivity(),
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1.5, height: 40, color: const Color(0x338385A1));
  }

  Widget _buildFloatingStat(String title, String value, String unit, [Color valueColor = AppColors.inkDark]) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: AppColors.neutralGrey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: valueColor)),
            const SizedBox(width: 2),
            Text(unit, style: const TextStyle(fontSize: 10, color: AppColors.neutralGrey)),
          ],
        )
      ],
    );
  }



  Widget _buildAnalyticsChart(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _isChartExpanded.toggle(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Revenue Analytics', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.inkDark)),
                      const SizedBox(width: 4),
                      Obx(() => Icon(
                        _isChartExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: AppColors.inkDark,
                        size: 18,
                      )),
                    ],
                  ),
                ),
              ),
              Obx(() => PopupMenuButton<String>(
                onSelected: (String newValue) {
                  _chartTimeframe.value = newValue;
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                offset: const Offset(0, 30),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'Today', child: Text('Today')),
                  const PopupMenuItem<String>(value: 'Week', child: Text('Week')),
                  const PopupMenuItem<String>(value: 'Month', child: Text('Month')),
                  const PopupMenuItem<String>(value: 'Year', child: Text('Year')),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_chartTimeframe.value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkDark)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.inkDark),
                    ],
                  ),
                ),
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Obx(() {
              final data = _getData(_chartTimeframe.value);
              final bars = data['chartBars'] as List<double>;
              final labels = data['xLabels'] as List<String>;
              
              final sliceValues = bars.take(5).toList();
              final sliceLabels = labels.take(5).toList();
              
              final total = sliceValues.fold<double>(0, (sum, item) => sum + item);
              final displayTexts = sliceValues.map((v) => '${((v / total) * 100).toStringAsFixed(1)}%').toList();

              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: 320,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _PieChartPainter(
                        values: sliceValues,
                        displayTexts: displayTexts,
                        colors: const [
                          AppColors.accentBlueDark,
                          AppColors.accentRedLight,
                          AppColors.primaryIndigo,
                          AppColors.accentAmberDark,
                          AppColors.primaryViolet,
                        ],
                      ),
                    ),
                  ),
                  if (_isChartExpanded.value)
                    Positioned(
                      top: 0,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard.withValues(alpha: 0.95), // Slight transparency for floating effect
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0x338385A1)),
                          boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4))],
                        ),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildLegendItem(sliceLabels[0].toUpperCase(), AppColors.accentBlueDark),
                            _buildLegendItem(sliceLabels[1].toUpperCase(), AppColors.accentRedLight),
                            _buildLegendItem(sliceLabels[2].toUpperCase(), AppColors.primaryIndigo),
                            _buildLegendItem(sliceLabels[3].toUpperCase(), AppColors.accentAmberDark),
                            _buildLegendItem(sliceLabels[4].toUpperCase(), AppColors.primaryViolet),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.inkDark, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildOrganizationStats() {
    return AnimatedPulseBorder(
      shadowColor: AppColors.primaryViolet,
      borderRadius: 24.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x338385A1)),
        ),
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: const Text('Organizations Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.inkDark)),
          subtitle: const Text('Click down to show more', style: TextStyle(fontSize: 12, color: AppColors.neutralGrey)),
          iconColor: AppColors.primaryViolet,
          collapsedIconColor: AppColors.neutralGrey,
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Obx(() => Column(
              children: [
                Row(
                  children: [
                    _buildOrgStatCard('Organizations', controller.metrics['organizations'] ?? '0', AppColors.inkDark, Icons.business),
                    const SizedBox(width: 16),
                    _buildOrgStatCard('Employees', controller.metrics['employees'] ?? '0', AppColors.accentTealDark, Icons.people_outline),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildOrgStatCard('Managers', controller.metrics['managers'] ?? '0', AppColors.accentBlueDark, Icons.manage_accounts),
                    const SizedBox(width: 16),
                    _buildOrgStatCard('Departments', controller.metrics['departments'] ?? '0', AppColors.accentRedDark, Icons.corporate_fare),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
      ),
      ),
    );
  }

  Widget _buildOrgStatCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x338385A1)),
          boxShadow: [BoxShadow(color: const Color(0x0F000000), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.neutralGrey, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrganizations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Organizations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.inkDark)),
              const Text('See All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryViolet)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => controller.recentOrganizations.isEmpty 
          ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No organizations found."))) 
          : OrganizationSwiperWidget(orgs: controller.recentOrganizations)),
      ],
    );
  }

  Widget _buildAttentionRequired() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppColors.accentRedDark),
            SizedBox(width: 8),
            Text('Attention Required', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accentRedDark)),
          ],
        ),
        const SizedBox(height: 16),
        CustomListTile(
          title: 'Global Logistics',
          subtitle: 'Subscription expiring in 3 days',
          icon: Icons.timer,
          color: AppColors.accentRedDark,
          onTap: () {},
        ),
        CustomListTile(
          title: 'Nexus LLC',
          subtitle: 'Payment failed for Pro Plan',
          icon: Icons.credit_card_off,
          color: AppColors.accentRedDark,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildRecentPlatformActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Platform Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.inkDark)),
        const SizedBox(height: 16),
        CustomListTile(
          title: 'System Update',
          subtitle: 'Version 2.4.1 deployed successfully',
          icon: Icons.system_update_alt,
          color: AppColors.accentBlueDark,
          onTap: () {},
        ),
        CustomListTile(
          title: 'Admin Login',
          subtitle: 'New login from unknown IP',
          icon: Icons.security,
          color: AppColors.accentAmberDark,
          onTap: () {},
        ),
      ],
    );
  }


}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    
    var secondControlPoint = Offset(size.width - (size.width / 4), size.height - 40);
    var secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class OrganizationSwiperWidget extends StatefulWidget {
  final List<Map<String, dynamic>> orgs;
  const OrganizationSwiperWidget({Key? key, required this.orgs}) : super(key: key);

  @override
  _OrganizationSwiperWidgetState createState() => _OrganizationSwiperWidgetState();
}

class _OrganizationSwiperWidgetState extends State<OrganizationSwiperWidget> {
  late PageController _pageController;
  int _currentPage = 1000; // Start at a large number for infinite loop effect
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.95);
    
    // Auto-scroll loop
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final _orgs = widget.orgs;
          if (_orgs.isEmpty) return const SizedBox.shrink();
          final org = _orgs[index % _orgs.length];
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = value.clamp(-2.0, 2.0);
              }
              
              // Stack effect math
              double scale = 1.0;
              double opacity = 1.0;
              double translationX = 0;
              
              if (value > 0) {
                // Cards on the right (stacked behind)
                scale = (1.0 - (value * 0.15)).clamp(0.8, 1.0);
                translationX = -value * 60; // Pull left to stack under
                opacity = (1.0 - (value * 0.2)).clamp(0.0, 1.0);
              } else if (value < 0) {
                // Cards on the left sliding out
                scale = (1.0 + (value * 0.1)).clamp(0.9, 1.0);
                opacity = (1.0 + value).clamp(0.0, 1.0);
                translationX = value * 20;
              }

              return Transform(
                transform: Matrix4.identity()
                  ..translate(translationX, 0.0)
                  ..scale(scale),
                alignment: Alignment.center,
                child: Opacity(
                  opacity: opacity,
                  child: child,
                ),
              );
            },
            child: _buildSwiperCard(org),
          );
        },
      ),
    );
  }

  Widget _buildSwiperCard(Map<String, dynamic> org) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(org['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Abstract graphic overlay removed for clarity of the real image
            // Top Right Icon
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.ios_share, color: Colors.black87, size: 18),
              ),
            ),
            
            // Bottom White Section
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          org['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Created: ${org['date']}',
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: org['status'] == 'Online' ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              org['status'],
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.person_add, color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text('Manage', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
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
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> displayTexts;
  final List<Color> colors;

  _PieChartPainter({required this.values, required this.displayTexts, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    double total = values.fold(0, (sum, item) => sum + item);
    double startAngle = 0.0;
    
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2 - 10), 
      width: size.width, 
      height: size.height * 0.7,
    );

    // Draw bottom 3D layers
    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;
      final paint = Paint()
        ..color = _darken(colors[i], 0.2)
        ..style = PaintingStyle.fill;
      
      // Draw thickness (40 layers for deeper 3D effect)
      for (double y = 0; y < 40; y += 1) {
        canvas.drawArc(
          rect.translate(0, y), 
          startAngle, 
          sweepAngle, 
          true, 
          paint,
        );
      }
      startAngle += sweepAngle;
    }

    startAngle = 0.0;
    
    // Draw top pie layer
    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
        
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      
      // Calculate text position
      final textAngle = startAngle + (sweepAngle / 2);
      final radiusX = rect.width / 2.5;
      final radiusY = rect.height / 2.5;
      final dx = rect.center.dx + radiusX * math.cos(textAngle);
      final dy = rect.center.dy + radiusY * math.sin(textAngle);
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: displayTexts[i],
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(dx - textPainter.width / 2, dy - textPainter.height / 2));
      
      startAngle += sweepAngle;
    }
  }

  Color _darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
