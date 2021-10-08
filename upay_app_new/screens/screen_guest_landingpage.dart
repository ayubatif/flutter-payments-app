import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/screens/screen_guest_eventpage.dart';
import 'package:upayappnew/models/models.dart';

class GuestLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          title: Text(''),
          backgroundColor: Colors.grey[100],
          elevation: 0.0,
          automaticallyImplyLeading: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.lightBlue[300],
              onPressed: () => Navigator.pop(context, '/LoginPage')),
        ),
      ),
      body: CreateOrJoinForm(),
    );
  }
}

class FormData {
  final String eventTitle = CreateOrJoinFormState().titleController.text;
  final String creatorName = CreateOrJoinFormState().nameController.text;
  final int phoneNumber = CreateOrJoinFormState().phoneController.hashCode;
  final int eventId = CreateOrJoinFormState().idController.hashCode;
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
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final _db = Firestore.instance;
  final String GUEST_EVENTS_DB_COLLECTION_NAME = "GuestEvents";
  final String SAMPLE_GUEST_EVENT_NAME = "QahYRjyoLV7KCAQF6uZP";

  GuestEvent _guestEvent;

  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();

  @override
  void dispose() {
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
                  "Create New Event",
                  style:
                      TextStyle(color: Colors.lightBlue[300], fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.label),
                      hintText: "Event Title",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 32.0),
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
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.account_circle),
                      hintText: "Your Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 32.0),
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
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.phone),
                      hintText: "Phone Number (Optional)",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 32.0),
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
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _handleCreateEvent();
                    }
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Join Existing Event",
                  style:
                      TextStyle(color: Colors.lightBlue[300], fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.mobile_screen_share),
                      hintText: "Event ID",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 32.0),
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
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreateEvent() async {
    _guestEvent = new GuestEvent(
      creatorName: nameController.text ?? 'Creator Name',
      numUsers: 1,
      guestUsers: new List<GuestUser>(),
      guestBills: new List<GuestBill>(),
      title: titleController.text ?? 'Some Event',
    );

    await _createFirestoreEvent();

    var route = MaterialPageRoute(
      builder: (BuildContext context) =>
          GuestEventPage(guestEvent: _guestEvent),
    );
    Navigator.of(context).push(route);
  }

  Future<void> _createFirestoreEvent() async {
    _guestEvent.guestUsers.add(new GuestUser(
        balance: 0,
        amountToGet: 0,
        amountToPay: 0,
        name: _guestEvent.creatorName,
        phoneNumber:
            phoneController.text.length > 0 ? phoneController.text : ''));

    await _db
        .collection(GUEST_EVENTS_DB_COLLECTION_NAME)
        .add({}).then((eventRef) {
      _guestEvent.id = eventRef.documentID;
      _db
          .collection(GUEST_EVENTS_DB_COLLECTION_NAME)
          .document(eventRef.documentID)
          .setData(_guestEvent.toJson());
    });
  }

  Future<void> _handleJoinEvent() async {
    await _getFirestoreEvent();
    //print(_guestEvent.toJson());

    var route = MaterialPageRoute(
        builder: (BuildContext context) =>
            GuestEventPage(guestEvent: _guestEvent));
    Navigator.of(context).push(route);
  }

  Future<void> _getFirestoreEvent() async {
    await _db
        .collection(GUEST_EVENTS_DB_COLLECTION_NAME)
        .document(idController.text)
        .get()
        .then((snapshot) {
      _guestEvent = GuestEvent.fromJson(snapshot.data);
    });
  }

/*void handleBackdoor() {

    _guestEvent = new GuestEvent(
      creatorName: 'Fredrik',
      id: '6931thisissampleeventid516',
      numUsers: 1,
      guestUser: new List<GuestUser>(),
      guestBill: new List<GuestBill>(),
      title: 'Dinner at Chilli\'s',
    );
    var creator = new GuestUser(
        balance: 0.00,
        name: _guestEvent.creatorName,
        id: '2141thisissampleuserid414'
    );
    var rndm = new GuestUser(
        balance: 0.00,
        name: 'Random Guy',
        id: '9582thisissampleuserid617'
    );
    var bengt = new GuestUser(
        balance: 0.00,
        name: 'Bengt',
        id: '1382thisissampleuserid747'
    );
    var payee1 = new GuestPayee(
      name: creator.name,
      settled: false,
      debt: 30
    );
    var payee2 = new GuestPayee(
        name: bengt.name,
        settled: false,
        debt: 30
    );
    var payee3 = new GuestPayee(
        name: rndm.name,
        settled: false,
        debt: 30
    );

    var bill1 = new GuestBill(
      date: 'Friday',
      id: '9583thisissamplebillid426',
      payer: creator.name,
      value: 90,
      settled: false,
      guestPayee: new List<GuestPayee>()
    );
    var bill2 = new GuestBill(
        date: 'Monday',
        id: '1551thisissamplebillid831',
        payer: bengt.name,
        value: 60,
        settled: false,
        guestPayee: new List<GuestPayee>()
    );

    _guestEvent.guestUser.add(creator);
    _guestEvent.guestUser.add(bengt);
    _guestEvent.guestUser.add(rndm);
    bill1.guestPayee.add(payee1);
    bill1.guestPayee.add(payee2);
    bill1.guestPayee.add(payee3);
    bill2.guestPayee.add(payee1);
    bill2.guestPayee.add(payee3);
    _guestEvent.guestBill.add(bill1);
    _guestEvent.guestBill.add(bill2);

    var route = MaterialPageRoute(
        builder: (BuildContext context) =>
            GuestEventPage(guestEvent: _guestEvent)
    );
    Navigator.of(context).push(route);
  }*/
}
