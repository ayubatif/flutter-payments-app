import 'package:flutter/material.dart';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/screens/screen_guest_eventpage.dart';

class GuestJoinEventPage extends StatelessWidget {
  final GuestEvent guestEvent;

  GuestJoinEventPage({Key key, @required this.guestEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JoinForm(guestEvent: guestEvent),
    );

  }
}

class FormData  {
  final String joinName  = JoinFormState().joinNameController.text;
  final int joinPhoneNumber  = JoinFormState().joinPhoneController.hashCode;


}

// Create a Form widget.
class JoinForm extends StatefulWidget {
  final GuestEvent guestEvent;

  const JoinForm({Key key, this.guestEvent}) : super(key: key);
  @override
  JoinFormState createState() {
    return JoinFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class JoinFormState extends State<JoinForm> {
  final _formKey = GlobalKey<FormState>();

  final joinNameController = TextEditingController();
  final joinPhoneController = TextEditingController();

  String dropdownValue = 'Select User';

 // JoinFormState({Key key, @required this.eventTitle}) : super(key: key);

  @override

  void dispose(){
    joinNameController.dispose();
    joinPhoneController.dispose();
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
                  'eventTitle',
                  style: TextStyle(color: Colors.black, fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: Colors.deepPurple
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['One', 'Two', 'Free', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                      .toList(),

                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child:TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Phone Number(Optional)'
                  ),
                     controller: joinPhoneController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(

                  onPressed: () {
                    var route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        GuestEventPage(guestEvent: widget.guestEvent),
                  );
                  Navigator.of(context).push(route);

                  },
                  child: Text('Submit'),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }
}