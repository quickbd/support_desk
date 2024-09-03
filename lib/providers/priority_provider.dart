import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/config.dart';

class PriorityProvider with ChangeNotifier {
  Map<String, String> _priorities = {};

  Map<String, String> get priorities => _priorities;

  Future<void> fetchPriorities() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return; // Handle unauthenticated state

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}priorities'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _priorities = Map<String, String>.from(json.decode(response.body));
        notifyListeners(); // Notify listeners when priorities are loaded
      } else {
        throw Exception('Failed to load priorities');
      }
    } catch (error) {
      // Handle error
      print('Error fetching priorities: $error');
    }
  }
}
