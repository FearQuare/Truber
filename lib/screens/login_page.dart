import 'package:flutter/material.dart';
import 'package:truber/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        final data = userDocument.docs.first.data() as Map<String, dynamic>;

        // Password match check
        if (data['password'] == password) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'Truber')),
          );
        } else {
          _showErrorDialog('Incorrect Password');
        }
      } else {
        _showErrorDialog('User not Found');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('Something went wrong');
    }
    // if(_usernameController.text == 'admin' && _passwordController.text == 'admin'){
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Truber')),
    //   );
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Text('Something is wrong'),
    //       content: const Text('The username or password is wrong'),
    //       actions: <Widget>[
    //         TextButton(onPressed: (){
    //           Navigator.of(context).pop();
    //         }, child: const Text('close'))
    //       ],
    //     ),
    //   );
    // }
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
                  'C:/Users/E/Desktop/Codes/flutter_projects/Truber/images/truber-truck.jpeg',
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
            ],
          ),
        ),
      ),
    );
  }
}
