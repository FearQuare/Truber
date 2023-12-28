import 'package:flutter/material.dart';
import 'package:truber/widgets/navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  int currentPageIndex = 1;

  void _onTabSelected(int index){
    if (index != currentPageIndex){
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Go Back to Main Page"),)
            ],
          ),
        ),
        bottomNavigationBar: TruberNavBar(
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}
