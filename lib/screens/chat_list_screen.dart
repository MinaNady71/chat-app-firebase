

import 'package:chat_app_firebase/components/component.dart';
import 'package:chat_app_firebase/components/style.dart';
import 'package:chat_app_firebase/cubit/cubit.dart';
import 'package:chat_app_firebase/cubit/states.dart';
import 'package:chat_app_firebase/models/allFriendUserChatMode.dart';
import 'package:chat_app_firebase/models/message%20count.dart';
import 'package:chat_app_firebase/screens/user_profile_from_friends_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'chat__friends_screen_details.dart';


class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
        listener: (context,state){},
        builder:(context,state){
          var cubit = ChatCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kAppBarBackgroundColor,
              title: Text('Chat List',
                style: Theme.of(context).textTheme.headline5,
              ),

            ),
            backgroundColor: kBackgroundColor ,
            body:RefreshIndicator(
              onRefresh:cubit.defaultFutureDelayedGetFriendsUsers,
              child: ConditionalBuilder(
                condition:cubit.getFriendsDataList.isNotEmpty ,
                builder:(context)=>Padding(
                  padding: const EdgeInsets.only(top: 15,right: 10,left: 10,bottom: 0,),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(parent: ScrollPhysics()),
                    itemBuilder: (context,index) => usersList(
                     context:  context,
                     userdata:  cubit.getFriendsDataList[index],
                     index:  index,
                    messageCount: cubit.getCountMessageList.length == cubit.getFriendsDataList.length?  cubit.getCountMessageList[index]:null
                    ),
                    separatorBuilder:(context,index) => const SizedBox(height: 10),
                    itemCount:  cubit.getFriendsDataList.length,
                  ),
                ),
                fallback:(context)=>const Center(child: Text('Add new friend')) ,
              ),
            ),

          );}
    );
  }
}

Widget usersList({
  required context,
  required  AllFriendsUserModel userdata,
  required  index,
    UnreadMessageCountModel? messageCount
}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          color: const Color(0x220E86E8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onLongPress: (){
            navigateTo(route: UserProfileFromFriendsList(index: index), context: context);
          },
          onTap: () {
            navigateTo(route: ChatFriendsDetailsScreen(index: index), context: context);
            ChatCubit.get(context).setCountUnreadMessageEqualZero(userdata.uid);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                 flex: 2,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        minRadius: 25,
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
                  flex: 7,
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

                Expanded(
                  flex: 2,
                  child: Text(userdata.status.toString(),
                    style: TextStyle(
                      color:userdata.status =='Online' ?Colors.green:Colors.grey[500],
                    ),
                  ),
                ),

              if(messageCount?.countUnreadMessage != 0 && messageCount?.countUnreadMessage != null )
                  Expanded(
                    flex: 1,
                  child: CircleAvatar(
                    minRadius: 12,
                    maxRadius: 12,
                    child: Text(messageCount!.countUnreadMessage.toString(),style: TextStyle(fontSize: 14),),
                  ),
                )

              ],),
          ),
        ),
      ),
    ],
  );
}


// RefreshIndicator(
// onRefresh:cubit.defaultFutureDelayedGetFriendsUsers,
// child: ConditionalBuilder(
// condition:cubit.getFriendsDataList.isNotEmpty ,
// builder:(context)=>Padding(
// padding: const EdgeInsets.only(top: 15,right: 10,left: 10,bottom: 0,),
// child: ListView.separated(
// physics: const AlwaysScrollableScrollPhysics(parent: ScrollPhysics()),
// itemBuilder: (context,index) => usersList(context,cubit.getFriendsDataList[index],index),
// separatorBuilder:(context,index) => const SizedBox(height: 10),
// itemCount: cubit.getFriendsDataList.length,
// ),
// ),
// fallback:(context)=>const Center(child: Text('Add new friend')) ,
// ),
// ),