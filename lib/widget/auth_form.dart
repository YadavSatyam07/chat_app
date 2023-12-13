import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext context,
  ) submitFn;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey("Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value == null || !value.contains('@')) {
                          return 'Enter a Valid Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                      onSaved: (val) {
                        _userEmail = val.toString();
                      },
                    ),
                  TextFormField(
                    key: ValueKey("Username"),
                    validator: (String? value) {
                      if (value == null || value.length < 4) {
                        return 'Username should be at least 4 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: (val) {
                      _userName = val.toString();
                    },
                  ),
                  TextFormField(
                    key: ValueKey("Password"),
                    validator: (String? value) {
                      if (value == null || value.length < 7) {
                        return 'Password should be at least 7 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    onSaved: (val) {
                      _userPassword = val.toString();
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? "Login" : "Sign Up"),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin ? "New User" : "Existing User"),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
