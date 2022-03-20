
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/style.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class UserProfileFromUsersList extends StatelessWidget {
   UserProfileFromUsersList({Key? key,required this.index}) : super(key: key);
   int index;


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
        listener: (context,state){},
        builder:(context,state){
          var userData = ChatCubit.get(context).usersDataList[index];
          return Scaffold(
            appBar: AppBar(
              title: Text('User Profile'),
              backgroundColor: kAppBarBackgroundColor,
            ),
            backgroundColor: kBackgroundColor,
            body: SingleChildScrollView(
              child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom:290,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff8E0000),
                            borderRadius:BorderRadius.only(
                              bottomLeft:Radius.circular(130),
                              bottomRight:Radius.circular(130),
                            ),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.only(top: 60),
                            child: Column(
                              children: [
                                Text('WELCOME!',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                SizedBox(height: 10,),
                                Text('to my profile',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Column(
                        children: [
                          Column(

                            children: [
                              CircleAvatar(
                                backgroundImage:NetworkImage(userData.image.toString()),
                                radius: 70,
                              ),
                              const SizedBox(height: 20,),
                              Text(userData.username.toString(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 20,),
                              Text(userData.bio.toString()),
                              const SizedBox(height: 50,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.email_outlined),
                                      const SizedBox(width: 5,),
                                      Text('hello@gmail.com'),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone_android),
                                      const SizedBox(width: 5,),
                                      Text(userData.phone.toString()),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.circle,size: 10,color:userData.status.toString() == 'Online'?Colors.green:Colors.grey[500] ,),
                                      const SizedBox(width: 5,),
                                      Text(userData.status.toString()),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            ),
          );
        });}
}