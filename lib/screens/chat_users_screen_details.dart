
import 'package:chat_app_firebase/components/style.dart';
import 'package:chat_app_firebase/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/component.dart';
import '../cubit/states.dart';

class ChatUsersDetailsScreen extends StatelessWidget {

   ChatUsersDetailsScreen({Key? key,required this.index}) : super(key: key);
   TextEditingController messageController= TextEditingController();
    int index;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
        listener: (context,state){},
        builder:(context,state){
          var userDataList = ChatCubit.get(context).usersDataList;
          var currentUser = ChatCubit.get(context).currentUserData;
          var cubit = ChatCubit.get(context);
          ChatCubit.get(context)
              .receiveChatMessages(
              receiverId: userDataList[index].uid.toString());
          return Scaffold(
          backgroundColor:kBackgroundColor ,
          appBar: AppBar(
            titleSpacing: 0,
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);}),
            title: Row(
                children: [
              CircleAvatar(
                maxRadius: 20,
                backgroundColor: kCircleAvatarColor,
                backgroundImage:userDataList[index].image.toString() != ""?
                NetworkImage(
                  userDataList[index].image.toString(),
                ):null,

              ),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userDataList[index].username.toString().split(' ').first,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(userDataList[index].status.toString(),
                        style: TextStyle(
                          color:userDataList[index].status.toString() =='Online'?Colors.green:Colors.grey[500],
                          fontSize: Theme.of(context).textTheme.caption!.fontSize
                        ),
                      ),
                    ],
                  ),
            ],

        ),
        backgroundColor: kAppBarBackgroundColor,
      ),
      bottomSheet:Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: defaultTextMessageField(
                  controller:messageController ,
                  label: const Text('Type a message ...')
              ),
            ),
            Expanded(
              flex: 1,
                child: CircleAvatar(
                  radius: 20,
                  child: IconButton(
                      onPressed: (){
                        if(messageController.text.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                          cubit.sendMessageFire(
                            text: messageController.text,
                            receiverId:userDataList[index].uid.toString()
                        );
                          cubit.fcmChatMessage(
                              uid:currentUser.uid.toString() ,
                              token: userDataList[index].token.toString(),
                              titleText: currentUser.username.toString(),
                              bodyName: messageController.text,
                            image: cubit.currentUserData.image.toString()
                          );
                        }
                        messageController.clear();
                      },
                      icon: Icon(Icons.arrow_forward_sharp)),
                ))
          ],
        ),
      ),
      endDrawer:  buildDrawerUserProfile(
          context: context,
          userDataList: userDataList,
          index: index
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0,bottom: 70,left: 10,right: 10),
        child:ConditionalBuilder(
          condition:cubit.messages.isNotEmpty ,
          builder:(context)=>Padding(
            padding: const EdgeInsets.only(top: 15,right: 10,left: 10,bottom:0,),
            child: ListView.separated(
              reverse: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index) {
                var messages = ChatCubit.get(context).messages[index];
                if(cubit.currentUserData.uid == messages.senderId) {
                  return  currentUserMessage(context,messages);
                }else{
                  return  otherUserMessage(context,messages);
                }
              },
              separatorBuilder:(context,index) => const SizedBox(height: 0),
              itemCount: cubit.messages.length,
            ),
          ),
          fallback:(context)=>  Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Say Hello'),
              SizedBox(width: 10,),
              FaIcon(FontAwesomeIcons.handsHelping)
            ],
          )),
        ),
      ),
    );});
  }
}


