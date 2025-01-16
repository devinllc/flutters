// lib/profile/domain/usecases/get_profile_usecase.dart
import 'package:assign/profile/domain/entity/profile_entity.dart';
import 'package:assign/profile/domain/repositories/profile_repository.dart';


class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<ProfileEntity> execute(String username) async {
    return await repository.getProfile(username);
  }
}
