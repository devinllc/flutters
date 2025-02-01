// lib/profile/data/repositories/profile_repository_impl.dart
import 'package:assign/profile/data/datasources/profile_remote_datasource.dart';
import 'package:assign/profile/domain/entity/profile_entity.dart';
import 'package:assign/profile/domain/repositories/profile_repository.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity> getProfile(String username) async {
    return await remoteDataSource.getProfile(username);
  }
}
