import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sporty/utils/constants/size.dart';

import '../models/user_model.dart';

class AuthService {

  Future<void> register({
    required UserModel userModel,
    required String password
  }) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password
      );

      User? user = credential.user;
      if (user == null){
        return;
      }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        userModel.toMap()
      );

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