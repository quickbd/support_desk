import 'package:flutter/material.dart';
import 'package:support_desk/global_widgets/custom_appbar.dart';
import 'package:support_desk/global_widgets/custom_field.dart';
import 'package:get/get.dart';
import 'package:support_desk/views/auth/setup/setup_view.dart';
import '../../../global_widgets/custom_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Register",
        action: [
          const Icon(Icons.search, color: Colors.black),
        ],
        hideLeading: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/PayPal.png',
                width: 170.0,
              ),
                Column(
                children: [
                  const CustomField(title: "Email Address"),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const CustomField(title: "Password", secured: true),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomButton(
                    title: "Sign Up",
                    onTap: () => Get.to(() =>  ProfileSetupView()),
                  ),
                ],
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
