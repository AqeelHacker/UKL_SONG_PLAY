import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  bool? status;
  String? token;
  String? message;
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;

  UserModel({
    this.status,
    this.token,
    this.message,
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
  });

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('status', status ?? false);
    await prefs.setString('token', token ?? '');
    await prefs.setString('message', message ?? '');
    await prefs.setInt('id', id ?? 0);
    await prefs.setString('username', username ?? '');
    await prefs.setString('email', email ?? '');
    await prefs.setString('firstName', firstName ?? '');
    await prefs.setString('lastName', lastName ?? '');
    await prefs.setString('gender', gender ?? '');
  }

  static Future<UserModel> getFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return UserModel(
      status: prefs.getBool('status') ?? false,
      token: prefs.getString('token'),
      message: prefs.getString('message'),
      id: prefs.getInt('id'),
      username: prefs.getString('username'),
      email: prefs.getString('email'),
      firstName: prefs.getString('firstName'),
      lastName: prefs.getString('lastName'),
      gender: prefs.getString('gender'),
    );
  }

  static Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
