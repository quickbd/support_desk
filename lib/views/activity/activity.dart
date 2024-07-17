import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:support_desk/global_widgets/custom_appbar.dart';
import 'package:support_desk/global_widgets/custom_list_tile.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(
          title: 'Activity',
        ),
      body: ListView.builder(
        itemCount: 30,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index){
        return const CustomListTile(
            title: 'Md. h Zamil',
            subtitle: '2 days ago',
            trailing: '-300',
        );


      },),
    );
  }
}
