import 'package:assign/home.dart';
import 'package:assign/user/presentation/providers/%20user_provider.dart';

import 'package:assign/user/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String usernameOrEmail, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username or Email'),
                onSaved: (value) => usernameOrEmail = value!,
                validator: (value) =>
                    value!.isEmpty ? "Please enter username or email" : null,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                onSaved: (value) => password = value!,
                validator: (value) =>
                    value!.isEmpty ? "Please enter password" : null,
              ),
              SizedBox(height: 20),
              Consumer<UserProvider>(
                builder: (context, provider, child) {
                  return provider.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await provider.loginUser(
                                  usernameOrEmail, password);

                              if (provider.user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(provider.errorMessage!)),
                                );
                              }
                            }
                          },
                          child: Text('Log In'),
                        );
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
