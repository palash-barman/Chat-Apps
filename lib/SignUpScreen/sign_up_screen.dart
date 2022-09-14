import 'package:chat_app/SignUpScreen/Controller/sign_up_controller.dart';
import 'package:chat_app/Widget/custom_textfield.dart';
import 'package:chat_app/utils/constent.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';


class SignUpScreen extends StatelessWidget {
 SignUpScreen({Key? key}) : super(key: key);
  final SignUpController _controller=Get.put(SignUpController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor:const Color(0xFFFFFFFF),
      body: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                padding: EdgeInsets.only(top:3.h,left: 3.w),
                iconSize: 25.sp,
                icon: const Icon(Icons.keyboard_backspace,color: Colors.grey,)),
              const Spacer(),
              Image.asset(
                "assets/image/auth_image.png",
                fit: BoxFit.fill,
                width: 55.w,
                height: 20.h,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Form(
              key:_controller.fromKey ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(height: 4.h,),
                  Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 28.sp,
                        color:textcolors,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),

                  // name textfield
                  CustomTextField(
                    controller: _controller.nameController,
                    keyboardType: TextInputType.name,
                    hintText: "Name",
                    preffixIcon: const Icon(Icons.person),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Field is Empty";
                    }
                    return null;
                  },
                  ),
                  SizedBox(
                    height: 3.h,
                  ),

                  // phone text field
                  CustomTextField(
                    controller: _controller.phoneController,
                    keyboardType: TextInputType.number,
                    hintText: "Phone Number",
                    preffixIcon: const Icon(Icons.call),
                    validator: (value){
                    if(value!.isEmpty){
                      return "Field is Empty";
                    }
                    return null;
                    }
                  ),
                  SizedBox(
                    height: 3.h,
                  ),

                  // email text field
                  CustomTextField(
                    controller:_controller.emailController,
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
                 
                 SizedBox(height: 3.h,),
                 Obx(
                    () => CustomTextField(
                      validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field is empty ';
                              } else if (value !=
                                  _controller.passwordController.text) {
                                return "Password not match";
                              }
                              return null;
                            },
                      controller: _controller.confirmPasswordController,
                      hintText: "Confirm password",
                      obscureText: _controller.isVisibility.value ? true : false,
                      preffixIcon: const Icon(Icons.lock),
                      // suffixIcon: InkWell(
                      //     onTap: () {
                      //       _controller.isVisiable.value =
                      //           !_controller.isVisiable.value;
                      //     },
                      //     child: _controller.isVisiable.value
                      //         ? const Icon(
                      //             Icons.visibility_off,
                      //           )
                      //         : const Icon(Icons.visibility)),
                    ),
                  ),
                 
                 
                 
                 
                
                  SizedBox(
                    height: 5.h,
                  ),
                  // sign up button
                  Center(
                    child: InkWell(
                      onTap: (){
                        if(_controller.fromKey.currentState!.validate()){
                          _controller.signUp(email:_controller.emailController.text.trim(), password:_controller.passwordController.text, context: context);
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
                                "SIGN UP ",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
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
      bottomNavigationBar:  Padding(
        padding:  EdgeInsets.symmetric(vertical: 3.h,horizontal: 4.w),
        child: Row(
          children: [
            const Spacer(),
            RichText(
                          text: TextSpan(
                              text: "Already  have a account? ",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.normal),
                              children: [
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color:const Color(0xFFFDA740),
                                  fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
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