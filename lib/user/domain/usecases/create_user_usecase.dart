import 'package:assign/user/data/datasources/user_remote_datasource.dart';
import 'package:assign/user/data/models/%20user_model.dart';

class CreateUserUseCase {
  final UserRemoteDataSource userRemoteDataSource;

  CreateUserUseCase(this.userRemoteDataSource);

  Future<UserModel?> call({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String email,
    required String deviceIdentifier,
  }) async {
    return await userRemoteDataSource.createUser(
      firstName: firstName,
      lastName: lastName,
      username: username,
      password: password,
      email: email,
      deviceIdentifier: deviceIdentifier,
    );
  }
}
