import 'package:assign/profile/domain/entity/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:assign/profile/domain/usecases/get_profile_usecase.dart';

class ProfileProvider with ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;

  ProfileProvider(this._getProfileUseCase);

  ProfileEntity? _profile;
  ProfileEntity? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchProfile(String username) async {
    print("Fetching profile for: $username");

    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Notify listeners that loading has started

    try {
      print("Executing use case...");
      final profileData = await _getProfileUseCase.execute(username);
      _profile = profileData;
      print("Profile data fetched successfully");
    } catch (e) {
      _errorMessage = 'Failed to load profile. Error: $e';
      print("Error occurred: $e");
    } finally {
      _isLoading = false;
      print("Fetching complete");
      notifyListeners(); // Notify listeners when fetching is complete
    }
  }
}
