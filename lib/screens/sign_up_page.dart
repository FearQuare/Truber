import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  void signUpUser() async {
    await FirebaseFirestore.instance.collection('users').add({
      'username': _usernameController.text,
      'password': _passwordController.text,
      'name': _nameController.text,
      'surname': _surnameController.text,
      'about': _aboutController.text,
      'profile_picture': '',
      'cover_image': '',
    });
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
              validator: (value){
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
              validator: (value){
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
              validator: (value){
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
              validator: (value){
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
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'About is required';
                }
                return null;
              },
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