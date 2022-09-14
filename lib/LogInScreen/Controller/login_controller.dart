import 'package:chat_app/LogInScreen/login_screen.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../HomeScreen/home_screen.dart';

class LoginController extends GetxController{

TextEditingController emailController=TextEditingController();
TextEditingController passwordController= TextEditingController();

final fromKey=GlobalKey<FormState>();


@override
  void dispose() {
      emailController.dispose();
      passwordController.dispose();
    super.dispose();
  }

   RxBool isVisibility =true.obs;

RxBool isLoading =false.obs;

void signIn(BuildContext context)async{

  UserCredential userCredential;
  try{
    isLoading.value=true;
    userCredential =await FirebaseAuth.instance.signInWithEmailAndPassword(email:emailController.text.trim(), password:passwordController.text);

     await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).get().then((value){
       emailController.clear();
       passwordController.clear();
       isLoading.value=false;
      UserModel userModel =UserModel.fromMap(value.data() as Map<String, dynamic>);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen(userModel:userModel, user:userCredential.user!,)));

     });


  }on FirebaseAuthException catch(e){
    isLoading.value=false;
    if(e.code.toString()=="wrong-password"){
      Get.snackbar("About Login", "Login Message",
          colorText:Colors.white,
          duration: const Duration(seconds:3),
          backgroundColor:Colors.red,
          margin:EdgeInsets.symmetric(vertical:2.h,horizontal:5.w),
          snackPosition: SnackPosition.BOTTOM,
          messageText: Text(
            " Wrong Password",
            style: TextStyle(color:Colors.white, fontSize: 16.sp),
          ));
    }
    else if(e.code.toString()=="user-not-found"){

      Get.snackbar("About Login", "Login Message",
          colorText:Colors.white,
          duration: const Duration(seconds:3),
          backgroundColor:Colors.red,
          margin:EdgeInsets.symmetric(vertical:2.h,horizontal:5.w),
          snackPosition: SnackPosition.BOTTOM,
          messageText: Text(
            "No user found for that email ",
            style: TextStyle(color:Colors.white, fontSize: 16.sp),
          ));
    }




  }


}



void signOut(BuildContext context)async{
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  await FirebaseFirestore.instance.collection('users').doc(firebaseAuth.currentUser!.uid).update({"status":"Offline"});
  await firebaseAuth.signOut().then((value){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LogInScreen()));

  });


}





}