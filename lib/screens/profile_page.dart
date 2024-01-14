import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:truber/main.dart';
import 'package:truber/screens/create_job_page.dart';
import 'package:truber/screens/edit_profile_page.dart';
import 'package:truber/screens/job_poster_home_page.dart';
import 'package:truber/widgets/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:truber/user_provider.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final bool isEditable;

  const ProfilePage({
    Key? key,
    required this.username,
    this.isEditable = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 280;
  final double profileHeight = 144;
  Map<String, dynamic> userProfile = {};
  bool isLoading = true;
  int _selectedIndex = 1;

  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: widget.username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userProfile = querySnapshot.docs.first.data();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    void _onItemTapped(int index) {
      if (index == 0) {
        if (userProvider.job_poster) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JobPosterHomePage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'Truber')),
          );
        }
      } else if ((index == 2)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateJobPage(),
          ),
        );
      }
      setState(() {
        _selectedIndex = index;
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          actions: widget.isEditable
              ? <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ]
              : null,
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildTop(),
            buildContent(),
          ],
        ),
        bottomNavigationBar: TruberNavBar(
          selectedIndex: _selectedIndex,
          onTabSelected: _onItemTapped,
          isJobPoster: userProvider.job_poster,
        ),
      ),
    );
  }

  Widget buildContent() {
    // Use the fetched user profile data to build the profile
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (userProfile.isEmpty) {
      return Center(child: Text('User not found.'));
    } else {
      String fullName = "${userProfile['name'] ?? ''} ${userProfile['surname'] ?? ''}";
      String? aboutText = userProfile['about'];

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            fullName,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          About(aboutText: aboutText ?? 'No details to show.'),
        ],
      );
    }
  }

  Widget buildTop() {
    // If data is still loading, show a loading indicator
    if (isLoading) {
      return SizedBox(
        height: coverHeight,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (userProfile.isEmpty) {
      // If no user is found, show a placeholder
      return SizedBox(
        height: coverHeight,
        child: Center(child: Text('User not found.')),
      );
    } else {
      // If data is loaded, show the profile picture and cover image
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: profileHeight / 2),
            child: Image.network(
              userProfile['cover_image'] ?? 'images/cover.jpg',
              width: double.infinity,
              height: coverHeight,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: coverHeight - profileHeight / 2,
            child: CircleAvatar(
              radius: profileHeight / 2,
              backgroundColor: Colors.grey.shade800,
              backgroundImage: NetworkImage(userProfile['profile_picture'] ?? 'images/profile_picture.jpg'),
            ),
          ),
        ],
      );
    }
  }

  // Widget buildCoverImage(UserProvider userProvider) => Container(
  //       color: Colors.grey,
  //       child: userProvider.cover_image != null &&
  //               userProvider.cover_image!.isNotEmpty
  //           ? Image.network(
  //               userProvider.cover_image!,
  //               width: double.infinity,
  //               height: coverHeight,
  //               fit: BoxFit.cover,
  //             )
  //           : Image.asset(
  //               'images/cover.jpg',
  //               width: double.infinity,
  //               height: coverHeight,
  //               fit: BoxFit.cover,
  //             ),
  //     );
  //
  // Widget buildProfileImage(UserProvider userProvider) => CircleAvatar(
  //       radius: profileHeight / 2,
  //       backgroundColor: Colors.grey.shade800,
  //       backgroundImage: userProvider.profile_picture != null &&
  //               userProvider.profile_picture!.isNotEmpty
  //           ? NetworkImage(userProvider.profile_picture!)
  //               as ImageProvider<Object>
  //           : AssetImage('images/profile_picture.jpg') as ImageProvider<Object>,
  //     );
}

class About extends StatelessWidget {
  const About({
    super.key,
    required this.aboutText,
  });

  final String? aboutText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'About',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              aboutText ?? 'Nothing to see here!',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
