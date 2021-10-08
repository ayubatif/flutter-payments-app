import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/screens/screen_user_landingpage.dart';
import 'package:upayappnew/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> genJSON() async {
  //TODO get JSON data
  final db = Firestore.instance;
  final DocumentReference eventRef =
      db.collection('GuestEvents').document('mgUc8Sr7nE7yw4rnJUOE');
  final DocumentReference userRef = db
      .collection('GuestEvents')
      .document('mgUc8Sr7nE7yw4rnJUOE')
      .collection("GuestUsers")
      .document('aek4ULXflNNtV0ufxPQf');
  final DocumentReference billRef = db
      .collection('GuestEvents')
      .document('mgUc8Sr7nE7yw4rnJUOE')
      .collection('GuestBills')
      .document('qz6hzVlSfjjL8bkMSOJ8');
  final DocumentReference payeeRef = db
      .collection('GuestEvents')
      .document('mgUc8Sr7nE7yw4rnJUOE')
      .collection('GuestBills')
      .document('qz6hzVlSfjjL8bkMSOJ8')
      .collection('GuestPayees')
      .document('aek4ULXflNNtV0ufxPQf');

  await eventRef.get().then<dynamic>((DocumentSnapshot snapshot) async {
    print(snapshot.data);
  });
  await userRef.get().then<dynamic>((DocumentSnapshot snapshot) async {
    print(snapshot.data);
  });
  await billRef.get().then<dynamic>((DocumentSnapshot snapshot) async {
    print(snapshot.data);
  });
  await payeeRef.get().then<dynamic>((DocumentSnapshot snapshot) async {
    print(snapshot.data);
  });
}

class LandingPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _formKey = GlobalKey<FormState>();

  var _db = Firestore.instance;

  var _uid;
  User _user;

  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FocusNode myFocusNode = new FocusNode();
  FocusNode myFocusNode1 = new FocusNode();


  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[300],
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80.0),
                    child: Container(
                        height: 180,
                        child: Image.asset('assets/images/split_it_logo.png')),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            style: new TextStyle(color: Colors.black),
                            controller: emailController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon:
                                    Icon(Icons.mail, color: Colors.black),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0))),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            style: new TextStyle(color: Colors.black),
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.black),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Column(children: [
                        RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          elevation: 7,
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Wrong Username or Password, please try again')));
                            } else {
                              email = emailController.text;
                              password = passwordController.text;
                              _uid = await _auth.signInWithEmailAndPassword(
                                  email, password);
                              if (_uid is String) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(_uid),
                                        actions: [
                                          FlatButton(
                                            child: Text("Ok"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              } else {
                                _handleGetUser();
                              }
                              //Navigator.pushNamed(context, '/activityPage');
                            }
                            ; // login should take you to ActivityPage and make calls to database with username and password}
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue[300],
                                fontSize: 20),
                          ),
                        ),
                        RaisedButton(
                          elevation: 7,
                          onPressed: () {
                            Navigator.pushNamed(context, '/createUser');
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue[300],
                                fontSize: 20),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/guestLanding');
                          },
                          child: Text('Continue as Guest',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                              )),
                        )
                      ]),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _handleGetUser() async {
    await _getFirestoreUser();
    print(_user.toJson());

    var route = MaterialPageRoute(
        builder: (BuildContext context) => UserLandingPage(user: _user));
    Navigator.of(context).push(route);
  }

  Future<void> _getFirestoreUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    await _db.collection('Users').document(currentUser.uid).get()
        .then((snapshot) {
          print(snapshot.data);
          _user = User.fromJson(snapshot.data);
    });
  }
}
