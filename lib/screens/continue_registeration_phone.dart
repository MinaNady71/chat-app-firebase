
import 'package:chat_app_firebase/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/style.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class UpdateProfileForPhoneAuth extends StatelessWidget {
  UpdateProfileForPhoneAuth({Key? key}) : super(key: key);

  GlobalKey<FormState> form = GlobalKey();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
        listener: (context,state){},
        builder:(context,state){
          var cubit = ChatCubit.get(context);
          var userdata = ChatCubit.get(context).currentUserData  ;
          var localimage = ChatCubit.get(context).profileImage  ;
          usernameController.text = userdata.username.toString();
          phoneController.text = userdata.phone.toString();
          bioController.text = userdata.bio.toString();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kAppBarBackgroundColor,
              actions: [
                defaultTextButton(
                  // color: cubit.disableButton == false?Colors.grey:Colors.blueAccent,
                    label: 'Update', onPressed: (){

                  if(cubit.profileImage != null){
                    if(form.currentState?.validate() != null)  {
                      cubit.uploadProfileImage().then((value){
                        cubit.updateUserData(
                          username: usernameController.text,
                          phone: phoneController.text,
                          bio: bioController.text,
                        );
                      });
                    }
                  }else {
                    if(form.currentState?.validate() != null) {
                      cubit.updateUserData(
                        username: usernameController.text,
                        phone: phoneController.text,
                        bio: bioController.text,
                      );
                    }}
                }
                ),
              ],
            ),
            backgroundColor: kBackgroundColor,
            body: userdata != null? SingleChildScrollView(
              child: Column(
                children: [
                  if(state is ChatUpdateUserDataState || state is ChatUploadImageState)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20,top: 50,right: 20,left: 20),
                    child: Form(
                      key: form,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Material(
                                color: kCircleAvatarColor,
                                clipBehavior:Clip.antiAliasWithSaveLayer ,
                                shape: const CircleBorder(),
                                child: Align(
                                  child: InkWell(
                                    onTap: (){
                                      cubit.pickImageUrl();
                                    },
                                    child: Ink.image(
                                      height: 175,
                                      width: 175,
                                      fit: BoxFit.cover,
                                      image:localimage == null ? NetworkImage(userdata.image.toString()):FileImage(localimage) as ImageProvider,

                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 135,left: 115),
                                child: Center(
                                  child: Stack(
                                    children: const [ Icon(
                                        Icons.camera_alt_outlined,
                                        size: 30,
                                        color: Colors.white60),],),
                                ),
                              ) ,
                            ],

                          ),

                          const SizedBox(height: 20,),
                          Text(userdata.username.toString(),
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const SizedBox(height: 50,),
                          defaultTextField(

                              controller:usernameController ,
                              textInputType: TextInputType.text,
                              label: 'Name',
                              validator: (value){
                                if(value.toString().isEmpty){
                                  return 'Username is empty';
                                }else if(value.toString().length < 4){
                                  return 'Username must be great than 3 characters ';
                                }

                              }
                          ),
                          defaultTextField(
                              controller: phoneController,
                              textInputType: TextInputType.number,
                              label: 'Phone',
                              validator: (value){
                                if(value.toString().isEmpty){
                                  return 'Phone is empty';
                                }
                              }
                          ),
                          defaultTextField(


                              controller: bioController,
                              maxLength: 300,
                              textInputType: TextInputType.text,
                              label: 'Bio',
                              validator: (value){
                                if(value.toString().isEmpty){
                                  return 'Bio is empty';
                                }
                              }
                          ),
                          const SizedBox(height: 15,),
                          defaultElevatedButton(
                              label: 'Log Out',
                              onPressed: (){
                                cubit.logout(context);
                              }),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ):const Center(child: CircularProgressIndicator()),
          );
        });}
}