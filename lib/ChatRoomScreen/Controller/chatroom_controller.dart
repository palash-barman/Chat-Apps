import 'dart:convert';
import 'dart:io';

import 'package:chat_app/Model/chat_room_model.dart';
import 'package:chat_app/Model/message_model.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatRoomController extends GetxController {

  TextEditingController sendTextController = TextEditingController();
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;
  var userToken="".obs;
  File? imageFile;




  @override
  void onInit() {
    // TODO: implement onInit
    getToken();
    super.onInit();
  }

  void messageSent(UserModel userModel, ChatRoomModel chatroom) async {
    String msg = sendTextController.text.trim();
    String messageId=const Uuid().v1();
    sendTextController.clear();
    if (msg != "") {
      MessageModel newMessage = MessageModel(
        type: "text",
        sender: userModel.uid,
        time: DateTime.now(),
        message: msg,
        seen: false,
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(
          chatroom.chatroomId).collection("messages").doc(messageId).set(newMessage.toMap()).then((value){
        callOnFcmApiSendPushNotifications( message:msg);
      });
      chatroom.lastMessage=msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(chatroom.chatroomId).set(chatroom.toMap());

    }
  }

  Future getImage(UserModel userModel, ChatRoomModel chatroom)async{
    ImagePicker picker=ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((xFile){
      if(xFile!=null){
        imageFile=File(xFile.path);
        uploadImage(userModel, chatroom);
      }

    });


  }
  Future  uploadImage(UserModel userModel, ChatRoomModel chatroom)async{
   // String msg = sendTextController.text.trim();
    String fileName=const Uuid().v1();
    int status=1;

      MessageModel newMessage = MessageModel(
        type: "img",
        sender: userModel.uid,
        time: DateTime.now(),
        message: "",
        seen: false,
      );

    await _fireStore.collection("chatrooms").doc(
        chatroom.chatroomId).collection("messages").doc(fileName).set(newMessage.toMap()).then((value){
      callOnFcmApiSendPushNotifications( message:"image");
    });

    var ref=FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error)async{
      await _fireStore.collection("chatrooms").doc(
          chatroom.chatroomId).collection("messages").doc(fileName).delete();
      status=0;
    });
    if(status==1){
      String imageUrl=await uploadTask.ref.getDownloadURL();

      await _fireStore.collection("chatrooms").doc(
          chatroom.chatroomId).collection("messages").doc(fileName).update(
          {"message": imageUrl});
      print(imageUrl);

    }



  }



  

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
            (token) {
          userToken.value=token!;

        }
    );
  }

  Future<bool> callOnFcmApiSendPushNotifications(
      {required String message}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": "/topics/myTopic",
      "notification": {
        "title": "message",
        "body": message,
      },
      "data": {
        "type": '0rder',
        "id": '28',
        "click_action": 'FLUTTER_NOTIFICATION_CLICK',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
      'key=AAAAq4Jzrgs:APA91bHiHgICoJn7Zz_Vc00Mpa_6LtmEgEOBF1cqhXOtx8mGg-6G3pValaYADKk_qzXnD0KHlsh-fQNJ7C1K-nYyJ_5__iuI69m91Zaf1KuxRQXarMzpsrPU6MjEEuvryqQb1-IRaOk6'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  //
  //
  // static Future<void> sendNotificationToUser({required String message, required String token})async{
  //   await FirebaseFirestore.instance.collection("notification").get().then((value) async{
  //     final data = {
  //       "notification": {"body": message, "title": "Message"},
  //       "priority": "high",
  //       "data": {
  //         "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //         "id": "1",
  //         "status": "done",
  //         "navigate_type":"admin_apt_details",
  //       },
  //       "to": "$token"
  //     };
  //
  //     final headers = {
  //       'content-type': 'application/json',
  //       'Authorization': 'key=AAAAq4Jzrgs:APA91bHiHgICoJn7Zz_Vc00Mpa_6LtmEgEOBF1cqhXOtx8mGg-6G3pValaYADKk_qzXnD0KHlsh-fQNJ7C1K-nYyJ_5__iuI69m91Zaf1KuxRQXarMzpsrPU6MjEEuvryqQb1-IRaOk6'
  //     };
  //
  //
  //     BaseOptions options = new BaseOptions(
  //       connectTimeout: 5000,
  //       receiveTimeout: 3000,
  //       headers: headers,
  //     );
  //
  //
  //     try {
  //       final response = await Dio(options).post("https://fcm.googleapis.com/fcm/send",
  //           data: data);
  //
  //       if (response.statusCode == 200) {
  //         print("message sent");
  //       } else {
  //         print('notification sending failed');
  //         // on failure do sth
  //       }
  //     }
  //     catch(e){
  //       print('exception $e');
  //     }
  //   });
  // }
  //
  //




}