import 'package:chat_app/widget/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication_Screen extends StatefulWidget {
  const Authentication_Screen({super.key});

  @override
  State<Authentication_Screen> createState() => _Authentication_ScreenState();
}

class _Authentication_ScreenState extends State<Authentication_Screen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  void _submitForm(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authRes;
    try {
      setState(() {
        isLoading = true;
      });
      // print('3');
      if (isLogin) {
        authRes = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authRes = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(authRes.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      // print('1');
      // var message = "An error occured";
      if (err != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm, isLoading),
    );
  }
}
