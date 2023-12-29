import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? name;
  String? password;
  String? profile_picture;
  String? surname;
  String? username;

  void setUserDetails(String name, String password, String profile_picture,
      String surname, String username) {
    this.name = name;
    this.password = password;
    this.profile_picture = profile_picture;
    this.surname = surname;
    this.username = username;
    notifyListeners();
  }
}
