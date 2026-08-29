import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<UserEntity> call() async {
    return await repository.loginWithGoogle();
  }
}
