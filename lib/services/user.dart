import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_login.dart';

class UserService {
  Future<UserLogin> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final user = UserLogin(
        status: true,
        token: json['token'],
        message: "Login berhasil",
        id: json['id'],
        namaUser: "${json['firstName']} ${json['lastName']}",
        email: json['email'],
        role: json['gender'],
      );

      await user.saveToPrefs();
      return user;
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }
}
