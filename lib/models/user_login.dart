import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  bool? status;
  String? token;
  String? message;
  int? id;
  String? namaUser;
  String? email;
  String? role;

  UserLogin({
    this.status,
    this.token,
    this.message,
    this.id,
    this.namaUser,
    this.email,
    this.role,
  });

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("status", status ?? false);
    await prefs.setString("token", token ?? '');
    await prefs.setString("message", message ?? '');
    await prefs.setInt("id", id ?? 0);
    await prefs.setString("nama_user", namaUser ?? '');
    await prefs.setString("email", email ?? '');
    await prefs.setString("role", role ?? '');
  }

  static Future<UserLogin> getUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return UserLogin(
      status: prefs.getBool("status") ?? false,
      token: prefs.getString("token") ?? '',
      message: prefs.getString("message") ?? '',
      id: prefs.getInt("id") ?? 0,
      namaUser: prefs.getString("nama_user") ?? '',
      email: prefs.getString("email") ?? '',
      role: prefs.getString("role") ?? '',
    );
  }

  static Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
