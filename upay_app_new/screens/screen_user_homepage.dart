import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/screens/screen_settings.dart';
import 'package:upayappnew/services/auth.dart';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/screens/screen_user_create_event.dart';
import 'package:upayappnew/screens/screen_guest_landingpage.dart';
import 'package:upayappnew/screens/screen_user_signed_out_page.dart';
import 'package:upayappnew/screens/screen_user_profilepage.dart';

import 'package:flutter/widgets.dart';

import 'package:upayappnew/screens/screen_user_contactspage.dart';
import 'package:upayappnew/screens/screen_user_historypage.dart';

import 'package:share/share.dart';
import 'package:upayappnew/screens/screen_user_eventpage.dart';
import 'screen_bill_info.dart';

class UserHomePage extends StatefulWidget {

  User user;
  UserHomePage({Key key, @required this.user}) : super(key: key);

  @override
  UserHomePageState createState() => UserHomePageState();
}


class UserHomePageState extends State<UserHomePage> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Firestore db = Firestore.instance;
  List<Event> events = new List();
  List <double> userBalances = new List();
  bool isLoaded = false;
  bool isMounted = false;

  void initState() {

    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 1),

    );
    animationController.repeat();
    isMounted = true;
    _getFirestoreEvent().then((_) {

      if (isMounted) {
        setState(() {
          isLoaded = true;
        });
      }
    });
  }
  @override
  void unmount () {
    isMounted = false;
  }
  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }
  Future<void> _getFirestoreEvent() async {
    userBalances = new List ();
    for (int i=0; i<widget.user.eventIDList.length; i++) {
      await db.collection("Events").document(widget.user.eventIDList[i]).get()
          .then((snapshot) {
        events.add(Event.fromJson(snapshot.data));
        for (GuestUser dog in events[i].guestUsers) {
          if(widget.user.phoneNr == dog.phoneNumber) {
            userBalances.add(dog.balance);
          }
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.update,
              color: Colors.black,
            ),
            onPressed: () {
              refreshUser();
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.account_circle, color: Colors.black,
            size: 45,),
          onPressed: () => scaffoldKey.currentState.openDrawer(),
        ),
        centerTitle: true,
        title: Text(widget.user.name,
        style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.blue[400],),

      drawer: Drawer(

        child: ListView(
          children: <Widget>[
            DrawerHeader( decoration: BoxDecoration(gradient: LinearGradient(colors: <Color>[
              Colors.lightBlue,
            Colors.lightBlueAccent])
            ),
                child: Container(child: Column(children: <Widget>[
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    elevation: 10,
                    child: Padding(padding: EdgeInsets.all(6.0),
                    child: Image.asset('assets/images/split_it_logo.png', width: 110, height: 110,),),)
                ],),)
            ),
         CustomListTile(Icons.person,'Profile', ()=>  Navigator.of(context).push(new MaterialPageRoute(
             builder: (BuildContext context) => UserProfilePage(user: widget.user)))
           ,),
            CustomListTile(Icons.settings,'Settings', ()=>   Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>  SettingsOnePage(user: widget.user)))
              ,),
            CustomListTile(Icons.lock_open,'Logout', ()=>
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new UserSignedOut()))
            ,),
        ],),
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, ),
        onPressed: () {
          var route = MaterialPageRoute(
              builder: (BuildContext context) =>
                  UserCreateEvent(user: widget.user)
          );
          Navigator.of(context).push(route);
        },
      ),
      backgroundColor: Colors.grey[100],
      body: (isLoaded) ? Center(
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Center(
                  child: Text(
                    "Open Events",
                    style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),

            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 468
              ),
              child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: events.length,
                    itemBuilder: (context,eventIndex)
                    {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        color: Colors.lightBlueAccent,
                        elevation: 5,
                        child: ListTile(
                          /*subtitle: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: events[eventIndex].billList.length,
                              itemBuilder: (context,billIndex)
                              {
                                return ListTile (
                                  leading: Text(
                                    events[eventIndex].billList[billIndex].title,
                                  ),
                                  trailing: Text(
                                    events[eventIndex].billList[billIndex].value.toString(),
                                  ),
                                );
                              }
                          ), */
                           subtitle: Text(
                              'Balance: ' + userBalances[eventIndex].toString(),
                             style: TextStyle(
                              color: (userBalances[eventIndex] < 0) ? Colors.red :
                              (userBalances[eventIndex] > 0) ? Colors.green[800] : Colors.black,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          title: Text(
                            events[eventIndex].title+' created by ' + events[eventIndex].creatorName,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                          ),

                          trailing: IconButton(
                            icon: Icon(Icons.navigate_next, color: Colors.white),
                            onPressed: (){
                                var route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserEventPage(event: events[eventIndex], user: widget.user),
                                );
                                Navigator.of(context).push(route);
                            },
                          ),

                        ),
                      );
                    }
                ),
            ),


            ],
          ),
        ),
      ) : new Center(
        child: new AnimatedBuilder(
            animation: animationController,
            child: Image.asset('assets/images/split_it_logo.png'),
            builder: (BuildContext context, Widget _widget) {
              return new Transform.rotate(
                angle: animationController.value * 10,
                child: _widget,
              );
            }),
      ),
    );
  }

  Future<void> refreshUser() async {
    FirebaseAuth math = FirebaseAuth.instance;
    FirebaseUser currentUser = await math.currentUser();
    await Firestore.instance.collection('Users').document(currentUser.uid).get()
        .then((snapshot) {
      widget.user= User.fromJson(snapshot.data);

    });
    events = new List();
    await _getFirestoreEvent();
    setState(() {

    });
  }
}
class CustomListTile extends StatelessWidget{
  IconData icon;
  String text;
  Function onTap;
  CustomListTile(this.icon,this.text,this.onTap);
  @override
  Widget build(BuildContext context) {

  //TODO: implemment build
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container( decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey.shade400))
    ),
      child: InkWell(
        splashColor: Colors.lightBlue[300],
        onTap: onTap,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
             Row(
               children: <Widget>[
                 Icon(icon),
                 Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Text(text, style: TextStyle(fontSize: 16.0

                   ),),
                 )
               ],
             ),
              Icon(Icons.arrow_right)
              ],
            ),
          )

          ),
    ),
  );
}

}
