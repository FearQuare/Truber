import 'package:flutter/material.dart';
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
    final userProvider = Provider.of<UserProvider>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
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
        ),
      ),
    );
  }

  Widget buildContent(UserProvider userProvider) {
    String? name = userProvider.name;
    String? surname = userProvider.surname;
    String fullName = "${name} ${surname}";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(fullName),
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
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(userProvider),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
      color: Colors.grey,
      child: Image.network(
        'https://cdn.pixabay.com/photo/2023/12/06/08/56/winter-8433264_1280.jpg',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ));

  Widget buildProfileImage(UserProvider userProvider) => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(
          userProvider.profile_picture ??
              'https://cdn.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg',
        ),
      );
}
