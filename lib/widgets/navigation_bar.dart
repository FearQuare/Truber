import 'package:flutter/material.dart';

class TruberNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final bool isJobPoster;

  const TruberNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.isJobPoster = false,
  });

  @override
  State<StatefulWidget> createState() => _TruberNavBarState();
}

class _TruberNavBarState extends State<TruberNavBar> {
  @override
  Widget build(BuildContext context) {
    List<NavigationDestination> destinations = [
      const NavigationDestination(
        selectedIcon: Icon(Icons.home),
        icon: Icon(Icons.home_outlined),
        label: 'Home',
      ),
      const NavigationDestination(
        selectedIcon: Icon(Icons.person),
        icon: Icon(Icons.person_outlined),
        label: 'Profile',
      ),
    ];

    if (widget.isJobPoster) {
      destinations.add(
        const NavigationDestination(
          selectedIcon: Icon(Icons.business_center),
          icon: Icon(Icons.business_center_outlined),
          label: 'Post Jobs',
        ),
      );
    }

    return NavigationBar(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onTabSelected,
      indicatorColor: Colors.amber,
      destinations: destinations,
    );
  }
}
