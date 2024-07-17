import 'package:get/get.dart';

class NavBarController extends GetxController{
 RxInt currentIndex = RxInt(0);  // 0.obs;

  changeIndex(int index){
    currentIndex.value = index;
    update();
  }
}