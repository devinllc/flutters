import 'package:assign/user/data/models/%20user_model.dart';
import 'package:dio/dio.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<UserModel?> createUser({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String email,
    required String deviceIdentifier,
  }) async {
    try {
      final response = await dio.post(
        'https://api.wemotions.app/user/create',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'password': password,
          'email': email,
          'device_identifier': deviceIdentifier,
          'merge_account': false,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('User creation failed: ${response.data['message']}');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel?> loginUser(String usernameOrEmail, String password) async {
    try {
      final response = await dio.post(
        'https://api.wemotions.app/user/login',
        data: {
          'mixed': usernameOrEmail,
          'password': password,
          'app_name': 'wemotions',
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Login failed: ${response.data['message']}');
      }
    } catch (e) {
      throw e;
    }
  }

  // Logout method
  Future<void> logoutUser(String token) async {
    try {
      final response = await dio.post(
        'https://api.wemotions.app/user/logout',
        options: Options(
          headers: {'Flic-Token': token},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Logout failed: ${response.data['message']}');
      }
    } catch (e) {
      throw e;
    }
  }

  // Resend verification email method
  Future<void> resendVerificationEmail(String mixed, String token) async {
    try {
      final response = await dio.post(
        'https://api.wemotions.app/user/resend-verification-email',
        options: Options(
          headers: {'Flic-Token': token},
        ),
        data: {'mixed': mixed},
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to resend verification email: ${response.data['message']}');
      }
    } catch (e) {
      throw e;
    }
  }
}
