

import 'package:chat_app_firebase/cubit/cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCM{
//test branch
static  initializeMessage(context) async{
  var  cubit = ChatCubit.get(context);
   await   FirebaseMessaging.instance.getInitialMessage();
       FirebaseMessaging.onMessageOpenedApp.listen((event) {
        var uid =event.data['user_uid'];
         if (event.notification != null) {
           cubit.openMessageFcmFriendsChatScreen(context, uid);

         } });


   // FirebaseMessaging.onMessage.listen((event) {
   //
   //   defaultToastMessage(msg: 'Mina onMessage', state: ToastStates.success);
   //
   // });


   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   //
   //
    }



static  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
        // If you're going to use other Firebase services in the background, such as Firestore,
        // make sure you call `initializeApp` before using other Firebase services.
       // await Firebase.initializeApp();
        print("Handling a background message: ${message.messageId}");
      }



}