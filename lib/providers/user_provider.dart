import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    image: '',
    name: '',
    about: '',
  );

  bool _isDark = false;

  User get user {
    return _user;
  }

  bool get isDark {
    return _isDark;
  }

  void login(String id, String image, String name, String? about) async {
    _user.id = id;
    _user.image = image;
    _user.name = name;
    _user.about = about ?? '';
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'id': id,
      'image': image,
      'name': name,
      'about': about,
    });

    prefs.setString('userData', data);
  }

  void fetchData() async {
    final prefs = await SharedPreferences.getInstance();

    final extractedData =
        jsonDecode(prefs.getString('userData')!) as Map<String, dynamic>;

    _user = User(
      id: extractedData['id'],
      image: extractedData['image'],
      name: extractedData['name'],
      about: extractedData['about'],
    );
    notifyListeners();
  }

  void updateAbout(String about) async {
    _user.about = about;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'id': _user.id,
      'image': _user.image,
      'name': _user.name,
      'about': _user.about,
    });

    prefs.setString('userData', data);
  }

  void logout() async {
    _user = User(
      id: '',
      image: '',
      name: '',
      about: '',
    );
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void setTheme(bool value) async {
    _isDark = value;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', _isDark);
  }

  void fetchTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // try {
    //   _isDark = prefs.getBool('theme')!;
    // } catch (e) {
    //   rethrow;
    // } finally {
    //   _isDark = false;
    // }

    _isDark = prefs.getBool('theme') ?? false;

    notifyListeners();
  }

  void deleteThemeData() async {
    _isDark = false;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
