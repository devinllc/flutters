import 'package:assign/user/data/datasources/user_remote_datasource.dart';
import 'package:assign/user/domain/entities/user_entity.dart';
import 'package:assign/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity?> createUser({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String email,
    required String deviceIdentifier,
  }) async {
    return await remoteDataSource.createUser(
      firstName: firstName,
      lastName: lastName,
      username: username,
      password: password,
      email: email,
      deviceIdentifier: deviceIdentifier,
    );
  }

  @override
  Future<UserEntity?> loginUser(String usernameOrEmail, String password) async {
    return await remoteDataSource.loginUser(usernameOrEmail, password);
  }

  @override
  Future<void> logoutUser(String token) async {
    return await remoteDataSource.logoutUser(token);
  }

  @override
  Future<void> resendVerificationEmail(String mixed, String token) async {
    return await remoteDataSource.resendVerificationEmail(mixed, token);
  }
}
