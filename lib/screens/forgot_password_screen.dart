import 'package:chat_app_firebase/components/component.dart';
import 'package:chat_app_firebase/components/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ForgotPasswordScreen extends StatelessWidget {

   ForgotPasswordScreen({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController() ;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
        listener: (context,state){},
    builder:(context,state){
    var cubit = ChatCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
          backgroundColor: kAppBarBackgroundColor
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 150,),
        child: Column(
          children: [
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 40.0),
               child: Text('you will receive message in your email',
            style: Theme.of(context).textTheme.headline4,
            ),
             ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: defaultTextField(
                borderRadius: 10,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                  textInputType: TextInputType.emailAddress,
                  label:'Enter email address',
                controller: emailController
              ),
            ),
            defaultElevatedButton(
                label: 'Reset Password',
                onPressed: (){
                  if(emailController.text.isNotEmpty) {
                    cubit.forgotPassword(email: emailController.text);
                    emailController.clear();
                  }
                  else{
                    defaultToastMessage(
                    msg:'Text field is empty' ,
                    state: ToastStates.error);
                    }
                }),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
    });
  }
}
