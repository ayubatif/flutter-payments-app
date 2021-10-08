import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:upayappnew/screens/screen_user_eventpage.dart';
import 'package:upayappnew/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/models/models.dart';

class AddFriendsToEventList extends StatefulWidget {
  final Color color;
  User user;
  Event event;
  AddFriendsToEventList({this.color, this.user, this.event});
  _AddFriendsToEventListState createState() => _AddFriendsToEventListState();
}

class _AddFriendsToEventListState extends State<AddFriendsToEventList> {
  TextEditingController searchController = new TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> contactsFiltered = [];
  List<bool> selectedFriends = [];
  List<GuestUser> userFriends = [];
  List<String> IDInEvent = [];
  @override
  filterContacts() {

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

  @override
  void initState() {
    for(GuestUser user in widget.event.guestUsers) IDInEvent.add(user.id);
    selectedFriends = new List ();
    for(int i = 0; i < widget.user.contactList.length;i++){
      selectedFriends.add(false);
      userFriends.add(new GuestUser(
          balance: 0, name: widget.user.contactList[i].name, amountToGet: 0, amountToPay: 0, phoneNumber: widget.user.contactList[i].phoneNr, id: widget.user.contactList[i].id));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar:
        PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(
            centerTitle: true,
            title: Text('My Contacts',
                style: TextStyle(
                  color: Colors.lightBlue [300],
                )),
            backgroundColor: Colors.grey[100],
            elevation: 0.0,
            automaticallyImplyLeading:  true,
            leading: IconButton(icon: Icon(Icons.arrow_back_ios),
                color: Colors.lightBlue[300]
                , onPressed:() => Navigator.pop(context) ), ), ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                children: <Widget> [
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount:  widget.user.contactList.length,
                        itemBuilder: (context,index)
                        {
                          return CheckboxListTile(
                            title: Text(widget.user.contactList[index].name),
                            subtitle: Text(widget.user.contactList[index].phoneNr),
                            value: selectedFriends[index],
                            onChanged: (val) {
                              setState(() {
                              selectedFriends[index] = val;
                            }
                              );
                            },
                          )
                          ;
                        }
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FlatButton.icon(onPressed: (){
                      setState(() {
                      for(int i = 0; i< widget.user.contactList.length; i++){
                        if(!IDInEvent.contains(widget.user.contactList[i].id) && selectedFriends[i]){
                          widget.event.guestUsers.add(userFriends[i]);
                          widget.event.numUsers++;
                        }
                      }
                      _updateDb();
                      Navigator.of(context).pop();
                    });},
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      icon: Icon(Icons.person_add, color: Colors.white,),
                      color: Colors.lightBlue[300],
                      label: (Text("Add",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),)),
                    ),
                  ),
                ]
            )
        )
    );
  }

  void _updateDb() async {
    Firestore.instance.collection('Events').document(widget.event.id).setData(widget.event.toJson());
  }
}

