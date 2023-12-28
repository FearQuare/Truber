import 'package:flutter/material.dart';

class TruberNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  const TruberNavBar({super.key, required this.selectedIndex, required this.onTabSelected});
  @override
  State<StatefulWidget> createState() => _TruberNavBarState();
}

class _TruberNavBarState extends State<TruberNavBar> {

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onTabSelected,
      indicatorColor: Colors.amber,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}