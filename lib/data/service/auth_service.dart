import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sporty/utils/constants/size.dart';
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

    if (response.user == null) {
      Fluttertoast.showToast(msg: "Registration failed. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black26,
        textColor: Colors.white70,
        fontSize: Sizes.fontSizeLg
      );
    }
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