import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/colors.dart';
import '../repository/profile_repository.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var fullName = 'Bessie Cooper'.obs;
  var email = 'cooper33@hotmail.com'.obs;
  var username = '@cooper_bessie'.obs;
  var phoneNumber = '+1 234 567 8900'.obs;
  var createdAt = '12 October 2024'.obs;
  var avatarUrl = 'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg'.obs;
  
  var activeCount = 14.obs;
  var pendingCount = 6.obs;
  var completeCount = 25.obs;

  var notificationsMute = false.obs;
  var notificationsPush = true.obs;
  var notificationsEmail = true.obs;

  var securitySettings = true.obs;
  var privacySettings = true.obs;
  
  var themeMode = 'System'.obs;

  final ProfileRepository _repository = ProfileRepository();

  void setThemeMode(String mode) {
    themeMode.value = mode;
    // Assuming you have GetX theme management set up
    // if (mode == 'System') Get.changeThemeMode(ThemeMode.system);
    // else if (mode == 'Light') Get.changeThemeMode(ThemeMode.light);
    // else if (mode == 'Dark') Get.changeThemeMode(ThemeMode.dark);
  }

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
    fetchProfile();
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('superadmin_profile');
    if (cachedData != null) {
      _parseProfileData(json.decode(cachedData));
    }
  }

  Future<void> _saveToCache(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('superadmin_profile', json.encode(data));
  }

  void _parseProfileData(Map<String, dynamic> data) {
    if (data['profile'] != null) {
      final profile = data['profile'];
      fullName.value = profile['fullName'] ?? fullName.value;
      email.value = profile['email'] ?? email.value;
      username.value = profile['username'] ?? username.value;
      phoneNumber.value = profile['phoneNumber'] ?? phoneNumber.value;
      
      if (profile['createdAt'] != null) {
        DateTime dt = DateTime.parse(profile['createdAt']);
        createdAt.value = '${dt.day}-${dt.month}-${dt.year}';
      }

      if (profile['avatarUrl'] != null && profile['avatarUrl'].toString().isNotEmpty) {
        avatarUrl.value = profile['avatarUrl'];
      }
      
      if (profile['preferences'] != null) {
        if (profile['preferences']['notifications'] != null) {
          notificationsMute.value = profile['preferences']['notifications']['mute'] ?? notificationsMute.value;
          notificationsPush.value = profile['preferences']['notifications']['push'] ?? notificationsPush.value;
          notificationsEmail.value = profile['preferences']['notifications']['email'] ?? notificationsEmail.value;
        }
        if (profile['preferences']['settings'] != null) {
          securitySettings.value = profile['preferences']['settings']['security'] ?? securitySettings.value;
          privacySettings.value = profile['preferences']['settings']['privacy'] ?? privacySettings.value;
        }
      }
    }
    
    if (data['stats'] != null) {
      activeCount.value = data['stats']['active'] ?? activeCount.value;
      pendingCount.value = data['stats']['pending'] ?? pendingCount.value;
      completeCount.value = data['stats']['complete'] ?? completeCount.value;
    }
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _repository.getProfile();
      if (response.statusCode == 200 && response.data['success']) {
        final data = response.data['data'];
        _parseProfileData(data);
        _saveToCache(data);
      }
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileData(Map<String, dynamic> dataToUpdate) async {
    isLoading.value = true;
    try {
      final response = await _repository.updateProfile(dataToUpdate);
      if (response.statusCode == 200 && response.data['success']) {
        // Optimistically update local or re-fetch
        await fetchProfile();
        Get.snackbar('Success', 'Profile updated successfully', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar('Error', 'Failed to update profile', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      isLoading.value = true;
      try {
        final res = await _repository.uploadAvatar(pickedFile.path);
        if (res.statusCode == 200 && res.data['success']) {
          avatarUrl.value = res.data['data']['avatarUrl'];
          Get.snackbar('Success', 'Profile picture updated', backgroundColor: AppColors.notifBgGreen, colorText: AppColors.notifIconGreen);
          await fetchProfile(); // re-fetch to cache
        }
      } catch (e) {
        print('Error uploading avatar: $e');
        Get.snackbar('Error', 'Failed to upload profile picture', backgroundColor: AppColors.accentRedLight, colorText: AppColors.accentRedDark);
      } finally {
        isLoading.value = false;
      }
    }
  }
}
