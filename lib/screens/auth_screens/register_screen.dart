
import 'package:chat_app_firebase/components/component.dart';
import 'package:chat_app_firebase/cubit/cubit.dart';
import 'package:chat_app_firebase/cubit/states.dart';
import 'package:chat_app_firebase/screens/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {


   const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //ossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign Up',
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                          ),
                        ),
                        SizedBox(height: 20,),
                        defaultTextField(
                          prefixIcon: Icon(Icons.person,color: Colors.grey,),
                          textInputType: TextInputType.text,
                          label: 'Username',
                          controller: usernameController,
                          validator: (value){
                            if(value.toString().isEmpty){
                              return 'Username is empty';
                            }else if(value.toString().length < 4){
                              return 'Username must be great than 3 characters ';
                            }

                          }
                        ),


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
                            controller: phoneController,
                          prefixIcon: Icon(Icons.phone,color: Colors.grey,),
                          textInputType: TextInputType.number,
                          label: 'Phone',
                            validator: (value){
                              if(value.toString().isEmpty){
                                return 'Phone is empty';
                              }
                            }
                        ),

                        defaultTextField(
                          prefixIcon: const Icon(Icons.lock_outlined,color: Colors.grey,),
                          textInputType: TextInputType.visiblePassword,
                            controller:passwordController,
                          label: 'Password',
                            obscureText: true,
                            validator: (value){
                              if(value.toString().isEmpty){
                                return 'Password is empty';
                              }else if(value.toString().length < 8){
                                return 'Password must be great than 8 Characters';
                              }
                            }
                        ),
                        SizedBox(height: 20,),
                        defaultElevatedButton(
                            label: 'Sign Up',
                            onPressed: (){
                            if(formKey.currentState!.validate()){
                              cubit.registerUser(
                                context: context,
                                  username: usernameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  password: passwordController.text);
                              FocusScope.of(context).unfocus();
                               passwordController.clear();
                            }
                            }),
                        SizedBox(height: 30,),
                        defaultDivider(),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            defaultTextButton(label: 'Log in', onPressed: (){
                              navigateTo(route:LoginScreen() , context: context);
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
