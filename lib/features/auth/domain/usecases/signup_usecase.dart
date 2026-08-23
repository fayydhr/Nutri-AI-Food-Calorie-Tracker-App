import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await repository.signup(
      name: name,
      email: email,
      password: password,
    );
  }
}
