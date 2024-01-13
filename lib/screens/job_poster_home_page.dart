import 'package:flutter/material.dart';
import 'package:truber/screens/profile_page.dart';
import 'package:truber/widgets/navigation_bar.dart';

class JobPosterHomePage extends StatefulWidget {
  final bool isJobPoster;
  const JobPosterHomePage({super.key, this.isJobPoster = true});
  @override
  State<StatefulWidget> createState() => _JobPosterHomePageState();
}

class _JobPosterHomePageState extends State<JobPosterHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Text("canim bura nere")),
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
        title: const Text('Job Poster Dashboard'),
      ),
      body: Center(
        child: Text('Brooo'),
      ),
      bottomNavigationBar: TruberNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
        isJobPoster: true,
      ),
    );
  }
}
