
import 'package:chat_app_firebase/components/component.dart';
import 'package:chat_app_firebase/cubit/cubit.dart';
import 'package:chat_app_firebase/cubit/states.dart';
import 'package:chat_app_firebase/screens/auth_screens/register_screen.dart';
import 'package:chat_app_firebase/screens/forgot_password_screen.dart';
import 'package:chat_app_firebase/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components/style.dart';

class LoginScreen extends StatefulWidget {


  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey =GlobalKey<FormState>();
  @override

  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
      listener: (context,state){},
      builder:(context,state){
        var cubit = ChatCubit.get(context);
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xff37016E),
            body:  Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //ossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login',
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                          ),
                        ),
                        SizedBox(height: 25,),
                        defaultTextField(
                            controller: emailController,
                            prefixIcon: Icon(Icons.alternate_email,color:Colors.grey, ),
                            textInputType: TextInputType.emailAddress,
                            label: 'Email address',
                            validator: (value){
                              if(value.toString().isEmpty){
                                return 'Email is empty';
                              }
                            }
                        ),
                        defaultTextField(
                            prefixIcon: Icon(Icons.lock_outlined,color: Colors.grey,),
                            textInputType: TextInputType.visiblePassword,
                            controller:passwordController,
                            label: 'Password',
                            obscureText: true,
                            validator: (value){
                              if(value.toString().isEmpty){
                                return 'Password is empty';
                              }
                              // else if(value.toString().length < 8){
                              //   return 'Password must be great than 8 Characters';
                              // }
                            }
                        ),
                        SizedBox(height: 20,),
                        defaultElevatedButton(
                            label: 'Log in',
                            onPressed: (){
                              if(formKey.currentState!.validate()){
                                cubit.loginUser(
                                  context: context,
                                    email: emailController.text,
                                    password: passwordController.text);
                                FocusScope.of(context).unfocus();
                               // passwordController.clear();
                              }
                            }),
                        defaultTextButton(
                            label: 'Forgot password?',
                            onPressed: (){
                            navigateTo(route: ForgotPasswordScreen(), context: context);
                        }),
                        defaultDivider(),
                        SizedBox(height: 20,),
                          Text('Continue with...'),
                        SizedBox(height: 5,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: FaIcon(FontAwesomeIcons.google,color: kGoogleColor ,),
                              onPressed: (){
                                  cubit.signInWithGoogle(context).then((value){
                                    if(value.user != null)
                                       cubit.setCurrentUserDataInFirestore(
                                           uid:value.user!.uid ,
                                           email:value.user!.email  ,
                                           name: value.user!.displayName,
                                           phoneNumber:value.user!.phoneNumber  ,
                                           photoURL: value.user!.photoURL,
                                           context: context
                                       );
                                  });
                              },
                            ),
                            // IconButton(
                            //   icon: FaIcon(FontAwesomeIcons.facebook,color: kFacebookColor ,),
                            //   onPressed: (){
                            //     cubit.signInWithFacebook(context).then((value){
                            //       if(value.user != null)
                            //         cubit.setCurrentUserDataInFirestore(
                            //             uid:value.user!.uid ,
                            //             email:value.user!.email  ,
                            //             name: value.user!.displayName,
                            //             phoneNumber:value.user!.phoneNumber  ,
                            //             photoURL: value.user!.photoURL,
                            //             context: context
                            //         );
                            //     });
                            //   },
                            // ),

                          ],),
                        SizedBox(height: 10,),
                        defaultDivider(),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            defaultTextButton(label: 'Sign Up', onPressed: (){
                              navigateTo(route:RegisterScreen() , context: context);
                            })
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
