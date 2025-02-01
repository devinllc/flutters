
import 'package:assign/home.dart';
import 'package:assign/user/presentation/providers/%20user_provider.dart';

import 'package:assign/user/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName, lastName, username, password, email, deviceIdentifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) => firstName = value!,
                validator: (value) =>
                    value!.isEmpty ? "Please enter your first name" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => lastName = value!,
                validator: (value) =>
                    value!.isEmpty ? "Please enter your last name" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onSaved: (value) => username = value!,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a username" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => password = value!,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a password" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value!,
                validator: (value) =>
                    value!.isEmpty ? "Please enter your email" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Device Identifier'),
                onSaved: (value) => deviceIdentifier = value!,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a device identifier" : null,
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
                              await provider.createUser(
                                firstName: firstName,
                                lastName: lastName,
                                username: username,
                                password: password,
                                email: email,
                                deviceIdentifier: deviceIdentifier,
                              );

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
                          child: Text('Sign Up'),
                        );
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
