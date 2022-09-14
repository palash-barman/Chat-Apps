import 'package:chat_app/Model/chat_room_model.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  TextEditingController searchTextController = TextEditingController();

  var userList = <UserModel>[];
  var filterList = <UserModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }

  void getData() async {
    isLoading.value = true;
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        userList.clear();
        value.docs.forEach((word) {

          if (word['uid'] != user!.uid) {
            userList.add(UserModel(
                name: word['name'],
                email: word["email"],
                uid: word["uid"],
                profilePic: word["profilePic"],
                phone: word["phone"]));
          }
        });

      }).catchError((error) {
        isLoading.value = false;
      });
    } on Exception catch (e) {
      isLoading.value = false;
      print("Error");
      // TODO
    } finally {
      filterList.value = userList;
      print(filterList.value.length);
      isLoading.value = false;
    }
  }

  void filterUser(String value) {
    List<UserModel> result = <UserModel>[].obs;
    if (value.isEmpty) {
      result = userList;
    } else {
      result = userList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())  || element.email.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();


    }
    filterList.value = result;
  }



  Future<ChatRoomModel?> getChatroomModel(
      UserModel targetUser, UserModel currentUserModel) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${currentUserModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatRoom;
    } else {
      ChatRoomModel newChatRoom =
          ChatRoomModel(chatroomId: uuid.v1(), lastMessage: "", participants: {
        currentUserModel.uid.toString(): true,
        targetUser.uid.toString(): true,
      });
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chatroomId)
          .set(newChatRoom.toMap());
      chatRoom = newChatRoom;
    }

    return chatRoom;
  }
}
