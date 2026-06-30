import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

abstract class FirebaseLoginDataSource {
  Stream<UserModel?> authStateChanges();

  UserModel? get currentUser;

  Future<UserModel> login({required String email, required String password});

  Future<void> logout();
}

class FirebaseLoginDataSourceImpl implements FirebaseLoginDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseLoginDataSourceImpl({required this.firebaseAuth});

  @override
  Stream<UserModel?> authStateChanges() {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }

  @override
  UserModel? get currentUser {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('No se pudo obtener el usuario autenticado.');
    }

    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<void> logout() {
    return firebaseAuth.signOut();
  }
}
