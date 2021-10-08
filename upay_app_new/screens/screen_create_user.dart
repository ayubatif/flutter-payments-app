import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/screens/screen_landingpage.dart';
import 'package:upayappnew/screens/screen_user_homepage.dart';
import 'package:upayappnew/screens/screen_user_landingpage.dart';
import 'package:upayappnew/services/auth.dart';
import 'package:upayappnew/services/database.dart';

class CreateUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar( title: Text(''),
          backgroundColor: Colors.grey[100],
          elevation: 0.0,
          automaticallyImplyLeading:  true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              color: Colors.lightBlue[300],
              onPressed:() => Navigator.pop(context) ), ),),

      body: CreateOrJoinForm(),

    );

  }
}

class FormData  {
  final String eventTitle = CreateOrJoinFormState().titleController.text;
  final String creatorName  = CreateOrJoinFormState().emailController.text;
  final int phoneNumber  = CreateOrJoinFormState().phoneController.hashCode;
  final int eventId  = CreateOrJoinFormState().idController.hashCode;

}

// Create a Form widget.
class CreateOrJoinForm extends StatefulWidget {
  @override
  CreateOrJoinFormState createState() {
    return CreateOrJoinFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateOrJoinFormState extends State<CreateOrJoinForm> {

  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String error = '';

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String phoneNr = '';
  List <Contact> contactList = new List();
  List <String> pastEvents = new List();
  List <String> eventList = new List();
  String photoURL = '';

  final emailController = TextEditingController();
  final titleController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  User _user;

  /*void dispose(){
    nameController.dispose();
    passwordController.dispose();
    titleController.dispose();
    phoneController.dispose();
    idController.dispose();
    super.dispose();
  }*/
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
                  "Create New User Account",
                  style: TextStyle(color: Colors.lightBlue[300], fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: emailController,

                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.mail),
                      hintText: "Enter your email",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0))),

                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                  //controller: nameController,

                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,


                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Enter a Password",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0))),

                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  //controller: passwordController,

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: nameController,

                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.account_circle),
                      hintText: "Enter your name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0))),

                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  //controller: nameController,

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child:TextFormField(// The validator receives the text that the user has entered.
                  controller: phoneController,

                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.phone),
                      hintText: "Enter Phone Number (Mandatory)",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0))),
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Please enter a correct phone number';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(


                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () async {
                    if(!_formKey.currentState.validate()) {
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text('Username is taken, please enter another')));
                    }else{
                      email = emailController.text;
                      password = passwordController.text;
                      name = nameController.text;
                      phoneNr = phoneController.text;



                      dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, phoneNr, contactList, eventList, pastEvents, photoURL);
                      if(result is String){
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text(result),
                                actions:[
                                  FlatButton(
                                    child: Text("Ok"),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            }
                        );
                      }
//                      if(result == null) {
//                        setState(() { error = 'Please supply a valid email';});
//
//                      }
                      else{
                        // getting signed up user and setting thier data in the DB
                        _user = User(
//                          uid: result.user.uid,
                          email: email,
                          name: name,
                          phoneNr: phoneNr,
                          contactList: contactList,
                          eventIDList: eventList,
                          pastEvents: pastEvents,
                        );
                        var route = MaterialPageRoute(
                            builder: (BuildContext context) =>
                                UserLandingPage(user: _user)
                        );
                        Navigator.of(context).push(route);
                      };
//
                    }; // login should take you to ActivityPage and make calls to database with username and password}
                  },

                  child: Text("Create User",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(

                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () =>
                    Navigator.of(context).pop(context), // login should take you to ActivityPage and make calls to database with username and password
                  child: Text("Cancel",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }
}

