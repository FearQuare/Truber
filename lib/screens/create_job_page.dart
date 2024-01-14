import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:truber/screens/job_poster_home_page.dart';
import 'package:truber/screens/profile_page.dart';
import 'package:truber/user_provider.dart';

import '../widgets/navigation_bar.dart';

class CreateJobPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  int _selectedIndex = 2;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jobNameController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    _jobNameController.dispose();
    _jobDescriptionController.dispose();
    super.dispose();
  }

  void _createJob() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('jobs').add({
        'job_name': _jobNameController.text,
        'job_description': _jobDescriptionController.text,
        'job_poster': '${userProvider.name} ${userProvider.surname}',
        'applicants': [],
      }).then((value) {
        print('Job Created Successfully');
        Navigator.pop(context);
      }).catchError((error) {
        print('Failed to create job: $error');
      });
    }
  }

  void _onItemTapped(int index) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                  username: userProvider.username,
                  isEditable: true,
                )),
      );
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JobPosterHomePage()),
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Job'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _jobNameController,
                decoration: InputDecoration(labelText: 'Job Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Job name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobDescriptionController,
                decoration: InputDecoration(labelText: 'Job Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Job description is required';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _createJob,
                child: Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TruberNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
        isJobPoster: true,
      ),
    );
  }
}
