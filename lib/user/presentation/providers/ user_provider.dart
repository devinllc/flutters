import 'dart:convert';
import 'package:assign/user/domain/usecases/resend_verification_email_usecase.dart';
import 'package:assign/user/domain/usecases/create_user_usecase.dart';
import 'package:assign/user/domain/usecases/login_user_usecase.dart';
import 'package:assign/user/domain/entities/user_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  final CreateUserUseCase _createUserUseCase;
  final LoginUserUseCase _loginUserUseCase;
  final ResendVerificationEmailUseCase _resendVerificationEmailUseCase;

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserProvider(
    this._createUserUseCase,
    this._loginUserUseCase,
    this._resendVerificationEmailUseCase,
  ) {
    _loadUser();
  }

  // Load user data from shared preferences
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn && userData != null) {
      _user = UserEntity.fromJson(jsonDecode(userData));
    }

    // Ensure this notifyListeners() is not called during the widget build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Save user data and login state
  Future<void> _saveUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    await prefs.setBool('is_logged_in', true);
    _user = user;

    // Ensure this notifyListeners() is not called during the widget build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Clear user data and logout state
  Future<void> _clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.setBool('is_logged_in', false);
    _user = null;

    // Ensure this notifyListeners() is not called during the widget build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Method to create a user
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String email,
    required String deviceIdentifier,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _createUserUseCase(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        email: email,
        deviceIdentifier: deviceIdentifier,
      );

      if (_user == null) {
        _errorMessage =
            'User creation failed, username might be taken or invalid data';
      } else {
        _errorMessage = null;
        await _saveUser(_user!);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 400) {
          _errorMessage = "Invalid input, please check your data.";
        } else if (e.response?.statusCode == 409) {
          _errorMessage = "Username or email is already taken.";
        } else {
          _errorMessage = "An error occurred: ${e.message}";
        }
      } else {
        _errorMessage = 'Unexpected error: $e';
      }
    } finally {
      _isLoading = false;

      // Ensure this notifyListeners() is not called during the widget build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Method to log in a user
  Future<void> loginUser(String usernameOrEmail, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _loginUserUseCase(usernameOrEmail, password);

      if (_user != null) {
        await _saveUser(_user!);
      } else {
        _errorMessage = 'Login failed: Invalid credentials';
      }
    } catch (e) {
      _errorMessage = 'Login failed: $e';
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_user?.token == null) {
        _errorMessage = "User token is missing.";
        return;
      }

      await _resendVerificationEmailUseCase.call(
        mixed: _user!.email,
        token: _user!.token!,
      );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error resending verification email: $e";
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Logout user
  Future<void> logoutUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_user?.token == null) {
        _errorMessage = "User token is missing.";
        return;
      }

      final dio = Dio();
      dio.options.headers = {
        'Flic-Token': _user!.token!,
      };

      final response = await dio.post('https://api.wemotions.app/user/logout');

      if (response.statusCode == 200) {
        await _clearUser();
      } else {
        _errorMessage = response.data['message'] ?? 'Logout failed';
      }
    } catch (e) {
      _errorMessage = 'Error logging out: $e';
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
