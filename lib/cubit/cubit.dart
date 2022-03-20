import 'dart:convert';
import 'dart:io';

import 'package:chat_app_firebase/components/component.dart';
import 'package:chat_app_firebase/cubit/states.dart';
import 'package:chat_app_firebase/models/allFriendUserChatMode.dart';
import 'package:chat_app_firebase/models/allUsersMode.dart';
import 'package:chat_app_firebase/models/chat_message_model.dart';
import 'package:chat_app_firebase/models/message%20count.dart';
import 'package:chat_app_firebase/models/usermodel.dart';
import 'package:chat_app_firebase/screens/users_list_screen.dart';
import 'package:chat_app_firebase/screens/auth_screens/login_screen.dart';
import 'package:chat_app_firebase/screens/chat_list_screen.dart';
import 'package:chat_app_firebase/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../screens/chat__friends_screen_details.dart';
import '../screens/my_profile.dart';

class ChatCubit extends Cubit<ChatStates>{
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context)=> BlocProvider.of(context);

//mina
  Widget homeScreen(){
    if(_auth.currentUser != null){
      return const MainScreen();
    }else{
      return const LoginScreen();
    }

  }


  List<Widget> screens = [
     UsersScreen(),
     ChatListScreen(),
      MyProfile(),

  ];

  int index = 1;
  void currentIndex(index){
    this.index = index;
    emit(ChatCurrentIndexState());
  }

bool disableButton = false;

  void disableButtonProfileUpdate(){
    disableButton = true;
    emit(ChatDisableButtonProfileState());

  }
  void enableButtonProfileUpdate(){
    disableButton = false;
    emit(ChatEnableButtonProfileState());

  }


                         /////////////// firebase Auth /////////////
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;



void registerUser({
required  String username,
 required String email,
  required String phone,
  required String password,
  required context

}){

  _auth.createUserWithEmailAndPassword(
      email: email,
      password: password
  ).then((value) {
      FirebaseMessaging.instance.getToken().then((token){
      CurrentUserModel userModel=  CurrentUserModel(
          email: email,
          uid:_auth.currentUser!.uid.toString(),
          phone: phone,
          username: username,
          token: token.toString(),
          image:'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?t=st=1647275025~exp=1647275625~hmac=774390864f3aad84ce6435e8c7f126d56cc2050927f5504094501967bc14218c&w=900',
          bio:'New user',
          status: 'Online'
      );
      defaultToastMessage(
          msg: 'Sign Up Successful',
          state: ToastStates.success);
      _firestore.collection('users').doc(_auth.currentUser!.uid.toString()).set(userModel.toJson()).catchError((e) {
        print('error' + e);
      });
      if(_auth.currentUser != null ){
        navigateAndRemoveTo(route: const MainScreen(), context: context);
        print('true');
      }
      emit(ChatRegisterUserState());
    }).catchError(( ex){

      if (ex.code == 'weak-password') {
        defaultToastMessage(
            msg: 'The password provided is too weak.',
            state: ToastStates.error);
        print('The password provided is too weak.');
      } else if (ex.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        defaultToastMessage(
            msg: 'The account already exists for that email.',
            state: ToastStates.error);
      }else{
        defaultToastMessage(
            msg: ex.message,
            state: ToastStates.error);
      }
    });

    emit(ChatRegisterUserState());

    });

}

 loginUser({
  required String email,
  required String password,
   required context,
}){

  _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
  ).then((value) {

    if(_auth.currentUser != null ){
      defaultToastMessage(
          msg: 'Login Successful',
          state: ToastStates.success);

      navigateAndRemoveTo(route: const MainScreen(), context: context);
      print('true');
      FirebaseMessaging.instance.getToken().then((token){
        _firestore.collection('users').doc(_auth.currentUser!.uid.toString()).update({'token':token.toString()});

      });
    }
    emit(ChatLoginUserState());
  }).catchError((ex){

    if (ex.code == 'user-not-found') {
      defaultToastMessage(
          msg: 'No user found for that email.',
          state: ToastStates.error);
      print('No user found for that email.');
    } else if (ex.code == 'wrong-password') {
      defaultToastMessage(
          msg: 'Wrong password provided for that user.',
          state: ToastStates.error);
      print('Wrong password provided for that user.');
    }else{
      defaultToastMessage(
          msg: ex.message,
          state: ToastStates.error);
    }
    emit(ChatLoginUserState());
  });
  emit(ChatLoginUserState());

}

