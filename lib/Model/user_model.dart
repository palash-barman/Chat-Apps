import 'package:flutter/material.dart';

class UserModel{
String? name;
String? uid;
String? status;
String? phone;
String? email;
String? password;
String? profilePic;

UserModel({this.status, this.name, this.uid,this.email, this.password, this.phone,this.profilePic});

UserModel.fromMap(Map<String , dynamic> map ) {
  name= map["name"];
  uid =map["uid"];
  phone=map["phone"];
  email=map["email"];
  password=map["password"];
  profilePic =map["profilePic"];
  status =map["status"];
}


Map<String ,dynamic> toMap(){
  return {
    "name":name,
    "uid":uid,
    "phone":phone,
    "email":email,
    "password":password,
    "profilePic":profilePic,
    "status":status,

  };
}


}