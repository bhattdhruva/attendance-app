import 'package:get/get.dart';

import '../../../auth/repositories/auth_repository.dart';
import '../../../core/services/api_service.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  var adminName = 'Super Admin'.obs;
  var isSearchOpen = false.obs;
  
  var metrics = {
    'organizations': '0',
    'employees': '0',
    'managers': '0',
    'branches': '0',
    'departments': '0',
    'subscriptions': '0',
  }.obs;

  var recentOrganizations = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;
  var filterStatus = 'All'.obs;
  var filterStartDate = Rxn<DateTime>();
  var filterEndDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    _fetchProfile();
    _fetchDashboardData();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _fetchDashboardData();
  }

  void applyFilter(String status, DateTime? start, DateTime? end) {
    filterStatus.value = status;
    filterStartDate.value = start;
    filterEndDate.value = end;
    _fetchDashboardData();
  }

  Future<void> _fetchProfile() async {
    try {
      final repository = AuthRepository();
      final response = await repository.getMe();
      if (response.statusCode == 200 && response.data['success']) {
        adminName.value = response.data['data']['fullName'] ?? 'Super Admin';
      }
    } catch (e) {
      // fallback
    }
  }

  Future<void> _fetchDashboardData() async {
    try {
      final apiService = ApiService();
      Map<String, dynamic> queryParams = {};
      if (searchQuery.value.isNotEmpty) queryParams['search'] = searchQuery.value;
      if (filterStatus.value != 'All') queryParams['status'] = filterStatus.value;
      if (filterStartDate.value != null) queryParams['startDate'] = filterStartDate.value!.toIso8601String();
      if (filterEndDate.value != null) queryParams['endDate'] = filterEndDate.value!.toIso8601String();

      final response = await apiService.client.get(
        '/dashboard/superadmin',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200 && response.data['success']) {
        final data = response.data['data'];
        metrics.value = Map<String, String>.from(data['metrics']);
        if (data['recentOrganizations'] != null) {
          recentOrganizations.value = List<Map<String, dynamic>>.from(data['recentOrganizations']);
        }
      }
    } catch (e) {
      print('Error fetching dashboard data: $e');
    }
  }
}
