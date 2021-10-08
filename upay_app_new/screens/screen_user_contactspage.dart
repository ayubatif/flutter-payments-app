import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:upayappnew/screens/screen_settings.dart';
import 'package:upayappnew/screens/screen_user_homepage.dart';
import 'package:upayappnew/screens/screen_user_profilepage.dart';
import 'package:upayappnew/screens/screen_user_signed_out_page.dart';
import 'package:upayappnew/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:upayappnew/models/user.dart';

class UserContactsPage extends StatefulWidget {
  final Color color;
  User user;
  UserContactsPage({this.color, this.user});


  _UserContactsPageState createState() => _UserContactsPageState();
}

class _UserContactsPageState extends State<UserContactsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = new TextEditingController();
  List<Contact> contactsFiltered = [];


  @override

  void initState() {
    searchController.addListener(() {
      filterContacts();
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(widget.user.contactList);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((userContacts) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = userContacts.toString();
        return contactName.contains(searchTerm);
      }
      );
      setState(() {
        contactsFiltered = _contacts;
      });
    }
    }

    createAlertDialog (BuildContext context) {
    TextEditingController findFriendController = TextEditingController();
    return showDialog (context: context, builder: (context) {
    return AlertDialog (
      title: Text ('Friends Phone Number'),
      content: TextField (
        controller: findFriendController,
      ),
      actions:  <Widget> [
        MaterialButton(
          elevation: 5.0,
          child: Text ('Add'),
          onPressed: () {
            Query findPhoneNr = Db.instance.collection(Db.USERS_DB_COLLECTION_NAME).where('phoneNr', isEqualTo: findFriendController.text);
            findPhoneNr.snapshots().listen(
                (userData) {
                  try {
                    setState(() {
                      var contact = new Contact(
                        id: '${userData.documents[0].documentID}',
                        name: '${userData.documents[0]['name']}',
                        phoneNr: '${userData.documents[0]['phoneNr']}',
                      );
                      widget.user.contactList.add(contact);
                      updateDb();
                      Navigator.of(context).pop();
                    });
                  } catch(Exception) {
                    //TODO show that the number entered doesn't match any users
                    ;
                  }

                }
            );

          },
        )
      ]
    );
    });
    }


  @override

  Widget build(BuildContext context) {

    bool isSearching = searchController.text.isNotEmpty;
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
          title: Text('My Contacts',
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
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person_add),
          children: [
            SpeedDialChild (
                child: Icon(Icons.person_add),
                label: 'Add Friends From SplitIt',
                onTap: (){
                  createAlertDialog(context).then(
                      (onValue) {},
                  );
                },
            ),
            SpeedDialChild (
                child: Icon(Icons.person_add),
                label: 'Add Friends From Contactlist',
                onTap: (){
                },
            ),
          ]
        ),

        backgroundColor: Colors.grey[100],
//        appBar:
//        PreferredSize(
//            preferredSize: Size.fromHeight(60.0),
//            child: AppBar(
//              actions: <Widget>[
//                IconButton(
//                  icon: Icon(
//                    Icons.update,
//                    color: Colors.lightBlue[300],
//                  ),
//                  onPressed: () {
//                    refreshUser();
//                  },
//                ),
//              ],
//              centerTitle: true,
//              title: Text('My Contacts',
//              style: TextStyle(
//               color: Colors.lightBlue[300], fontSize: 24.0, fontWeight: FontWeight.bold,
//            )),
//              backgroundColor: Colors.white,
//              elevation: 3,
//              automaticallyImplyLeading:  true,
//              leading: IconButton(icon: Icon(Icons.arrow_back_ios),
//                  color: Colors.lightBlue[300]
//                  , onPressed:() => Navigator.pop(context, '/UserSignedIn') ), ), ),
         body: Container(
        child: Column(
          children: <Widget> [
            Container(
                padding: EdgeInsets.fromLTRB(10,10,10,5),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                      border: new OutlineInputBorder(
                    borderSide: new BorderSide(
                    color: Theme.of(context).primaryColor
                )
                ),
                    prefixIcon: Icon(
                    Icons.search,
                      color: Theme.of(context).primaryColor
                   )
                )
              )
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 468
              ),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: isSearching == true ? contactsFiltered.length : widget.user.contactList.length,
                  itemBuilder: (context,index)
                      {
                        Contact contact = isSearching == true ? contactsFiltered[index] : widget.user.contactList[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          color: Colors.lightBlueAccent,
                          elevation: 5,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(contact.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),
                                Text(contact.phoneNr,

                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )],
                            )
                          ),
                        );
                      }
              ),
            )
          ]
        )
      )
    );
  }

  Future updateDb() async {
    print(widget.user.toJson());
    FirebaseAuth mAuth = FirebaseAuth.instance;
    FirebaseUser currentUser = await mAuth.currentUser();
    await Db.instance.collection(Db.USERS_DB_COLLECTION_NAME).document(currentUser.uid).setData(widget.user.toJson());
  }
  Future<void> refreshUser() async {
    FirebaseAuth math = FirebaseAuth.instance;
    FirebaseUser currentUser = await math.currentUser();
    await Firestore.instance.collection('Users').document(currentUser.uid).get()
        .then((snapshot) {
      widget.user= User.fromJson(snapshot.data);

    });

    setState(() {

    });
  }
}


