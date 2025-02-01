import 'package:dio/dio.dart';

class LogoutUserUseCase {
  final Dio dio;

  LogoutUserUseCase(this.dio);

  Future<void> call(String token) async {
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
      rethrow;
    }
  }
}
