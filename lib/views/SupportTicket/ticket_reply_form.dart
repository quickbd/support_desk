import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../utils/config.dart';

class TicketReplyFormScreen extends StatefulWidget {
  final String ticketId; // Hidden ticket ID field

  const TicketReplyFormScreen({Key? key, required this.ticketId}) : super(key: key);

  @override
  TicketReplyFormScreenState createState() =>  TicketReplyFormScreenState();
}

class  TicketReplyFormScreenState extends State<TicketReplyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  String? _attachmentPath;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getString('userId');

      if (token == null || userId == null) return; // Handle unauthenticated state

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.apiUrl}submit-ticket'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['userId'] = userId!;
      request.fields['ticketId'] = widget.ticketId;
      request.fields['details'] = _detailsController.text;

      if (_attachmentPath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'attachment',
          _attachmentPath!,
        ));
      }

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ticket submitted successfully')),
          );
          Navigator.pop(context);
        } else {
          throw Exception('Failed to submit ticket');
        }
      } catch (error) {
        print('Error submitting ticket: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting ticket')),
        );
      }
    }
  }

  Future<void> _selectAttachment() async {
    // Add logic to handle file selection here
    // For example, use FilePicker or other packages to select a file
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Details',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectAttachment,
                child: const Text('Select Attachment'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
