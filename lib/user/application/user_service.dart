import 'package:dio/dio.dart';

class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<Response> createUser(Map<String, dynamic> userData) async {
    return await dio.post('https://api.wemotions.app/user/create',
        data: userData);
  }

  Future<Response> loginUser(Map<String, dynamic> loginData) async {
    return await dio.post('https://api.wemotions.app/user/login',
        data: loginData);
  }
}
