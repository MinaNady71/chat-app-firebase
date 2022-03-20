

import 'package:chat_app_firebase/cubit/cubit.dart';
import 'package:chat_app_firebase/cubit/states.dart';
import 'package:chat_app_firebase/screens/onboarding_screen/on_boarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> ChatCubit()..getAllUsers()..getCurrentUsers()..getAllFriendsUsers()..getUnreadCountMessageCount(),
      child: BlocConsumer<ChatCubit,ChatStates>(
        listener: (context,state){},
    builder:(context,state){
    var cubit = ChatCubit.get(context);
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            iconTheme: IconThemeData(
              color: Colors.white
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.transparent
            ),
            textTheme: TextTheme(
                caption: TextStyle(
                    color: Colors.grey[300]
                ),
                headline6: TextStyle(
                    color: Colors.white
                ),
                headline5: TextStyle(
                    color: Colors.white
                ),
                headline4: TextStyle(
                    color: Colors.white
                ),
                subtitle1: TextStyle(
                    color: Colors.white
                ),
                subtitle2: TextStyle(
                color: Colors.white
            ),
              bodyText1: TextStyle(
                color: Colors.white
              ),
                bodyText2: TextStyle(
                    color: Colors.white
                )
            ),
          ),
          home: SafeArea(child:BoardingScreen(),),
        );}
      ),
    );
  }
}
