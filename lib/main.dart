import 'package:chat_app/FirebaseHelper/firebase_helper.dart';
import 'package:chat_app/HomeScreen/home_screen.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import 'LogInScreen/login_screen.dart';
import 'ProfileScreen/profile_screen.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
var uuid = Uuid();
void main()async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

   FirebaseMessaging messaging = FirebaseMessaging.instance;
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     print('Got a message whilst in the foreground!');
     print('Message data: ${message.data}');

     if (message.notification != null) {
       print('Message also contained a notification: ${message.notification}');
     }
   });
  User? currentUser=FirebaseAuth.instance.currentUser;
  if(currentUser!=null){
    UserModel? thisUserModel=await FirebaseHelper.getUserModel(currentUser.uid);

    if(thisUserModel!=null){
      runApp(MyHomePage(user: currentUser, userModel: thisUserModel));


    }else{
      runApp(const MyApp());
    }

  }else{
    runApp(const MyApp());
  }



}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:  LogInScreen(),
        );
      }
    );
  }
}


class MyHomePage extends StatelessWidget {
   MyHomePage({Key? key,required this.user,required this.userModel}) : super(key: key);

    UserModel userModel;
    User user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home:  HomeScreen(userModel: userModel, user:user,),
          );
        }
    );
  }
}
