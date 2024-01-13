import 'package:flutter/material.dart';

class JobPosterHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text('Welcome, Job Poster!'),
      ),
    );
  }
}