void forgotPassword({email})async{
  try {
  await  _auth.sendPasswordResetEmail(email: email);
      defaultToastMessage(
          msg: 'Password Reset Email Sent!',
          state: ToastStates.success);
      emit(ChatForgotPasswordState());

  } on FirebaseAuthException catch(e){
    defaultToastMessage(
        msg: e.message.toString(),
        state: ToastStates.error);
  }
}

Future<UserCredential> signInWithGoogle(context)async{
  defaultShowDialog(context: context, text: 'Loading...');
  emit(ChatSignInWithGoogleLoadingState());
  final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication? signInAuth = await signInAccount!.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: signInAuth!.accessToken,
    idToken: signInAuth.idToken
  );
  emit(ChatSignInWithGoogleSuccessState());

  return await _auth.signInWithCredential(credential);
}

  Future<UserCredential> signInWithFacebook(context) async {

    defaultShowDialog(context: context, text: 'Loading...');
    // Trigger the sign-in flow
    emit(ChatSignInWithFacebookLoadingState());
    final LoginResult loginResult = await facebookAuth.login();
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    emit(ChatSignInWithFacebookSuccessState());
    Navigator.pop(context);
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }




  void setCurrentUserDataInFirestore({
    required name,
    required email,
    required phoneNumber,
    required photoURL,
    required uid,
    required context
}){

  //it is for Social Auth
    FirebaseMessaging.instance.getToken().then((token) {
      emit(ChatSetSocialAuthDataInFirestoreState());
      CurrentUserModel model =CurrentUserModel(
          token:token ,
          username:name??'Add name' ,
          email:email??'Add email' ,
          phone:phoneNumber??'Add phone' ,
          image:photoURL ?? 'Add photo' ,
          bio:'New user',
          uid:uid ,
          status: 'Online'
      );
        _firestore.collection('users')
            .doc(uid)
            .set(model.toJson())
            .then((value) {
          getCurrentUsers();
          print('setCurrentUserDataInFirestore');
          navigateAndRemoveTo(route: const MainScreen(), context: context);
          emit(ChatSetSocialAuthDataInFirestoreState());
        });
    });

  }


                                 /////////////// firebase Firestore /////////////
  List<AllUsersModel> usersDataList = [];

  void getAllUsers(){
    if(_auth.currentUser != null){
      _firestore
          .collection('users').snapshots().listen((event) {
        usersDataList = [];
        for (var element in event.docs) {
          if(element['uid'] != _auth.currentUser!.uid) {
            usersDataList.add(AllUsersModel.fromJson(element.data()));
            print('getAllUsers sd');
            emit(ChatGetAllUserDataState());
          }
        }
      });
    }


  }

  CurrentUserModel currentUserData = CurrentUserModel();
  void getCurrentUsers(){
    if(_auth.currentUser != null){
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value){
            currentUserData= CurrentUserModel.fromJson(value.data()!);
            fireStorageUrlImage =null;
            profileImage = null;
        emit(ChatGetCurrentUserDataState());
      }).catchError((e){
        print(e.toString());
      });
    }

  }


  List<AllFriendsUserModel> getFriendsDataList = []; // just for chat screen
  void getAllFriendsUsers()async{
    List chatsUsersDocId =[];
    if(_auth.currentUser != null) {
      emit(ChatGetAllFriendsDataLoadingState());
   await   _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .get()
          .then((value)async{
        chatsUsersDocId.clear();
        emit(ChatGetAllFriendsDataSuccessState());
        value.docs.forEach((element) {
            chatsUsersDocId.add(element.data()['doc_id']);
          _firestore
                .collection('users')
                .where('uid',whereIn:chatsUsersDocId )
                .snapshots().listen((value){
              getFriendsDataList.clear();
              for (var element in value.docs) {
                if(element['uid'] != _auth.currentUser!.uid) {
                  getFriendsDataList.add(AllFriendsUserModel.fromJson(element.data()));
                  print('getAllFriendsUsers');
                  emit(ChatGetAllFriendsDataSuccessState());
                }}});
            emit(ChatGetAllFriendsDataSuccessState());
          });});


    }
  }

                          ////////////////////////// ForImages
   File? profileImage;

  ImagePicker picker = ImagePicker();
  void pickImageUrl()async{
  final pikedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 50);
  if(pikedFile != null){
    profileImage = File(pikedFile.path);
  }
    emit(ChatPickImageState());

  }

