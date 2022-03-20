import 'package:chat_app_firebase/components/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/chat_message_model.dart';

Widget defaultTextField({
required  textInputType,
 required String label,
 bool obscureText = false,
 controller,
 Widget?  prefixIcon,
 Widget?  prefix,
 Widget?  suffixIcon,
 Widget?  suffix,
   validator,
  maxLength = 80,
  onEditingComplete,
  floatingLabelBehavior,
  double borderRadius = 30,

})=>  Padding(
  padding: const EdgeInsets.all(8.0),
  child:   TextFormField(
  maxLength:maxLength ,
    controller: controller,
    obscureText: obscureText,
    keyboardType: textInputType,
    validator:validator ,
    decoration: InputDecoration(
      floatingLabelBehavior:floatingLabelBehavior ,
     counterText: '',
      prefixIcon: prefixIcon,
      prefix:prefix ,
      suffixIcon:suffixIcon ,
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      suffix:suffix ,
      fillColor:Color(0xff2B282E),
      filled: true,
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),

      ),
    ),
  ),
);

Widget defaultTextMessageField({
  controller,
  label,
})=> TextFormField(
  controller: controller,
  maxLines: null,
  maxLength: 5000,
  decoration: InputDecoration(
    counterText: '',
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      fillColor:Color(0xff2B282E),
      filled: true,
      label :label ,
      labelStyle: const TextStyle(color:Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),

      ),
      floatingLabelBehavior: FloatingLabelBehavior.never
  ),
);



Widget defaultElevatedButton({
  backgroundColor  =const Color(0xff2B282E),
  required String label,
  required  onPressed
})=> ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
      padding:MaterialStateProperty.all( EdgeInsets.symmetric(horizontal: 50,),),
      fixedSize:MaterialStateProperty.all(
        Size.fromWidth(double.infinity),

      ) ,
      shape:MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
          )
      ) ,
      backgroundColor: MaterialStateProperty.all(backgroundColor),
    ),
    child: Text(label.toUpperCase(),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: "bolt-semibold",
      ),),


    );


Widget defaultTextButton({
  required String label,
  required  onPressed,
  double?  size,
  Color  color = Colors.blueAccent ,
})=>TextButton(
    onPressed: onPressed,
    child: Text(label,
       style:TextStyle(
         fontSize: size,
          color:color) ,
));
enum ToastStates {success,warning,error}

Color? toastColors(ToastStates state ){
  Color color;
  switch (state){
    case ToastStates.success:
      color = const Color(0xff076848);
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.yellow;
      break;
    }
    return color;

  }

defaultToastMessage({
  required msg ,
  required ToastStates state,
}){
  Fluttertoast.showToast(msg: msg,backgroundColor: toastColors(state),fontSize: 17,timeInSecForIosWeb: 2);
}


//  Future defaultCheckInternet()async{
//   var connectivityResult = await Connectivity().checkConnectivity();
//       if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
//         defaultToastMessage(msg: "Check The Internet Connection", color: Colors.red);
//         return;
//       }
// }

 defaultShowDialog({
    required context,
    required String text,
})=> showDialog(
   barrierDismissible: true,
  context: context,
    builder: (context)=> Dialog(
      child: Container(color: kBackgroundColor,
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 35),
        child: Row(
          children: [
          CircularProgressIndicator(),
            SizedBox(width: 25,),
            Text(text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
        ],),
      ),
    ) ,

);

 navigateByTimer({required context, int seconds = 1}){

   Future.delayed(
       Duration(seconds:seconds ),(){
     Navigator.pop(context);
   });
}

defaultFutureDelayed({seconds, function}){
  Future.delayed(
      Duration(seconds:seconds ),function);

}

Widget defaultDivider()=>Divider(
  height: 1,
  color: Colors.grey[800],
  thickness: .7,
);

  navigateTo({
    required route,
       required  context})
  =>  Navigator.push(
         context,
         MaterialPageRoute(
             builder: (context)=>
              route));



navigateAndRemoveTo({
  required route,
  required  context
})
=>  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=> route), (route) => false);

// drawer for user profile
SizedBox buildDrawerUserProfile({context,userDataList,index}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.80,
    child: Drawer(
        backgroundColor: kBackgroundColor,
        child:SingleChildScrollView(
          child: Column(children: [
            Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom:300,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff8E0000),
                          borderRadius:BorderRadius.only(
                            bottomLeft:Radius.circular(130),
                            bottomRight:Radius.circular(130),
                          ),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(top: 110),
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
                    padding: const EdgeInsets.only(top: 290),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundImage:NetworkImage(userDataList[index].image.toString()),
                              radius: 70,
                            ),
                            const SizedBox(height: 20,),
                            Text(userDataList[index].username.toString(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  const SizedBox(height: 20,),
                                  Text(userDataList[index].bio.toString(),textAlign: TextAlign.center,),
                                  const SizedBox(height: 50,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Flexible(child: Icon(Icons.email_outlined)),
                                      SizedBox(width: 5,),
                                      Flexible(child: Text('hello@gmail.com')),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(child: const Icon(Icons.phone_android)),
                                      const SizedBox(width: 5,),
                                      Flexible(child: Text(userDataList[index].phone.toString())),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(child: Icon(Icons.circle,size: 10,color:userDataList[index].status.toString() == 'Online'?Colors.green:Colors.grey[500] ,)),
                                      const SizedBox(width: 5,),
                                      Flexible(child: Text(userDataList[index].status.toString())),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
            )
          ],),
        )
    ),
  );
}
// currentUserMessage
Widget currentUserMessage(context,ChatMessageModel messagesData){
  return Align(
    alignment: Alignment.topRight,
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize:MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
            decoration:BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(0)),
              color: kGreenColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:  [
                Flexible(
                  child: Text(
                    messagesData.text.toString() ,

                  ),
                ),
                const SizedBox(width:10,),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      messagesData.time.toString().substring(10,16),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    ),
  );

}
// otherUserMessage
Widget otherUserMessage(context,ChatMessageModel messagesData){
  return Align(
    alignment: Alignment.topLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize:MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
          decoration:BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                topLeft: Radius.circular(0),
                topRight: Radius.circular(20.0)),
            color: kAppBarBackgroundColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children:  [
              Flexible(
                child: Text(
                  messagesData.text.toString(),
                ),
              ),
              SizedBox(width:10,),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    messagesData.time.toString().substring(10,16),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    ),
  );

}
