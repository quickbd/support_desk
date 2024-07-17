import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupController extends GetxController{
  File? pickedImage;
  Future imagePicker () async{
    try{
       final image = await ImagePicker().pickImage(source: ImageSource.gallery);

       if(image == null) return;
        final tempImage = File(image.path);

       pickedImage = tempImage;
       update();
       //print(pickedImage.path);
    }catch(e){
     // print('Error: ${e.toString()}');
    }

  }
}