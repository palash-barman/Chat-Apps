import 'package:chat_app/ChatRoomScreen/chat_room_screen.dart';
import 'package:chat_app/Model/chat_room_model.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/SearchScreen/Controller/search_controller.dart';
import 'package:chat_app/Widget/custom_textfield.dart';
import 'package:chat_app/utils/constent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);
  final UserModel userModel;
  final User firebaseUser;

  final SearchController _searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    _searchController.getData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2646),
        elevation: 0,
        title: Text(
          "Search Screen",
          style: TextStyle(fontSize: 18.sp, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            SizedBox(
              height: 3.h,
            ),
            CustomTextField(
                controller: _searchController.searchTextController,
                onChanged: (value) {
                  _searchController.filterUser(value);
                },
                hintText: "Search People"),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
                child: Obx(
              () =>_searchController.isLoading.value? Center(child: CircularProgressIndicator(),):_searchController.filterList.isEmpty
                  ? Text(
                      "No Result Found",
                      style: TextStyle(fontSize: 14.sp, color: textcolors),
                    )
                  : ListView.builder(
                      itemCount: _searchController.filterList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatroomModel =
                                await _searchController.getChatroomModel(
                                    _searchController.filterList[index],
                                    userModel);


                            if(chatroomModel!=null){
                              Get.off(ChatRoomScreen(chatRoomModel: chatroomModel, userModel: userModel, firebaseUser: firebaseUser, targetModel:_searchController.filterList[index]));
                              // Navigator.pop(context);
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (_) => ChatRoomScreen(
                              //           targetModel: _searchController
                              //               .filterList[index],
                              //           firebaseUser: firebaseUser,
                              //           chatRoomModel: chatroomModel,
                              //           userModel: userModel,
                              //         )));
                            }


                          },
                          title: Text(_searchController.filterList[index].name
                              .toString()),
                          subtitle: Text(_searchController
                              .filterList[index].email
                              .toString()),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(_searchController
                                .filterList[index].profilePic
                                .toString()),
                          ),
                        );
                      }),
            ))
          ],
        ),
      ),
    );
  }
}
