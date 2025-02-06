import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sporty/utils/constants/size.dart';

class AuthService {

  Future<void> register({
    required String email,
    required String password
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch(e){
      String message = '';
      if (e.code == 'weak-password'){
        message = 'Le mot de passe est trop faible';
      } else if (e.code == 'email-already-in-use'){
        message = 'Un compte existe déjà avec cet email';
      }

      Fluttertoast.showToast(msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black26,
        textColor: Colors.white70,
        fontSize: Sizes.fontSizeLg
      );
    }
  }
}