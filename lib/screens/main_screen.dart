import 'package:chat_app_firebase/cubit/cubit.dart';
import 'package:chat_app_firebase/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/style.dart';
import '../fcm/push_notification.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override

  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool initStateOnce = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FCM.initializeMessage(context);
    if(initStateOnce == false){
      ChatCubit.get(context).getCurrentUsers();
      ChatCubit.get(context).getAllUsers();
      ChatCubit.get(context).getAllFriendsUsers();
      ChatCubit.get(context).getUnreadCountMessageCount();
      setState(() {
        initStateOnce = true;
      });
      print(initStateOnce.toString());
      WidgetsBinding.instance!.addObserver(this);
    }

  }
@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    ChatCubit.get(context).toggleUserOnlineStatus(state);

  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
        listener: (context,state){},
    builder:(context,state){
    var cubit = ChatCubit.get(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: kBackgroundColor,

      body: cubit.screens[cubit.index],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 10),
        child: BottomNavigationBar(
               backgroundColor:  Color(0x9f13253d),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              currentIndex:cubit.index ,
              onTap: (index){
              cubit.currentIndex(index);
              },
            items:[
              BottomNavigationBarItem(
                  icon: Icon(Icons.supervised_user_circle_rounded,),
                  label: 'Users'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.textsms_outlined), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined), label: 'Setting'),
            ]),
      ),
    );
  });
  }
}
