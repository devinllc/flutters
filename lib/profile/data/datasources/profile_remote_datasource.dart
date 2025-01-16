// lib/profile/data/datasources/profile_remote_data_source.dart
import 'package:assign/profile/domain/entity/profile_entity.dart';
import 'package:dio/dio.dart';


class ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSource(this.dio);

  Future<ProfileEntity> getProfile(String username) async {
    final response =
        await dio.get('https://api.wemotions.app/profile/test');

    if (response.statusCode == 200) {
      return ProfileEntity.fromJson(response.data);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
