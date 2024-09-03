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
        Uri.parse('${AppConfig.apiUrl}login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      _logger.i('Login Status Code: ${response.statusCode}');
      _logger.i('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
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
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to login: ${errorResponse['message']}');
      }
    } catch (error) {
      _logger.e('Error during login: $error');
      rethrow;
    }
  }

  Future<bool> requestPasswordReset(String mobileNumber) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}request-password-reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile_number': mobileNumber}),
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failure
      }
    } catch (error) {
      Logger().e('Error during password reset request: $error');
      return false; // Failure due to error
    }
  }




  Future<bool> resetPassword(String mobileNumber, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobileNumber, 'password': newPassword}),
      );

      _logger.i('Password Reset Status Code: ${response.statusCode}');
      _logger.i('Password Reset Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true; // Password reset successful
      } else {
        return false; // Password reset failed
      }
    } catch (error) {
      _logger.e('Error during password reset: $error');
      return false; // Failure due to error
    }
  }


  Future<bool> loginWithNewPassword(String mobileNumber, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}login-with-new-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile_number': mobileNumber, 'password': newPassword}),
      );

      if (response.statusCode == 200) {
        // Handle successful login, such as storing the token
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Logger().e('Error during login with new password: $error');
      return false;
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

  Future<void> loadUserDetails() async {
    if (_token == null || _userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}user/$_userId'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final userDetails = jsonDecode(response.body);
        _name = userDetails['name'];
        _phone = userDetails['phone'];
        _email = userDetails['email'];

        // Optionally update SharedPreferences with the new details
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', _name!);
        await prefs.setString('phone', _phone!);
        await prefs.setString('email', _email!);

        notifyListeners();
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (error) {
      _logger.e('Error loading user details: $error');
    }
  }
}