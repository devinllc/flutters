class UserEntity {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? deviceIdentifier;
  final String? token; // Added token field

  UserEntity({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.deviceIdentifier,
    this.token, // Added token to constructor
  });

  // Method to convert UserEntity to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'device_identifier': deviceIdentifier,
      'token': token, // Include token in JSON
    };
  }

  // Method to convert JSON to UserEntity
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      deviceIdentifier: json['device_identifier'],
      token: json['token'], // Parse token from JSON
    );
  }
}
