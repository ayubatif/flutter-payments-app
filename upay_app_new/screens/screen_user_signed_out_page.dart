import 'package:flutter/material.dart';
import 'package:upayappnew/screens/screen_user_homepage.dart';

class UserSignedOut extends StatelessWidget {
  // This widget is the root of your application.
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Text('User Signed Out Successfully!',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              )),
            ),


            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Landing');
              },
              child: Text('Return to Login Page',
                  style: TextStyle(
                    fontSize: 20.0,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  )),
            )



          ],

        ),
      ),

    ); // This trailing comma makes auto-formatting nicer for build methods.

  }
}
