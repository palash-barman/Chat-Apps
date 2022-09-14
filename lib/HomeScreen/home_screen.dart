import 'package:chat_app/ChatRoomScreen/chat_room_screen.dart';
import 'package:chat_app/FirebaseHelper/firebase_helper.dart';
import 'package:chat_app/LogInScreen/Controller/login_controller.dart';
import 'package:chat_app/Model/chat_room_model.dart';
import 'package:chat_app/SearchScreen/Controller/search_controller.dart';
import 'package:chat_app/SearchScreen/search_screen.dart';
import 'package:chat_app/Widget/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Model/user_model.dart';

class HomeScreen extends StatefulWidget {
  UserModel userModel;
  User user;

  HomeScreen({Key? key, required this.user, required this.userModel})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final LoginController _loginController = Get.put(LoginController());
  final SearchController _searchController = Get.put(SearchController());
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _fireStore
        .collection('users')
        .doc(widget.user.uid)
        .update({"status": status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
      print("userOnline: online");
    } else {
      setStatus("Offline");
      print("userOffline : offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2646),
      appBar: AppBar(
        toolbarHeight: 6.h,
        elevation: 0,
        backgroundColor: const Color(0xFF0D2646),
        title: Text(
          "Message",
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _loginController.signOut(context);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SearchScreen(
                        userModel: widget.userModel,
                        firebaseUser: widget.user,
                      )));
        },
        backgroundColor: const Color(0xFF0D2646),
        child: Icon(
          Icons.search,
          size: 20.sp,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // search bar
            SizedBox(
              height: 4.h,
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: TextField(
                      cursorColor: const Color(0xFF0D2646),
                      autocorrect: false,
                      enableSuggestions: false,
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF0D2646),
                          decoration: TextDecoration.none),
                      decoration: InputDecoration(
                          filled: true,
                          hoverColor: Colors.yellow,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1.2.h, horizontal: 3.w),
                          fillColor: Colors.white,
                          isDense: true,
                          focusColor: Colors.red,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.w)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.w)),
                          hintText: "Search ",
                          hintStyle: TextStyle(
                              fontSize: 12.sp, color: const Color(0xFF0D2646)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.w))),
                    ),
                  )),
                  IconButton(
                      padding: EdgeInsets.only(right: 15.w),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            // active user
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: SizedBox(
                height: 6.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 1.w),
                      child: CircleAvatar(
                        radius: 20.sp,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: const Color(0xFF0D2646),
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot snapshotData =
                                snapshot.data as QuerySnapshot;
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshotData.docs.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, index) {

                                  UserModel userdata = UserModel.fromMap(
                                      snapshotData.docs[index].data()
                                          as Map<String, dynamic>);
                                  if ( userdata.status=="Online" &&userdata.uid !=FirebaseAuth.instance.currentUser!.uid){
                                    return InkWell(
                                      onTap: ()async {
                                        ChatRoomModel? chatroomModel =
                                            await _searchController.getChatroomModel(
                                            userdata,
                                            widget.userModel);
                                        if(chatroomModel!=null){
                                          Navigator.push(context,MaterialPageRoute(
                                                  builder: (_) => ChatRoomScreen(
                                                      chatRoomModel:
                                                      chatroomModel,
                                                      userModel: widget
                                                          .userModel,
                                                      firebaseUser:
                                                      widget.user,
                                                      targetModel:
                                                      userdata)));
                                        }



                                      },

                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: 1.w),
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 18.sp,
                                              backgroundImage: NetworkImage(
                                                  userdata.profilePic.toString()),
                                            ),
                                            Positioned(
                                              bottom: 1.w,
                                              right: 1.w,
                                              child: Container(
                                                width: 2.5.w,
                                                height: 2.5.w,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF31A24C),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          } else {
                            return Container();
                          }
                        }),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("chatrooms")
                          .where("participants.${widget.userModel.uid}",
                              isEqualTo: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot chatroomSnapshot =
                              snapshot.data as QuerySnapshot;
                          if (snapshot.data != null) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: chatroomSnapshot.docs.length,
                                itemBuilder: (context, index) {
                                  ChatRoomModel chatRoomModel =
                                      ChatRoomModel.fromMap(
                                          chatroomSnapshot.docs[index].data()
                                              as Map<String, dynamic>);
                                  Map<String, dynamic> participants =
                                      chatRoomModel.participants!;
                                  List<String> participantKeys =
                                      participants.keys.toList();
                                  participantKeys.remove(widget.userModel.uid);

                                  return FutureBuilder(
                                      future: FirebaseHelper.getUserModel(
                                          participantKeys[0]),
                                      builder: (context, userData) {
                                        if (userData.connectionState ==
                                            ConnectionState.done) {
                                          if (userData.data != null) {
                                            UserModel targetModal =
                                                userData.data as UserModel;

                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => ChatRoomScreen(
                                                            chatRoomModel:
                                                                chatRoomModel,
                                                            userModel: widget
                                                                .userModel,
                                                            firebaseUser:
                                                                widget.user,
                                                            targetModel:
                                                                targetModal)));
                                              },
                                              child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("users")
                                                    .doc(targetModal.uid)
                                                    .snapshots(),
                                                builder: (BuildContext
                                                    context,
                                                    AsyncSnapshot<dynamic>
                                                    snapshot){
                                                  if(snapshot.hasData){
                                                    return   snapshot.data![
                                                    "status"] ==
                                                        "Offline"? Padding(
                                                          padding:  EdgeInsets.symmetric(horizontal: 1.w),
                                                          child: CircleAvatar(
                                                      radius: 20.sp,
                                                      backgroundImage: NetworkImage(
                                                            targetModal.profilePic
                                                                .toString()),
                                                    ),
                                                        ):Container();
                                                  }else{
                                                    return Container();
                                                  }
                                                }

                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        } else {
                                          return Container();
                                        }
                                      });
                                });
                          } else {
                            return Container();
                          }
                        } else if (!snapshot.hasData) {
                          return  Container();
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.w),
                        topRight: Radius.circular(5.w))),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .where("participants.${widget.userModel.uid}",
                          isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot chatroomSnapshot =
                          snapshot.data as QuerySnapshot;
                      if (snapshot.data != null) {
                        return ListView.builder(
                            itemCount: chatroomSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              ChatRoomModel chatRoomModel =
                                  ChatRoomModel.fromMap(
                                      chatroomSnapshot.docs[index].data()
                                          as Map<String, dynamic>);
                              Map<String, dynamic> participants =
                                  chatRoomModel.participants!;

                              List<String> participantKeys =
                                  participants.keys.toList();
                              participantKeys.remove(widget.userModel.uid);

                              return FutureBuilder(
                                  future: FirebaseHelper.getUserModel(
                                      participantKeys[0]),
                                  builder: (context, userData) {
                                    if (userData.connectionState ==
                                        ConnectionState.done) {
                                      if (userData.data != null) {
                                        UserModel targetModal =
                                            userData.data as UserModel;

                                        return ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ChatRoomScreen(
                                                            chatRoomModel:
                                                                chatRoomModel,
                                                            userModel: widget
                                                                .userModel,
                                                            firebaseUser:
                                                                widget.user,
                                                            targetModel:
                                                                targetModal)));
                                          },
                                          title:
                                              Text(targetModal.name.toString()),
                                          subtitle: chatRoomModel.lastMessage
                                                      .toString() !=
                                                  ""
                                              ? Text(chatRoomModel.lastMessage
                                                  .toString())
                                              : const Text(
                                                  "Say hi to your new friend",
                                                ),
                                          leading: Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 20.sp,
                                                backgroundImage: NetworkImage(
                                                    targetModal.profilePic
                                                        .toString()),
                                              ),
                                              Positioned(
                                                  top: 2.w,
                                                  child: StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection("users")
                                                        .doc(targetModal.uid)
                                                        .snapshots(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<dynamic>
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Container(
                                                          width: 2.5.w,
                                                          height: 2.5.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: snapshot.data![
                                                                        "status"] ==
                                                                    "Online"
                                                                ? const Color(0xFF31A24C)
                                                                : Colors
                                                                    .transparent,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  )),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    } else {
                                      return Container();
                                    }
                                  });
                            });
                      } else {
                        return const Center(
                          child: Text(
                            "No Chat",
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          "No Chat",
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          color: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
