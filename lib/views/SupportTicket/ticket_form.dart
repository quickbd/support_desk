import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../utils/config.dart';
import '../../providers/department_provider.dart';
import '../../providers/priority_provider.dart';

class TicketFormScreen extends StatefulWidget {
  const TicketFormScreen({Key? key}) : super(key: key);

  @override
  TicketFormScreenState createState() => TicketFormScreenState();
}

class TicketFormScreenState extends State<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final List<String> _attachmentPaths = [];
  int? _selectedDepartmentId;
  String? _selectedPriority;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final departmentProvider = Provider.of<DepartmentProvider>(context, listen: false);
    final priorityProvider = Provider.of<PriorityProvider>(context, listen: false);

    await departmentProvider.fetchDepartments();
    await priorityProvider.fetchPriorities();

    setState(() {
      _selectedDepartmentId = departmentProvider.departments.isNotEmpty
          ? departmentProvider.departments[0]['id']
          : null;
      _selectedPriority = priorityProvider.priorities.isNotEmpty
          ? priorityProvider.priorities.keys.first
          : null;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getString('userId');

      if (token == null || userId == null) {
        _showSnackBar('Unauthenticated: Unable to submit ticket');
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.apiUrl}submit-ticket'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['userId'] = userId!;
      request.fields['subject'] = _subjectController.text;
      request.fields['departmentId'] = _selectedDepartmentId?.toString() ?? '';
      request.fields['priority'] = _selectedPriority ?? '';
      request.fields['details'] = _detailsController.text;

      for (String path in _attachmentPaths) {
        request.files.add(await http.MultipartFile.fromPath('attachments[]', path));
      }

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          _showSnackBar('Ticket submitted successfully');
          _handleNavigation(true);
        } else {
          _showSnackBar('Failed to submit ticket');
        }
      } catch (error) {
        _showSnackBar('Error submitting ticket: $error');
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _handleNavigation(bool shouldPop) {
    if (shouldPop) {
      Navigator.pop(context);
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _selectAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _attachmentPaths.addAll(result.paths.whereType<String>());
      });
    } else {
      _showSnackBar('No file selected');
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachmentPaths.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final departmentProvider = Provider.of<DepartmentProvider>(context);
    final priorityProvider = Provider.of<PriorityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Ticket')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedDepartmentId,
                  decoration: const InputDecoration(labelText: 'Department'),
                  items: departmentProvider.departments.map((department) {
                    return DropdownMenuItem<int>(
                      value: department['id'], // Ensure this is an integer
                      child: Text(department['title']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartmentId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a department';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: priorityProvider.priorities.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a priority';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  height: 150, // Fixed height for details box
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: TextField(
                    controller: _detailsController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your ticket details...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _selectAttachment,
                  child: const Text('Select Attachment'),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _attachmentPaths.length,
                  itemBuilder: (context, index) {
                    final filePath = _attachmentPaths[index];
                    final fileName = filePath.split('/').last;

                    return ListTile(
                      title: Text(fileName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeAttachment(index),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _isSubmitting
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}