String? fireStorageUrlImage;
  Future<void> uploadProfileImage()async {
    emit(ChatUploadImageState());
  await  _storage.ref(
      'users/images/${Uri.file(profileImage!.path.toString()).pathSegments.last}'
    ).putFile(profileImage!).then((value)async{
    await  value.ref.getDownloadURL().then((value){
        fireStorageUrlImage = value;
      });
      profileImage = null;
      emit(ChatUploadImageState());
    });
      print('success');

  }

  void updateUserData({
    required String  username,
    required String phone,
    required String bio,
}){
    emit(ChatUpdateUserDataState());
    CurrentUserModel model =CurrentUserModel(
      token:currentUserData.token ,
      username:username ,
      email:currentUserData.email ,
      phone:phone ,
      image:fireStorageUrlImage ?? currentUserData.image ,
      bio: bio,
      uid:currentUserData.uid ,
      status: 'Online'

    );
    if(_auth.currentUser != null) {
      _firestore.collection('users')
          .doc(_auth.currentUser!.uid)
          .update(model.toJson())
          .then((value) {
            getCurrentUsers();
        print('updateUserData');
        emit(ChatUpdateUserDataState());
      });
    }
  }



  void sendMessageFire({
    required String  text,
    required String receiverId,
  }){

    if(_auth.currentUser != null) {

      ChatMessageModel chatMessageModel = ChatMessageModel(
        receiverId:receiverId ,
        senderId:_auth.currentUser!.uid ,
        text:text,
        time: DateTime.now().toString(),
      );

      emit(ChatSendMessageState());
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .add(chatMessageModel.toJson())
          .then((value) {

        _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('chats')
            .doc(receiverId).update({'doc_id':receiverId}).then((value) => null);

        emit(ChatSendMessageState());
      });

//receiverId
      _firestore.collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(_auth.currentUser!.uid)
          .collection('messages')
          .add(chatMessageModel.toJson())
          .then((value) {

        _firestore
            .collection('users')
            .doc(receiverId)
            .collection('chats')
            .doc(_auth.currentUser!.uid)
            .update({'doc_id':_auth.currentUser!.uid}).then((value) => null);
        emit(ChatSendMessageState());
      });
      emit(ChatSendMessageState());
    }
  }



  void messageReadFalse(receiverId){
    _firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(_auth.currentUser!.uid)
            .update({'is_in_chat_screen':'false'})
            .then((value){

          emit(ChatMessageReadFalseState());
        });}
  void countUnreadMessage(receiverId){
    _firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(_auth.currentUser!.uid)
        .update({'count_unread_message':FieldValue.increment(1)}).then((value) {
      emit(ChatSendMessageState());

    });
    }
  void setCountUnreadMessageEqualZero(receiverId)async{
   await _firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(_auth.currentUser!.uid)
        .update({'is_in_chat_screen':'true'}).then((value) {
      emit(ChatSendMessageState());
    }).catchError((e){
      print(e.toString());
    });
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .update({'count_unread_message':0}).then((value) {
      emit(ChatSendMessageState());
    }).catchError((e){
      print(e.toString());
    });
  }

  List<UnreadMessageCountModel> getCountMessageList=[];
      void getUnreadCountMessageCount(){
        _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('chats')
            .snapshots().listen((event){
          getCountMessageList=[];
          emit(ChatSendMessageState());
          event.docs.forEach((element) {
            getCountMessageList.add(UnreadMessageCountModel.fromJson(element.data()));
            emit(ChatSendMessageState());
          });


        });

    }




  List<ChatMessageModel> messages = [];

  void receiveChatMessages({
 required String receiverId
}){
    _firestore
    .collection('users')
    .doc(_auth.currentUser!.uid)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .orderBy('time',descending: true)
    .snapshots()
        .listen((event) {
      messages =[];
      emit(ChatReceiverMessageState());
          event.docs.forEach((element) {
              messages.add(ChatMessageModel.fromJson(element.data()));
            emit(ChatReceiverMessageState());
          });
      emit(ChatReceiverMessageState());
    });
  }

