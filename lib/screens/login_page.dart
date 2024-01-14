import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truber/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:truber/screens/job_poster_home_page.dart';
import 'package:truber/screens/sign_up_page.dart';
import 'package:truber/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      // If username exists check
      final userDocument = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (userDocument.docs.isNotEmpty) {
        final data = userDocument.docs.first.data();

        // Password match check
        if (data['password'] == password) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUserDetails(
            data['name'] as String,
            password,
            data['profile_picture'] as String,
            data['surname'] as String,
            username,
            data['about'] as String,
            data['cover_image'] as String,
            data['job_poster'] as bool,
          );

          // Check if the user is a job poster and navigate to the corresponding main page
          if (data['job_poster'] == true) {
            // Navigate to the job poster's main page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => JobPosterHomePage(),
              ),
            );
          } else {
            // Navigate to the regular user's main page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Truber')),
            );
          }
        } else {
          _showErrorDialog('Incorrect Password');
        }
      } else {
        _showErrorDialog('User not Found');
      }
    } catch (e) {
      _showErrorDialog('Something went wrong');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 22.0, vertical: 112.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'images/truber-truck.jpeg',
                  width: 200,
                  height: 100,
                ),
              ),
              const SizedBox(height: 44.0),
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'enter your username',
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: _login,
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("If you don't have an account "),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text("Sign Up")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
