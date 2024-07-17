import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:support_desk/utils/colors.dart';

import '../../global_widgets/custom_home_item.dart';
import '../../global_widgets/custom_list_tile.dart';
import '../activity/activity.dart';
import '../send_money/receiver_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Header
          Container(
            height: size.height * .35,
            width: size.width,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Logo & Profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/favicon.png'),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 4,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('/assets/images/avater_img.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Name
                  Text(
                    'Hello Zamil',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                    ),
                  ),

                  //Balance
                  Column(
                    children: [
                      const Text(
                        '\$272.50',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Your Balance',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Main Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                          CustomHomeItem(
                          title: 'Send\nMoney',
                          icon: Icons.send,
                          onTab: ()=> Get.to(()=> const ReceiverView()),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        CustomHomeItem(
                          title: 'Add\nMoney',
                          icon: Icons.monetization_on,
                          backgroundColor: Colors.white,
                          itemColor: AppColors.primary ,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    //Activities

                    const SizedBox(height: 10,),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: ()=> Get.to(()=> const  ActivityView()),
                            child: const Text('Activity')),
                        InkWell(
                            onTap: ()=> Get.to(()=> const  ActivityView()),
                            child: const Text('View All')),
                      ],
                    ),
                    const SizedBox(height: 10,),
                         //Activation
                    ListView.builder(
                      padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: 15,
                        itemBuilder: (context, index){
                          return const CustomListTile(title: 'Md Hasanat Zamil', subtitle: '7 days ago', trailing: '+300', );
                        }
                    )
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
