import 'package:flutter/material.dart';
import 'package:support_desk/global_widgets/custom_button.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return   const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 60,),
              Text('Success!', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),),
              Text('\$500.50', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),),
              Text(
                  'has been sent to friend@gmail.com from your wallet.',
                  style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black45,
                  ),
              ),
              SizedBox(height: 20,),
             CustomButton(title: 'Done'),
            ],
          ),
        ),
      ),
    );
  }
}
