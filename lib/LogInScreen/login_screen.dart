// ignore_for_file: unused_field

import 'package:chat_app/LogInScreen/Controller/login_controller.dart';
import 'package:chat_app/SignUpScreen/sign_up_screen.dart';
import 'package:chat_app/Widget/custom_textfield.dart';
import 'package:chat_app/utils/constent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(


    backgroundColor:const Color(0xFFFFFFFF),
      body: InkWell(
        onTap:(){
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            // image
            Row(
              children: [
                Spacer(),
                Image.asset(
                  "assets/image/auth_image.png",
                  fit: BoxFit.fill,
                  height: 23.h,
                  width: 65.w,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Form(
                key: _controller.fromKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 28.sp,
                          color:textcolors,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.h,),
                    Text(
                      "Please sign in to continue .",
                      style: TextStyle(
                          fontSize: 17.sp,
                          color:Color.fromARGB(255, 102, 101, 101),
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),

                  // email textfield
                    CustomTextField(
                      controller: _controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "aplapa@gmail.com",
                      preffixIcon: const Icon(Icons.email),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Field is Empty";
                          }else if(!value.contains("@")&&!value.contains(".")){
                            return "Enter valid email";
                          }
                          return null;
                        }
                    ),
                    SizedBox(
                      height: 3.h,
                    ),

                   // password textfield
                    Obx(
                      () => CustomTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field is empty ';
                          } else if (value.length < 6) {
                            return "password minimum 6 character";
                          }
                          return null;
                        },
                        controller: _controller.passwordController,
                        hintText: "password",
                        obscureText: _controller.isVisibility.value ? true : false,
                        preffixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                            onTap: () {
                              _controller.isVisibility.value =
                                  !_controller.isVisibility.value;
                            },
                            child: _controller.isVisibility.value
                                ? const Icon(
                                    Icons.visibility_off,
                                  )
                                : const Icon(Icons.visibility)),
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),

                 // reset password
                    Row(
                      children: [
                        Spacer(),
                        Text(
                          "Reset password",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFFFB9E34 ),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                  // sign in button
                    Center(
                      child: InkWell(
                        onTap:(){
                          if(_controller.fromKey.currentState!.validate()){
                            _controller.signIn(context);
                          }
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
                                  "SIGN IN ",
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
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:  Padding(
        padding:  EdgeInsets.symmetric(vertical: 3.h,horizontal: 4.w),
        child: Row(
          children: [
            const Spacer(),
            RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.normal),
                              children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color:const Color(0xFFFDA740),
                                  fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, CupertinoPageRoute(builder: (_)=>SignUpScreen()));
                                },
                            ),
                          ])),
        
        const Spacer(),
          ],
        ),
      )
              ,




     
    );
  }
}
