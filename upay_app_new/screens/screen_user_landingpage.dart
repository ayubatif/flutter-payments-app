import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/screens/screen_user_contactspage.dart';
import 'package:upayappnew/screens/screen_user_historypage.dart';
import 'package:upayappnew/screens/screen_user_homepage.dart';


  class UserLandingPage extends StatefulWidget {
    User user;
    UserLandingPage({@required this.user});
    @override
    UserLandingPageState createState() => UserLandingPageState();
  }


class UserLandingPageState extends State<UserLandingPage> {

  void onTabTapped(int index) {
    print(widget.user.toJson());
    setState(() {
      switch(index){
        case 0:
          _child = UserHomePage(user: widget.user);
          break;
        case 1:
          _child = UserContactsPage(user: widget.user, color: Colors.white,);
          break;
        case 2:
          _child = UserHistoryPage(user: widget.user, color: Colors.white,);

      }
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;
  Widget _child;

  void initState(){
    _child = UserHomePage(user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _child, // new
      bottomNavigationBar: CurvedNavigationBar(
        onTap: onTabTapped, // new
        index: _currentIndex, // new
        color: Colors.blue[400],
        animationDuration: Duration(
          milliseconds: 300
        ),
        backgroundColor: Colors.grey[100],
        height: 50,
        items: [
          Icon(Icons.home),
          Icon(Icons.contacts),
          Icon(Icons.history),
        ],
      ),
    );
  }
}