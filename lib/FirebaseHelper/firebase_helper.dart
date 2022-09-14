import 'package:chat_app/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseHelper{
  static Future<UserModel?> getUserModel(String uid)async{
    UserModel? userModel ;

   DocumentSnapshot documentSnapshot=  await FirebaseFirestore.instance.collection("users").doc(uid).get();
  if(documentSnapshot.data()!=null){
    userModel = UserModel.fromMap(documentSnapshot.data() as Map<String,dynamic>);

    return userModel;

  }
  return null;

  }



}