import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TriStatePreferences{
  static final TriStatePreferences _instance = TriStatePreferences._internal();
  TriStatePreferences._internal();
  factory TriStatePreferences() {
    return _instance;
  }

  Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  setString(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null && value.isNotEmpty) {
      prefs.setString(key, value);
    }
  }

  Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  removePreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  removeAllPreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}