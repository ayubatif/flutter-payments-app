import 'package:flutter/material.dart';

class EventFinishedPage extends StatelessWidget {
  // This widget is the root of your application.
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        color: Colors.lightGreenAccent,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),


           child: IconButton(onPressed: (){},
              icon: Icon(Icons.check_circle),
             color: Colors.green,
              tooltip: 'Event Closed',
            ),
            ),


            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                //Navigator.pushNamed(context, '/Landing');
              },
              child: Text('Return (to Homepage)',
                  style: TextStyle(
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
