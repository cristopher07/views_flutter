import '../../domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.image,
    required super.accessToken,
    required super.refreshToken,
  });

  factory UserModel.fromFirebaseUser(User user) {
    final displayName = user.displayName ?? '';
    final parts = displayName.trim().split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.skip(1).join(' ') : '';

    return UserModel(
      id: user.uid,
      username: user.email ?? user.uid,
      email: user.email ?? '',
      firstName: firstName,
      lastName: lastName,
      gender: '',
      image: user.photoURL ?? '',
      accessToken: '',
      refreshToken: user.refreshToken ?? '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      image: json['image'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
