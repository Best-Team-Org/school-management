import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  String? username;
  String? email;
  String? password;
  int? role;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'role': role,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      role: map['role'] as int,
    );
  }


  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, email: $email, password: $password, role: $role}';
  }


}
