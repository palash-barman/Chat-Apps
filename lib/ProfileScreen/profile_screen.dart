import 'dart:developer';
import 'dart:io';

import 'package:chat_app/HomeScreen/home_screen.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/ProfileScreen/Controller/profile_controller.dart';
import 'package:chat_app/Widget/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({Key? key,
      required this.firebaseUser,required this.userModel

   }) : super(key: key);

  UserModel userModel;
  final User firebaseUser;

   final ProfileController _controller = Get.put(ProfileController());

   //
   //
   // void checkValues(BuildContext context) {
   //   String fullName = _controller.fullNameController.text.trim();
   //
   //   if(fullName == "" || _controller.imageFile.isEmpty) {
   //     print("Please fill all the fields");
   //   }
   //   else {
   //     log("Uploading data..");
   //     uploadData(context);
   //   }
   // }
   //
   //
   // void uploadData(BuildContext context) async {
   //
   //
   //   UploadTask uploadTask = FirebaseStorage.instance.ref("profileImage").child(userModel.uid.toString()).putFile(File(_controller.imageFile.value));
   //
   //   TaskSnapshot snapshot = await uploadTask;
   //
   //   String? imageUrl = await snapshot.ref.getDownloadURL();
   //   String? fullName = _controller.fullNameController.text.trim();
   //
   //   userModel.name = fullName;
   //   userModel.profilePic = imageUrl;
   //
   //   await FirebaseFirestore.instance.collection("users").doc(userModel.uid).set(userModel.toMap()).then((value) {
   //     log("Data uploaded!");
   //     Navigator.popUntil(context, (route) => route.isFirst);
   //     Navigator.pushReplacement(
   //       context,
   //       MaterialPageRoute(builder: (context) {
   //         return HomeScreen(userModel:userModel, user:firebaseUser,);
   //       }),
   //     );
   //   });
   // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              SizedBox(height: 5.h,),
              Obx(()=>InkWell(
                  onTap:(){
                    _controller.showPhotoOption(context);
                  },
                  child:_controller.imageFile.value==""? CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius:58..w,
                    child: Center(child: Icon(Icons.person,size:20.w,color: Colors.white,)),
                  ):CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius:18.w,
                    backgroundImage:FileImage(File(_controller.imageFile.value)) ,
                    // child:Image.file(File(_controller.imageFile.value)),
                ),
              ),
              ),
              SizedBox(height: 5.h,),
              CustomTextField(hintText:"Full Name",
                controller:_controller.fullNameController,
              ),

              SizedBox(height: 5.h,),
              InkWell(
                onTap:(){
                  _controller.checkValues(context);
                },
                child: Obx(()=>Container(
                    height: 7.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 252, 216, 134),
                            Color(0xFFFEA23B),
                          ],
                          stops: [
                            0.0,
                            1.0
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                          tileMode: TileMode.repeated),
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 3.w,),

                        _controller.isLoading.value?SizedBox(
                          height: 5.w,
                          width: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth:0.5.w,
                            color: Colors.white,
                          ),
                        ):Container(),


                      ],
                    ),
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}