void logout(context)async {
  _auth.signOut().then((value) {
    navigateAndRemoveTo(route: const LoginScreen(), context: context);
    index = 1;
    emit(ChatLogoutUserDataState());
  });
  if (googleSignIn.currentUser != null)
    await googleSignIn.disconnect();
  _firestore.collection('users').doc(_auth.currentUser!.uid).update({
    'status': 'Offline'
  })
      .then((value) {
    print('UserOffline');
    emit(ChatUserOnlineStatusState());
  });
  getFriendsDataList.clear();
  usersDataList.clear();
  emit(ChatUserOnlineStatusState());
}



 Future<void>  defaultFutureDelayedGetAllUsers()async{
   getAllUsers();
  return  Future.delayed(
        const Duration(seconds:2 ),
      (){
        emit(ChatGetAllUsersWithRefreshState());
      }
  );

  }

  Future<void>  defaultFutureDelayedGetFriendsUsers()async{
    getUnreadCountMessageCount();
    getAllFriendsUsers();
  return  Future.delayed(
        const Duration(seconds:2 ),
      (){
        emit(ChatGetAllUsersWithRefreshState());
      }
  );

  }



  fcmChatMessage({
    required String token,
    required String bodyName,
    required String titleText,
    required String image,
    required String uid,
  }) async {

   String serverToken = 'key=AAAAQ66p76s:APA91bEohgBmN0Nx2mBPy5Bs6sKCwskC37-mMflp3M2O7yEiJkKAucRqxaE5UxjKP5MZcAtAglBjr-kFECN248wInh4-V7C76fVbk-JUhgMp_L_eZSk5YfapHSdIhAE30R3DHSB3CqwB';

    Map<String, String> headerMap =
    {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };
    Map notificationMap =
    {
      'title': titleText,
      'body': bodyName,
      'image': image,
    };
    Map dataMap =
    {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'user_uid': uid,
    'status': 'done',

    };
   print(dataMap);
    Map sendNotificationMap =
    {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
    emit(ChatFCMChatMessageState());

  }


  void openMessageFcmFriendsChatScreen(context,uid){

    final index = getFriendsDataList.indexWhere((element) => element.uid == uid);
    if(getFriendsDataList.asMap().containsKey(index) == true) {
      navigateTo(route: ChatFriendsDetailsScreen(index: index), context: context);
      setCountUnreadMessageEqualZero(uid);
    }

    emit(ChatOpenMessageFriendsScreenFCMState());
  }


  void toggleUserOnlineStatus(AppLifecycleState state){

    if(state == AppLifecycleState.resumed){
      _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'status':'Online'
      }).then((value){
        print('UserOnline');
        emit(ChatUserOnlineStatusState());

      });

    }else{
      _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'status':'Offline'
      }).then((value){
        print('UserOffline');
        emit(ChatUserOnlineStatusState());
      } );

    }
  }





}

