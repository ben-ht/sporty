import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/user/user.dart';

class AuthService {

  Future<void> register({
    required UserModel userModel,
    required String password,
  }) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: userModel.email,
      password: password,
    );

    if (response.user == null){
      SnackBar(content: Text("Registration failed. Please try again."));
      return;
    }
    final userId = response.user!.id;

    await Supabase.instance.client.from('profiles').insert({
      'userId': userId,
      'name': userModel.name,
      'surname': userModel.surname,
      'username': userModel.username,
    });
  }

  Future<void> login({
    required String email,
    required String password
  }) async {
    await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
    );
  }
}