import 'package:flutter/material.dart';
import 'package:upayappnew/screens/screen_guest_eventpage.dart';
import 'package:upayappnew/screens/screen_guest_joineventpage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar( title: Text(''),
          automaticallyImplyLeading:  true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios)
              , onPressed:() => Navigator.pop(context, '/Landing') ), ),),

      body: CreateOrJoinForm(),

    );

  }
}

class FormData  {
  final String eventTitle = CreateOrJoinFormState().titleController.text;
  final String creatorName  = CreateOrJoinFormState().nameController.text;
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


  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();
  @override

  void dispose(){
    nameController.dispose();
    titleController.dispose();
    phoneController.dispose();
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
                  "Login Page",
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.account_circle),
                      hintText: "Your Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0))),
                  /*validator: (value) {
                if (value.isEmpty) {
                  return 'You must enter a name';
                }
                return null;
              }, */
                  controller: nameController,

                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child:TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.phone),
                      hintText: "Phone Number (Optional)",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0))),
                  //   controller: phoneController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(

                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),

                  /*onPressed: () {var route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EventPage(eventTitle: titleController.text,creatorName: nameController.text,),
                  );
                  if (_formKey.currentState.validate())
                    Navigator.of(context).push(route);

                  },*/
                  child: Text("Submit",style: TextStyle(
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

