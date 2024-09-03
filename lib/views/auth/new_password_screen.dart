import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:support_desk/global_widgets/custom_button.dart';
import 'package:support_desk/global_widgets/custom_field.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword(BuildContext context) async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call your API to reset the password
      final response = await YourApi.resetPassword(
        newPassword: _newPasswordController.text,
      );

      if (response.success) {
        // Navigate to Login page on success
        Get.offAll(() => const LoginView());
      } else {
        _showErrorDialog('Failed to reset password. Please try again.');
      }
    } catch (error) {
      _showErrorDialog('An error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              CustomField(
                controller: _newPasswordController,
                title: "New Password",
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomField(
                controller: _confirmPasswordController,
                title: "Confirm Password",
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                title: "Reset Password",
                onTap: () => _resetPassword(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
