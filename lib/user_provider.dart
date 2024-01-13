import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? name;
  String? password;
  String? profile_picture;
  String? surname;
  String? username;
  String? about;
  String? cover_image;

  void setUserDetails(String name, String password, String profile_picture,
      String surname, String username, String about, String cover_image) {
    this.name = name;
    this.password = password;
    this.profile_picture = profile_picture;
    this.surname = surname;
    this.username = username;
    this.about = about;
    this.cover_image = cover_image;
    notifyListeners();
  }

  void updateAbout(String about) {
    this.about = about;
    notifyListeners();
  }
  // Other update methods will be listed here.
}
