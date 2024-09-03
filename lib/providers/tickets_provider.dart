import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/config.dart';

class TicketsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tickets = [];

  List<Map<String, dynamic>> get tickets => _tickets;

  Future<void> fetchTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token == null || userId == null) return; // Handle unauthenticated state

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}tickets/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _tickets = List<Map<String, dynamic>>.from(json.decode(response.body));
        notifyListeners(); // Notify listeners when tickets are loaded
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (error) {
      // Handle error
      print('Error fetching tickets: $error');
    }
  }

  Future<Map<String, dynamic>> fetchTicketDetails(String ticketToken) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token == null) return {}; // Handle unauthenticated state

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}ticket-details/$userId/$ticketToken'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load ticket details');
      }
    } catch (error) {
      // Handle error
      print('Error fetching ticket details: $error');
      return {}; // Return an empty map on error
    }
  }

  Future<List<Map<String, dynamic>>> fetchTicketMessages(String ticketToken) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return []; // Handle unauthenticated state

    final url = '${AppConfig.apiUrl}getmessages';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'ticket_token': ticketToken}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((message) => {
          'dateTime': message['date_time'],
          'message': message['message'],
          'author': message['author'],
        }).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (error) {
      print('Error fetching messages: $error');
      return []; // Return an empty list on error
    }
  }
}
