import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:support_desk/controllers/profile_setup_controller.dart';
import 'package:support_desk/global_widgets/custom_appbar.dart';
import 'package:support_desk/global_widgets/custom_button.dart';
import 'package:support_desk/global_widgets/custom_field.dart';
import 'package:support_desk/views/DashboardScreen/dashboard_screen.dart';


class ProfileSetupView extends StatelessWidget {
  ProfileSetupView({Key? key}) : super(key: key);

  final controller = Get.put(ProfileSetupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Complete Setup',
        hideLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        InkWell(
                          onTap: () => controller.imagePicker(),
                          child: controller.pickedImage == null
                              ? const CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                'https://static.vecteezy.com/system/resources/thumbnails/015/409/989/small/elegant-man-in-business-suit-with-badge-man-business-avatar-profile-picture-illustration-isolated-vector.jpg'),
                          )
                              : CircleAvatar(
                            radius: 60,
                            backgroundImage:
                            FileImage(controller.pickedImage!),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Column(
                  children: [
                    CustomField(title: "Your Full Name"),
                    SizedBox(height: 20),
                    CustomField(title: "Your Phone Number"),
                    SizedBox(height: 20),
                    CustomField(title: "Your NID Number"),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    CustomButton(
                      title: "Complete Setup",
                      onTap: () => Get.to(() => const DashboardScreen()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
