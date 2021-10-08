import 'package:flutter/material.dart';
import 'package:upayappnew/screens/screen_create_user.dart';
import 'package:upayappnew/screens/screen_guest_landingpage.dart';
import 'package:upayappnew/screens/screen_guest_settlepage.dart';
import 'package:upayappnew/screens/screen_landingpage.dart';
import 'package:upayappnew/screens/screen_guest_eventpage.dart';
import 'package:upayappnew/screens/screen_createbillpage.dart';
import 'package:upayappnew/screens/screen_guest_joineventpage.dart';
import 'package:upayappnew/screens/screen_guest_eventfinishedpage.dart';
import 'package:upayappnew/screens/screen_settings.dart';
import 'package:upayappnew/screens/screen_user_create_event.dart';
import 'package:upayappnew/screens/screen_user_created.dart';
import 'package:upayappnew/screens/screen_user_homepage.dart';
import 'package:upayappnew/screens/screen_user_signed_out_page.dart';
import 'package:upayappnew/screens/screen_user_landingpage.dart';
import 'package:upayappnew/screens/screen_user_profilepage.dart';
import 'package:upayappnew/screens/screen_create_user.dart';
import 'package:upayappnew/screens/screen_settings.dart';
import 'package:upayappnew/screens/screen_addFriendsToEventList.dart';
import 'dart:async';


class Routes {
  final routes = <String, WidgetBuilder>{
    '/Settings': (BuildContext context) => new SettingsOnePage(),
    '/Landing': (BuildContext context) => new LandingPage(),
    '/SignIn': (BuildContext context) => new LandingPage(),
    '/guestLanding': (BuildContext context) => new GuestLandingPage(),
    '/eventPage': (BuildContext context) => new GuestEventPage(),
    '/BillsPage': (BuildContext context) => new CreateBillPage(),
    '/finishPage': (BuildContext context) => new EventFinishedPage(),
    '/guestJoinEvent': (BuildContext context) => new GuestJoinEventPage(),
    '/activityPage': (BuildContext context) => new UserLandingPage(),
    '/createUser': (BuildContext context) => new CreateUser(),
    '/userCreated': (BuildContext context) => new UserCreated(),
    '/userSignedIn': (BuildContext context) => new UserLandingPage(),
    '/userSignedOut': (BuildContext context) => new UserSignedOut(),
    '/userProfile': (BuildContext context) => new UserProfilePage(),
    '/userCreateEvent': (BuildContext context) => new UserCreateEvent(),
    '/guestSettle' : (BuildContext context) => new GuestSettlePage(),
    '/addFriendsToEventList' : (BuildContext context) => new AddFriendsToEventList(),


  };

  Routes () {
    runApp(new MaterialApp(

      title: 'Flutter Demo',
      routes: routes,
      home: new SplashScreen(),




    ));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Landing');
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 5),
    );

    animationController.forward();
    startTime();
  }
  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.lightBlue[300],
      body: new Center(
        child: new AnimatedBuilder(
          animation: animationController,
        child: Image.asset('assets/images/split_it_logo.png'),
            builder: (BuildContext context, Widget _widget) {
              return new Transform.rotate(
                angle: animationController.value * 40,
                child: _widget,
              );
            }),
        ),

    );

  }

}


