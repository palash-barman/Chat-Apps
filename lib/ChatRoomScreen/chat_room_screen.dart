import 'package:chat_app/ChatRoomScreen/Controller/chatroom_controller.dart';
import 'package:chat_app/HomeScreen/home_screen.dart';
import 'package:chat_app/Model/message_model.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/utils/constent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../Model/chat_room_model.dart';

class ChatRoomScreen extends StatelessWidget {
  ChatRoomScreen(
      {Key? key,
      required this.chatRoomModel,
      required this.userModel,
      required this.firebaseUser,
      required this.targetModel})
      : super(key: key);

  UserModel targetModel;
  UserModel userModel;
  User firebaseUser;
  ChatRoomModel chatRoomModel;

  final ChatRoomController _controller = Get.put(ChatRoomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFF0D2646),
            leadingWidth: 8.w,
            title: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(targetModel.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 16.sp,
                          backgroundImage:
                              NetworkImage(targetModel.profilePic.toString()),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(targetModel.name.toString()),
                            Text(
                              snapshot.data!["status"],
                              style: TextStyle(
                                  fontSize: 8.sp, color: Colors.white70),
                            ),
                          ],
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                })),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(chatRoomModel.chatroomId)
                        .collection("messages")
                        .orderBy("time", descending:false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {

                          if (snapshot.data!.docs.isNotEmpty) {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                reverse:false,
                                controller: PageController(initialPage:snapshot.data!.docs.length),
                                itemBuilder: (context, index) {
                                  MessageModel currentMessage =
                                      MessageModel.fromMap(
                                          snapshot.data!.docs[index].data()
                                              as Map<String, dynamic>);
                                  return currentMessage.type == "text"
                                      ? textSend(
                                          context: context,
                                          message: currentMessage.message
                                              .toString(),
                                          sendBy: currentMessage.sender ==
                                              userModel.uid,
                                    image: currentMessage.sender == userModel.uid?userModel.profilePic.toString():targetModel.profilePic.toString(),
                                        )
                                      : imageSend(context, currentMessage,currentMessage.sender == userModel.uid, currentMessage.sender == userModel.uid?userModel.profilePic.toString():targetModel.profilePic.toString(),);
                                });
                          } else {
                            return Center(
                              child: Text(
                                "Say hi to your new friend",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                "An error occured? Please check your internet connection"),
                          );
                        } else {
                          return const Center(
                            child: Text(
                              "Say hi to your new friend",
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }
                      } else {
                        return Center(
                          child: SizedBox(
                              height: 10.w,
                              width: 10.w,
                              child: const CircularProgressIndicator()),
                        );
                      }
                    }),
              ),
            ),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 2.w,
                  ),
                  Flexible(
                    child: TextField(
                      maxLines: null,
                      controller: _controller.sendTextController,
                      decoration: const InputDecoration(
                          hintText: "Message", border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  IconButton(
                      onPressed: () {
                        _controller.getImage(userModel, chatRoomModel);
                      },
                      icon: const Icon(Icons.image)),
                  IconButton(
                      onPressed: () async {
                        _controller.messageSent(userModel, chatRoomModel);
                        await FirebaseMessaging.instance
                            .subscribeToTopic('myTopic');
                      },
                      icon: Icon(
                        Icons.send,
                        color:bgColors,
                      ))
                ],
              ),
            )
          ],
        ));
  }

  Widget imageSend(BuildContext context, MessageModel currentMessage,bool sendBy,String image) {
    return Row(
      mainAxisAlignment: sendBy?MainAxisAlignment.end:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.end,
      children: [
        sendBy==false?Padding(
          padding:  EdgeInsets.only(right: 0.5.w),
          child: CircleAvatar(
            radius: 2.w,
            backgroundImage:NetworkImage(image),
          ),
        ):Container(),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ShowImage(imageUrl: currentMessage.message!)));
          },
          child: Container(
            height: 15.h,
            width: 45.w,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400,width: 1),
              borderRadius: BorderRadius.circular(1.w),

            ),
            child: currentMessage.message != ""
                ? Image.network(
                    currentMessage.message!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: SizedBox(
                        height: 10.w,
                        width: 10.w,
                        child: const CircularProgressIndicator())),
          ),
        ),
        sendBy==true?Padding(
          padding:  EdgeInsets.only(left: 0.5.w),
          child: CircleAvatar(
            radius: 2.w,
            backgroundImage:NetworkImage(image),
          ),
        ):Container(),
      ],
    );
  }

  Widget textSend(
      {required String message,
      required bool sendBy,
      required BuildContext context,required String image}) {
    return Row(
      mainAxisAlignment: sendBy?MainAxisAlignment.end:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.end,
      children: [
        sendBy==false?Padding(
          padding:  EdgeInsets.only(right: 0.5.w),
          child: CircleAvatar(
            radius: 2.w,
            backgroundImage:NetworkImage(image),
          ),
        ):Container(),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
                color: sendBy
                    ? Colors.purple.withOpacity(0.7)
                    : Colors.grey.withOpacity(0.7),
                borderRadius: sendBy
                    ? BorderRadius.only(
                        topLeft: Radius.circular(2.w),
                        topRight: Radius.circular(2.w),
                        bottomLeft: Radius.circular(2.w),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(2.w),
                        topRight: Radius.circular(2.w),
                        bottomRight: Radius.circular(2.w),
                      )),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        sendBy==true?Padding(
          padding:  EdgeInsets.only(left: 0.5.w),
          child: CircleAvatar(
            radius: 2.w,
            backgroundImage:NetworkImage(image),
          ),
        ):Container(),
      ],
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
