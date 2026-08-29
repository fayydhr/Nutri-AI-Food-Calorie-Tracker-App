import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<UserEntity> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<UserEntity> loginWithGoogle();
}
