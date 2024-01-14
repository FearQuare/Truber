import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:truber/screens/login_page.dart';

enum UserType { jobPoster, truckDriver }

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _aboutController = TextEditingController();
  UserType? _selectedUserType = UserType.truckDriver;

  void signUpUser() async {
    final username = _usernameController.text;
    final existingUserCheck = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    final bool isJobPoster = _selectedUserType == UserType.jobPoster;
    // check if the username already exists
    if (existingUserCheck.docs.isNotEmpty) {
      _showAlertDialog(
          'This user already exists! Please find a distinctive username.');
    } else {
      await FirebaseFirestore.instance.collection('users').add({
        'username': _usernameController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
        'surname': _surnameController.text,
        'about': _aboutController.text,
        'profile_picture': '',
        'cover_image': '',
        'job_poster': isJobPoster,
      }).then((value) {
        _showSuccessDialog();
      }).catchError((error) {
        _showAlertDialog('An error occurred while signing up.');
      });
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Up Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Successfully signed up!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            // Username
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username is required';
                }
                return null;
              },
            ),
            // Password
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
            ),
            // Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            // Surname
            TextFormField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Surname'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Surname is required';
                }
                return null;
              },
            ),
            // About
            TextFormField(
              controller: _aboutController,
              decoration: InputDecoration(labelText: 'About'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'About is required';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Are you here as a Job Poster or a Truck Driver?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Job Poster'),
                  leading: Radio<UserType>(
                    value: UserType.jobPoster,
                    groupValue: _selectedUserType,
                    onChanged: (UserType? value) {
                      setState(() {
                        _selectedUserType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Truck Driver'),
                  leading: Radio<UserType>(
                    value: UserType.truckDriver,
                    groupValue: _selectedUserType,
                    onChanged: (UserType? value) {
                      setState(() {
                        _selectedUserType = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  signUpUser();
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
