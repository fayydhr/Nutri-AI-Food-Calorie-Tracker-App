import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate remote network API call
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }

    return UserModel(
      id: 'usr_001',
      name: email.split('@').first,
      email: email,
    );
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate remote network API call
    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    return UserModel(
      id: 'usr_002',
      name: name,
      email: email,
    );
  }
}
