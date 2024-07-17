import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:support_desk/global_widgets/custom_appbar.dart';
import 'package:support_desk/global_widgets/custom_button.dart';
import 'package:support_desk/global_widgets/custom_field.dart';
import 'package:support_desk/views/send_money/amount_view.dart';

class ReceiverView extends StatelessWidget {
  const ReceiverView({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar:  customAppBar(title:'Send Money'),
      body:   Padding(
        padding:     const EdgeInsets.all(5.0),
        child:   Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              const CustomField(title: 'Enter Receiver Email address'),
            CustomButton(
              title: 'Send',
              onTap:()=>Get.to(()=>const AmountView()),
            ),
          ],
        ),
      )
    );
  }
}
