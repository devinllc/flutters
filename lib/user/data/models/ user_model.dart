import 'package:assign/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    String? deviceIdentifier,
    String? token, // Added token to constructor
  }) : super(
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          deviceIdentifier: deviceIdentifier,
          token: token, // Pass token to parent constructor
        );

  // Factory constructor to parse JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      deviceIdentifier: json['device_identifier'],
      token: json['token'], // Parse token here
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'device_identifier': deviceIdentifier,
      'token': token, // Include token in JSON serialization
    };
  }
}
