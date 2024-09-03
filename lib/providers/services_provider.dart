import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/config.dart';

class ServicesProvider with ChangeNotifier {
  List<Map<String, dynamic>> _activities = [];

  List<Map<String, dynamic>> get activities => _activities;

  Future<void> fetchServices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token == null || userId == null) return; // Handle unauthenticated state

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}activities/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _activities = List<Map<String, dynamic>>.from(json.decode(response.body));
        notifyListeners(); // Notify listeners when activities are loaded
      } else {
        throw Exception('Failed to load services');
      }
    } catch (error) {
      // Handle error
      print('Error fetching services: $error');
    }
  }
}