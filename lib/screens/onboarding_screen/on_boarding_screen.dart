import 'package:chat_app_firebase/components/component.dart';
import 'package:chat_app_firebase/components/style.dart';
import 'package:chat_app_firebase/cubit/cubit.dart';
import 'package:chat_app_firebase/models/on_boarding_model.dart';
import 'package:chat_app_firebase/screens/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({Key? key}) : super(key: key);
  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final PageController _pageController =PageController();

  List<OnBoardingModel> boarding = [
    OnBoardingModel(
        image: 'assets/images/onboarding_1.jpg',
        body: 'Fast Sign In',
        title: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley'
    ),
    OnBoardingModel(
        image: 'assets/images/onboarding_2.jpg',
        body: 'Count Messages',
        title: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley'
    ),
    OnBoardingModel(
        image: 'assets/images/onboarding_3.jpg',
        body: 'FCM',
        title: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley'
    ),

  ];

  bool isLast =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index){
                  if(index == boarding.length -1){
                    isLast = true;
                  }else{
                    isLast = false;
                  }
                },
                physics: const BouncingScrollPhysics(),
                controller:_pageController ,
                itemCount: boarding.length,
                itemBuilder: (context, index) => buildColumnBoarding(context,boarding[index]),

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
              child: Row(
                children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  effect: ExpandingDotsEffect(
                    activeDotColor: kAppBarBackgroundColor,
                    expansionFactor: 3,
                    spacing: 10

                  ),
                    count: boarding.length
                ),
                const Spacer(),
                FloatingActionButton
                  (
                  onPressed: (){
                    setState(() {
                      if(isLast){
                        navigateAndRemoveTo(route:  ChatCubit.get(context).homeScreen(), context: context);
                      }
                      _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInBack);
                    });
                  },
                  backgroundColor: kAppBarBackgroundColor,
                  child: const Icon(Icons.arrow_forward_outlined),)

              ],),
            ),
          ],
        ),
        defaultTextButton(
            size: 17,
            label: 'Skip', onPressed: (){
              navigateAndRemoveTo(route: ChatCubit.get(context).homeScreen(), context: context);
        })

        ],
      ),
    );
  }

  Column buildColumnBoarding(BuildContext context , OnBoardingModel boardingModel) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image(image: AssetImage(boardingModel.image),height:500,width: double.infinity,fit: BoxFit.cover,),
              const SizedBox(height: 50,),
             Padding(
               padding: const EdgeInsets.all(30),
               child: Column(
                 children: [
                   Text(boardingModel.body,style: Theme.of(context).textTheme.headline5,),
                   const SizedBox(height: 20,),
                   Text(boardingModel.title,style: Theme.of(context).textTheme.headline6,),
                 ],
               ),
             ),

            ],
          );
  }
}
