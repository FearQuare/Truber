import 'package:flutter/material.dart';

class TruberNavBar extends StatefulWidget {
  final Function(int) onTabSelected;
  const TruberNavBar({super.key, required this.onTabSelected});
  @override
  State<StatefulWidget> createState() => _TruberNavBarState();
}

class _TruberNavBarState extends State<TruberNavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
        widget.onTabSelected(index);
      },
      indicatorColor: Colors.amber,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Badge(child: Icon(Icons.notifications_sharp)),
          label: 'notifications',
        ),
        NavigationDestination(
          icon: Badge(
            child: Icon(Icons.person),
          ),
          label: 'Profile',
        ),
      ],
    );
  }

}