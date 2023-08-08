import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  String? _token;

  bool get isAuth {
    if (_token == null) return false;
    return true;
  }

  Future<void> authenticate(String token) async {
    _token = token;

    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode({'token': _token});
      prefs.setString('data', data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('data')) {
      return false;
    }

    final extractedData =
        jsonDecode(prefs.getString('data')!) as Map<String, dynamic>;
    _token = extractedData['token'];
    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
