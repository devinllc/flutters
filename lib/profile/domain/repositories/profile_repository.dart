// lib/profile/domain/repositories/profile_repository.dart


import 'package:assign/profile/domain/entity/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile(String username);
}
