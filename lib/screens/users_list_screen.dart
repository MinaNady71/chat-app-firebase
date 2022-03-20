import 'package:chat_app_firebase/components/component.dart';
import 'package:chat_app_firebase/components/style.dart';
import 'package:chat_app_firebase/cubit/cubit.dart';
import 'package:chat_app_firebase/cubit/states.dart';
import 'package:chat_app_firebase/models/allUsersMode.dart';
import 'package:chat_app_firebase/screens/chat_users_screen_details.dart';
import 'package:chat_app_firebase/screens/user_profile_from_friends_list.dart';
import 'package:chat_app_firebase/screens/user_profile_from_user_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';


class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
        listener: (context,state){},
        builder:(context,state){
          var cubit = ChatCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                backgroundColor: kAppBarBackgroundColor,
                title: Text('Users List',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              backgroundColor: kBackgroundColor ,
              body:RefreshIndicator(
                onRefresh:cubit.defaultFutureDelayedGetAllUsers,
                child: Container(
                  child: ConditionalBuilder(
                    condition:cubit.usersDataList.isNotEmpty ,
                    builder:(context)=>Padding(
                      padding: const EdgeInsets.only(top: 15,right: 10,left: 10,bottom: 0,),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context,index) => usersList(context,cubit.usersDataList[index],index),
                        separatorBuilder:(context,index) => const SizedBox(height: 10),
                        itemCount: cubit.usersDataList.length,
                      ),
                    ),
                    fallback:(context)=> const Center(child: CircularProgressIndicator()) ,
                  ),
                ),
              ),

          );}
    );
  }


Widget usersList(context, AllUsersModel userdata ,index){
  var cubit = ChatCubit.get(context);
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0x220E86E8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onLongPress: (){
              navigateTo(route: UserProfileFromUsersList(index: index), context: context);
            },
            onTap: () {
             navigateTo(route: ChatUsersDetailsScreen(index: index), context: context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        maxRadius: 25,
                        backgroundColor: kCircleAvatarColor,
                        backgroundImage: userdata.image.toString() != ""?NetworkImage(
                          userdata.image.toString(),
                        ):null,
                      ),
                      CircleAvatar(
                        radius:8 ,
                        backgroundColor: Colors.black45,
                        child: CircleAvatar(
                          maxRadius: 5,
                          backgroundColor: userdata.status =='Online' ?Colors.green:Colors.grey[500],
                        ),
                      ),
                    ],
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userdata.username.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6,
                        ),
                        SizedBox(height: 10,),
                        Text(userdata.bio.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: Text(userdata.status.toString(),
                      overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:userdata.status =='Online' ?Colors.green:Colors.grey[500],
                    ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                ],),
            ),
          ),
        )

      ],
    );
}

}
