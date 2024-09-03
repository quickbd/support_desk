import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/config.dart';

class DepartmentProvider with ChangeNotifier {
  List<Map<String, dynamic>> _departments = [];

  List<Map<String, dynamic>> get departments => _departments;

  Future<void> fetchDepartments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return; // Handle unauthenticated state

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}departments'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        _departments = responseData.map((data) {
          return {
            'id': data['id'].toString(),
            'title': data['title'],
          };
        }).toList();
        notifyListeners(); // Notify listeners when departments are loaded
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (error) {
      // Handle error
      print('Error fetching departments: $error');
    }
  }
}
