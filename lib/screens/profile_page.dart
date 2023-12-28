import 'package:flutter/material.dart';
import 'package:truber/widgets/navigation_bar.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  final double coverHeight = 280;
  final double profileHeight = 144;

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pop(context);
    }
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight/2;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
        ),
        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            buildCoverImage(),
            Positioned(
              top: top,
              child: buildProfileImage(),
            ),
          ],
        ),
        bottomNavigationBar: TruberNavBar(
          selectedIndex: _selectedIndex,
          onTabSelected: _onItemTapped,
        ),
      ),
    );
  }

  Widget buildCoverImage() => Container(
      color: Colors.grey,
      child: Image.network(
        'https://cdn.pixabay.com/photo/2023/12/06/08/56/winter-8433264_1280.jpg',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      )
  );

  Widget buildProfileImage() => CircleAvatar(
    radius: profileHeight / 2,
    backgroundColor: Colors.grey.shade800,
    backgroundImage: NetworkImage(
      'https://cdn.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg',
    ),
  );
}
