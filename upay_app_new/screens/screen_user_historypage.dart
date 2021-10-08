import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/screens/screen_settings.dart';
import 'package:upayappnew/screens/screen_user_eventpage.dart';
import 'package:upayappnew/screens/screen_user_homepage.dart';
import 'package:upayappnew/screens/screen_user_profilepage.dart';
import 'package:upayappnew/screens/screen_user_signed_out_page.dart';

class UserHistoryPage extends StatefulWidget {
  User user;
  final Color color;

  UserHistoryPage({this.color, this.user});

  @override
  State<StatefulWidget> createState() {

    return new UserHistoryPageState();
  }
}

class UserHistoryPageState extends State<UserHistoryPage> {
  Firestore db = Firestore.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Event> pastEvents = new List();
  List <double> userPaid = new List();
  List <double> userGot = new List();
  bool isLoaded = false;

  void initState() {
    _getFirestoreEvent().then((_) {
      setState(() {
        isLoaded = true;
      });
    });
  }
  Future<void> _getFirestoreEvent() async {
    userGot = new List();
    userPaid = new List();
    for (int i=0; i<widget.user.pastEvents.length; i++) {
      await db.collection("Events").document(widget.user.pastEvents[i]).get()
          .then((snapshot) {
        pastEvents.add(Event.fromJson(snapshot.data));
        for (GuestUser dog in pastEvents[i].guestUsers) {
          if(widget.user.phoneNr == dog.phoneNumber) {
            userGot.add(dog.amountToGet);
            userPaid.add(dog.amountToPay);
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
        title: Text('My History',
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
            CustomListTile(Icons.error_outline,'About', ()=>   Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new SettingsOnePage()))
              ,),

          ],),
      ),

      backgroundColor: Colors.grey[100],
      body: Center(
        child: SafeArea(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Center(
                    child: Text(
                      "Finished Events",
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
                      itemCount: pastEvents.length,
                      itemBuilder: (context,pastEventIndex) {
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          color: Colors.lightBlueAccent,
                          elevation: 5,
                          child: ListTile(
                            subtitle: Text(
                              //TODO add total paid amount
                              'You Paid: ' + userPaid[pastEventIndex].toString() + ' in total\n'+ 'You Received: '  + userGot[pastEventIndex].toString() + ' in total ',
                                  //"???kr Total",
                            ),
                            title: Text(
                              pastEvents[pastEventIndex].title+' created by ' + pastEvents[pastEventIndex].creatorName,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                            ),

                            trailing: IconButton(
                              icon: Icon(Icons.navigate_next, color: Colors.white),
                              onPressed: (){
                                var route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserEventPage(event: pastEvents[pastEventIndex], user: widget.user),
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
            )
        ),
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

    pastEvents = new List();
    await _getFirestoreEvent();
    setState(() {

    });
  }
}
