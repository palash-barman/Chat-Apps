
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/HomeScreen/home_screen.dart';
import 'package:chat_app/SignUpScreen/Controller/sign_up_controller.dart';
import 'package:chat_app/utils/constent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ProfileController extends GetxController{
  final SignUpController _signUpController=Get.put(SignUpController());
  TextEditingController fullNameController = TextEditingController();
  RxBool isLoading = false.obs;


  @override
  void dispose() {
    // TODO: implement dispose
    fullNameController.dispose();
    super.dispose();
  }
   var  imageFile="".obs;

  void selectImage(ImageSource source)async{
    XFile? pickedFile= await ImagePicker().pickImage(source: source);

    if(pickedFile!=null){
     cropImage(pickedFile);
     // imageFile.value=pickedFile.path;
    }

    }

  void cropImage(XFile file) async{
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20


    );

    if(croppedFile!=null){
      imageFile.value=croppedFile.path;
    }
  }



  void showPhotoOption(BuildContext context){
    Get.dialog(AlertDialog(
      title: Text("Upload Profile Picture",style: TextStyle(fontSize: 14.sp,color: textcolors,fontWeight: FontWeight.w700),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          ListTile(
            onTap: () {
              selectImage(ImageSource.gallery);
              Navigator.pop(context);
            },
            horizontalTitleGap: 0,
            leading: Icon(Icons.photo_album,size: 5.w,),
            title: Text("Select from Gallery",style:  TextStyle(fontSize: 14.sp,color: textcolors,)),
          ),

          ListTile(
            onTap: () {
              Navigator.pop(context);
              selectImage(ImageSource.camera);

            },
            horizontalTitleGap: 0,
            leading: Icon(Icons.camera_alt,size: 5.w,),
            title: Text("Take a photo",style:  TextStyle(fontSize: 14.sp,color: textcolors),),
          ),

        ],
      ),
    ));


  }





  void checkValues(BuildContext context) {
    String fullName = fullNameController.text.trim();

    if(fullName == "" || imageFile.isEmpty) {
      Fluttertoast.showToast(msg:"Please fill all the fields");
      print("Please fill all the fields");
    }
    else {
      log("Uploading data..");
      isLoading.value=true;
      uploadData(context);
    }
  }


  void uploadData(BuildContext context) async {


    UploadTask uploadTask = FirebaseStorage.instance.ref("profileImage").child(_signUpController.newUser.uid.toString()).putFile(File(imageFile.value));

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullName = fullNameController.text.trim();

    _signUpController.newUser.name = fullName;
    _signUpController.newUser.profilePic = imageUrl;

    await FirebaseFirestore.instance.collection("users").doc(_signUpController.newUser.uid).set(_signUpController.newUser.toMap()).then((value) {
      log("Data uploaded!");
      fullNameController.clear();
      imageFile("");
      isLoading.value=false;
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomeScreen(userModel:_signUpController.newUser, user:_signUpController.userCredential.user!,);
        }),
      );
    });
  }


}