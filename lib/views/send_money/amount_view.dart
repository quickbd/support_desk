import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:support_desk/global_widgets/custom_appbar.dart';
import 'package:support_desk/global_widgets/custom_button.dart';
import 'package:support_desk/global_widgets/custom_field.dart';
import 'package:support_desk/views/send_money/success_view.dart';

class AmountView extends StatelessWidget {
  const AmountView({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar:  customAppBar(title:'Send Money'),
      body:   Padding(
        padding:   const EdgeInsets.all(15),
        child:   Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.4),
                  ),
                  title: Text('To:....', style: TextStyle(
                    color: Colors.black.withOpacity(0.5)
                  ),),
                  subtitle:   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Md. H Zamil',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                         ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('hzamil@gmail.com',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.8)
                          )
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30,),
                const CustomField(title: 'Enter Amount', prefixIcon: Icons.attach_money_outlined, keyboardType: TextInputType.phone,),
              ],
            ),
            Column(
              children: [
                CustomButton(
                  title: 'Send',
                  onTap:()=>Get.offAll(()=>const SuccessView()),
                ),
              ],
            ),

          ],
        ),
      )
    );
  }
}
