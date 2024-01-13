import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:truber/main.dart';
import 'package:truber/screens/edit_profile_page.dart';
import 'package:truber/screens/job_poster_home_page.dart';
import 'package:truber/widgets/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:truber/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  int _selectedIndex = 1;

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
      }
      setState(() {
        _selectedIndex = index;
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildTop(userProvider),
            buildContent(userProvider),
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

  Widget buildContent(UserProvider userProvider) {
    String? name = userProvider.name;
    String? surname = userProvider.surname;
    String fullName = "${name ?? ''} ${surname ?? ''}";
    String? aboutText = userProvider.about;

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
        About(aboutText: aboutText),
      ],
    );
  }

  Widget buildTop(UserProvider userProvider) {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(userProvider),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(userProvider),
        ),
      ],
    );
  }

  Widget buildCoverImage(UserProvider userProvider) => Container(
        color: Colors.grey,
        child: userProvider.cover_image != null &&
                userProvider.cover_image!.isNotEmpty
            ? Image.network(
                userProvider.cover_image!,
                width: double.infinity,
                height: coverHeight,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'images/cover.jpg',
                width: double.infinity,
                height: coverHeight,
                fit: BoxFit.cover,
              ),
      );

  Widget buildProfileImage(UserProvider userProvider) => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: userProvider.profile_picture != null &&
                userProvider.profile_picture!.isNotEmpty
            ? NetworkImage(userProvider.profile_picture!) as ImageProvider<Object>
            : AssetImage('images/profile_picture.jpg') as ImageProvider<Object>,
      );
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
