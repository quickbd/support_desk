import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

import '../utils/config.dart';

class AuthProvider with ChangeNotifier {
  final Logger _logger = Logger(); // Create a logger instance

  String? _token;
  String? _userId;
  String? _name;
  String? _phone;
  String? _email;

  String? get token => _token;
  String? get userId => _userId;
  String? get name => _name;
  String? get phone => _phone;
  String? get email => _email;

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.https('support.quickbd.net','api/login'),
        headers: {'Content-Type': 'application/json',"Access-Control-Allow-Origin": "header",
          'Accept': '*/*'}, // Add headers
        body: json.encode({'email': email, 'password': password}),
      );
print(response.body);
      _logger.i('Login Status Code: ${response.statusCode}'); // Log status code
      _logger.i('Login Response Body: ${response.body}'); // Log response body

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final data = responseData['data'];

        _token = data['api_token'];
        _userId = data['user_id'].toString();
        _name = data['name'];
        _phone = data['phone'];
        _email = data['email'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('userId', _userId!);
        await prefs.setString('name', _name!);
        await prefs.setString('phone', _phone!);
        await prefs.setString('email', _email!);

        notifyListeners();
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception('Failed to login: ${errorResponse['message']}');
      }
    } catch (error) {
      print(error);
      _logger.e('Error during login: $error');
      rethrow; // Rethrow the caught error to maintain the original stack trace
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _name = null;
    _phone = null;
    _email = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('name');
    await prefs.remove('phone');
    await prefs.remove('email');

    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userId = prefs.getString('userId');
    _name = prefs.getString('name');
    _phone = prefs.getString('phone');
    _email = prefs.getString('email');

    return _token != null && _userId != null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    if (_token == null) return null;

    final response = await http.get(
      Uri.parse('${AppConfig.apiUrl}user/$_userId'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
