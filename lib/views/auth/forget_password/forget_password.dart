import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:support_desk/global_widgets/custom_appbar.dart';
import 'package:support_desk/global_widgets/custom_button.dart';
import 'package:support_desk/providers/auth_provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool _showPasswordFields = false;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _forgetPassword(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.requestPasswordReset(_mobileController.text);

    if (success) {
      setState(() {
        _showPasswordFields = true;
      });
      Get.snackbar('Success', 'Please enter your new password.');
    } else {
      Get.snackbar('Error', 'Failed to send reset request.');
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match.');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.resetPassword(
      _mobileController.text,
      _newPasswordController.text,
    );

    if (success) {
      Get.snackbar('Success', 'Password reset successful. Logging in...');
      final loginSuccess = await authProvider.loginWithNewPassword(
        _mobileController.text,
        _newPasswordController.text,
      );
      if (loginSuccess) {
        Get.offAllNamed('/dashboard');
      } else {
        Get.snackbar('Error', 'Failed to log in with the new password.');
      }
    } else {
      Get.snackbar('Error', 'Failed to reset password.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Forget Password",
        hideLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              if (!_showPasswordFields) ...[
                const Text(
                  'Enter your Registered Mobile Number',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  title: "Submit",
                  onTap: () => _forgetPassword(context),
                ),
              ] else ...[
                const Text(
                  'Enter your new password',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  title: "Reset Password",
                  onTap: () => _resetPassword(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}