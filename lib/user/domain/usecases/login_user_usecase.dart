import 'package:assign/user/data/models/%20user_model.dart';
import 'package:assign/user/domain/entities/user_entity.dart';
import 'package:dio/dio.dart';


class LoginUserUseCase {
  final Dio dio;

  LoginUserUseCase(this.dio);

  Future<UserEntity?> call(String usernameOrEmail, String password) async {
    try {
      final response = await dio.post(
        'https://api.wemotions.app/user/login', // Your API endpoint
        data: {
          'mixed': usernameOrEmail, // Send username or email as 'mixed'
          'password': password, // Send password
          'app_name': 'wemotions', // Required field for the app name
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return UserModel.fromJson(
            response.data); // Create UserModel from response
      } else {
        return null; // Handle failed login
      }
    } catch (e) {
      print("Login error: $e");
      rethrow;
    }
  }
}
