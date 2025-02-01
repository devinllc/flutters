import 'package:assign/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> createUser({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String email,
    required String deviceIdentifier,
  });

  Future<UserEntity?> loginUser(String usernameOrEmail, String password);
  Future<void> logoutUser(String token); // New method for logout

  Future<void> resendVerificationEmail(
      String mixed, String token); // New method for resend verification email
}
