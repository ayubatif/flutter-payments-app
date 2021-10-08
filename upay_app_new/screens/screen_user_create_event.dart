import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/screens/screen_guest_eventpage.dart';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/screens/screen_user_eventpage.dart';

class UserCreateEvent extends StatelessWidget {
  User user;
  UserCreateEvent({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar( title: Text(''),
          backgroundColor: Colors.grey[100],
          elevation: 0.0,
          automaticallyImplyLeading:  true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              color: Colors.lightBlue[300]
              , onPressed:() => Navigator.pop(context, '/LoginPage') ), ),),

      body: CreateOrJoinForm(user: user,),

    );
  }
}

class FormData  {
  final String eventTitle = CreateOrJoinFormState().titleController.text;
  final int eventId  = CreateOrJoinFormState().idController.hashCode;

}

// Create a Form widget.
class CreateOrJoinForm extends StatefulWidget {
  User user;
  CreateOrJoinForm({this.user});

  @override
  CreateOrJoinFormState createState() {
    return CreateOrJoinFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateOrJoinFormState extends State<CreateOrJoinForm> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final _db = Firestore.instance;
  final String SAMPLE_EVENT_NAME ="mgUc8Sr7nE7yw4rnJUOE";

  Event _event;

  bool isInEvent = false;
  bool isInvalidEvent = false;

  final titleController = TextEditingController();
  final idController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    idController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Create New Event",
                  style: TextStyle(color: Colors.lightBlue[300], fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.label),
                      hintText: "Event Title",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0))),
                  /* validator: (value) {
                if (value.isEmpty) {
                  return 'Event must have a name';
                }
                return null;
              },*/
                  controller: titleController,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(

                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),

                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _handleCreateEvent();
                    }
                  },
                  child: Text("Submit",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Join Existing Event",
                  style: TextStyle(color: Colors.lightBlue[300], fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.mobile_screen_share),
                      hintText: "Event ID",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0))),
                  /* validator: (value) {
                if (value.isEmpty) {
                  return 'Event must have an ID';
                }
                return null;
              },*/

                  controller: idController,

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(

                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),

                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _handleJoinEvent();
                    }
                  },
                  child: Text("Submit",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),),
                ),
              ),
              isInEvent ?
              Center(
                  child: Text('Event already joined',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 20),)
              )
                  : SizedBox(),
              isInvalidEvent ?
              Center(
                  child: Text('Event doesn\'t exist',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 20),)
              )
                  : SizedBox(),
            ],
          ),
        ),

      ),
    );
  }

  Future<void> _handleCreateEvent() async {
    _event = new Event(
      creatorName: widget.user.name,
      title: titleController.text ?? 'Untitled Event',
      numUsers: 1,
      billList: new List(),
      guestUsers: new List(),
    );

    FirebaseAuth mAuth = FirebaseAuth.instance;
    FirebaseUser currentUser = await mAuth.currentUser();
    _event.guestUsers.add(
      new GuestUser(
          balance: 0,
          amountToGet: 0,
          amountToPay: 0,
          name: widget.user.name,
          phoneNumber: widget.user.phoneNr,
          id: currentUser.uid,
      )
    );

    await _createFirestoreEvent();

    var route = MaterialPageRoute(
      builder: (BuildContext context) =>
          UserEventPage(event: _event, user: widget.user)
    );
    Navigator.of(context).push(route);
  }

  Future<void> _createFirestoreEvent() async {
    //add event to db
    await _db.collection('Events').add(_event.toJson())
        .then((eventRef) {
          widget.user.eventIDList.add(eventRef.documentID);
          _event.id = eventRef.documentID;
          _db.collection('Events').document(eventRef.documentID).setData(
              _event.toJson()
          );
        });
    //add user eventlist entry
    FirebaseAuth mAuth = FirebaseAuth.instance;
    FirebaseUser currentUser = await mAuth.currentUser();
    await _db.collection("Users").document(currentUser.uid).setData(widget.user.toJson());
  }

  Future<void> _handleJoinEvent() async {

    if( widget.user.eventIDList.contains(idController.text)) {
     setState(() {
       isInEvent = true;
     });
   }
   else {
     await _getFirestoreEvent();
    if (_event == null) {
      setState(() {
        isInvalidEvent = true;
      });
    }
    else {
      var route = MaterialPageRoute(
          builder: (BuildContext context) =>
              UserEventPage(event: _event, user: widget.user)
      );
      Navigator.of(context).push(route);
    }

   }


  }

  Future<void> _getFirestoreEvent() async {
    await _db.collection("Events").document(idController.text).get()
        .then((snapshot) => _event = (snapshot.data == null) ? null : Event.fromJson(snapshot.data));
  }
}

