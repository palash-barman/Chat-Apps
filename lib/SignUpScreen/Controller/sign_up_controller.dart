import 'package:chat_app/LogInScreen/login_screen.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/ProfileScreen/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SignUpController extends GetxController{
  final fromKey=GlobalKey<FormState>();
  RxBool isLoading =false.obs;
  late UserModel newUser;
  late UserCredential userCredential;

TextEditingController emailController=TextEditingController();
TextEditingController passwordController= TextEditingController();
TextEditingController nameController=TextEditingController();
TextEditingController confirmPasswordController= TextEditingController();
TextEditingController phoneController= TextEditingController();


@override
  void dispose() {
      emailController.dispose();
      passwordController.dispose();
      phoneController.dispose();
      nameController.dispose();
      confirmPasswordController.dispose();
    super.dispose();
  }

   RxBool isVisibility =true.obs;




 void signUp({required BuildContext context, required String email, required String password})async{

  try{
    isLoading.value=true;
    userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String uid =userCredential.user!.uid;

         newUser=UserModel(
        name:nameController.text.trim(), 
        uid:uid, 
        email:email,
        password: password,
         phone:phoneController.text.trim(),
         status: "Unavailable",
         profilePic:"");
        
    await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value){
      isLoading.value=false;
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      phoneController.clear();
      Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(userModel:newUser, firebaseUser:userCredential.user!,)));
    });


  } on FirebaseAuthException catch(e){
    isLoading.value=false;
    if (e.code.toString() == 'email-already-in-use') {
        Get.snackbar("About Signup", "Signup Message",
            colorText:Colors.white,
            duration: const Duration(seconds:3),
            backgroundColor:Colors.red,
            margin:EdgeInsets.symmetric(vertical:2.h,horizontal:5.w),
            snackPosition: SnackPosition.BOTTOM,
            messageText: Text(
              " Email already used. Go to login page.",
              style: TextStyle(color:Colors.white, fontSize: 16.sp),
            ));
      }
  }




 }





}