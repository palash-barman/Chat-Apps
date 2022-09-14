import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({Key? key,
     this.onChanged,
     required this.hintText,this.keyboardType ,this.controller,this.preffixIcon,this.obscureText=false,this.validator,this.suffixIcon}) : super(key: key);
  String hintText;
  Widget? preffixIcon;
  Widget? suffixIcon;
  TextInputType? keyboardType;
  TextEditingController? controller;
  String? Function(String?)? validator;
  bool? obscureText;
  Function(String)? onChanged;
  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged:onChanged ,
      controller: controller,
      keyboardType:keyboardType,
      validator:validator,
      obscureText:obscureText!,
      style: TextStyle(fontSize:13.sp,color:const Color(0xFF6884BF,),fontWeight:FontWeight.normal),
      decoration:InputDecoration(
        hintText:hintText,
        hintStyle: TextStyle(fontSize:13.sp,color:const Color(0xFF061C42,).withOpacity(0.5),fontWeight:FontWeight.normal),
        suffixIcon: suffixIcon,
        prefixIcon:preffixIcon,
         border: OutlineInputBorder(borderSide: BorderSide(color:Color(0xFFD2D6D9) )),
            
         contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
         enabled: true,
         focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(1.w)),borderSide: const BorderSide(color:Color(0xFF496AA9))),
        enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(1.w)),borderSide:const BorderSide(
          color: Color(0xFFD2D6D9)
        )),
        disabledBorder: InputBorder.none,
      ),
      

    );
    
  }
}