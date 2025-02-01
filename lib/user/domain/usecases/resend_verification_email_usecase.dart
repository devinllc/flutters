import 'package:dio/dio.dart';

class ResendVerificationEmailUseCase {
  final Dio dio;

  ResendVerificationEmailUseCase(this.dio);

  Future<void> call({required String mixed, required String token}) async {
    try {
      final response = await dio.post(
        'https://api.wemotions.app/user/resend-verification-email',
        options: Options(
          headers: {'Flic-Token': token},
        ),
        data: {'mixed': mixed},
      );

      if (response.statusCode != 200 || response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Unknown error occurred');
      }
    } on DioException catch (dioError) {
      final errorMessage =
          dioError.response?.data['message'] ?? dioError.message;
      throw Exception('Dio error: $errorMessage');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
