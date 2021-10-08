import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/screens/screen_addFriendsToEventList.dart';
import 'package:upayappnew/screens/screen_guest_landingpage.dart';
import 'package:upayappnew/screens/screen_createbillpage.dart';
import 'package:share/share.dart';
import 'package:upayappnew/screens/screen_user_bill_info.dart';
import 'package:upayappnew/screens/screen_user_createbillpage.dart';
import 'package:upayappnew/screens/screen_user_homepage.dart';
import 'package:upayappnew/screens/screen_user_settlepage.dart';
import 'package:upayappnew/services/db.dart';

import 'screen_bill_info.dart';

class UserEventPage extends StatefulWidget {
  User user;
  Event event;

  UserEventPage({this.user, this.event});

  @override
  _UserEventPageState createState() => _UserEventPageState();
}

class _UserEventPageState extends State<UserEventPage> {
  bool showAddUserField = false;
  TextEditingController newUser = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    refreshEvent();

    final FormData formData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(
            title: Center(
              child: SelectableText(
                'Event ID: ' + widget.event.id,
                style: TextStyle(color: Colors.lightBlue[300], fontSize: 14.0),
              ),
            ),
            backgroundColor: Colors.grey[100],
            elevation: 0.0,
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.lightBlue[300],
                onPressed: () => Navigator.of(context).pop()),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.update,
                  color: Colors.lightBlue[300],
                ),
                onPressed: () {
                  refreshEvent();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.lightBlue[300],
                ),
                onPressed: () {
                  Share.share(
                      "Hello! Your friend wants you to join UPay, https://upayappnew.page.link/QXTh Event id: " +
                          widget.event.id);
                },
              ),
            ],
          ),
        ),
        body: Center(
            child: SafeArea(
          child: ListView(
            children: <Widget>[
              Center(
                child: Text('Host: ' + widget.event.creatorName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[300])),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    widget.event.title,
                    style: (TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[300],
                        fontSize: 28)),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 105),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: widget.event.guestUsers.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Column(
                              children: <Widget>[
                                (index != 0)
                                    ? Text(
                                        widget.event.guestUsers[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightBlue[300]),
                                      )
                                    : SizedBox(height: 0),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      var route = MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddFriendsToEventList(
                          user: widget.user,
                          event: widget.event,
                        ),
                      );
                      Navigator.of(context).push(route);

                      showAddUserField = true;
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  color: Colors.lightBlue[300],
                  label: (Text(
                    "Add From Contact List",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FlatButton.icon(
                  onPressed: () {
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserCreateBillPage(event: widget.event),
                    );
                    Navigator.of(context).push(route);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  ),
                  color: Colors.lightBlue[300],
                  label: (Text(
                    "Bills",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  )),
                ),
              ),
              widget.event.billList != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.event.billList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: widget.event.billList[index].type ==
                                "payment"
                                ? Colors.lightBlue[50]
                                : Colors.white,
                            child: ListTile(
                              onTap: () {
                                var route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserBillInfoPage(
                                          event: widget.event,
                                          billIndex: index),
                                );
                                Navigator.of(context).push(route);
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  widget.event.billList[index].type !=
                                      'payment'
                                      ? IconButton(
                                    icon: Icon(Icons.content_copy,
                                        color: Colors.lightBlue[300]),
                                    onPressed: () {
                                      final snackBar = SnackBar(
                                          content: Text(
                                              'Bill: ${widget.event.billList[index].title} has been duplicated!'));
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                      widget.event.billList.add(
                                          widget.event
                                              .billList[index]);
                                      for (int i = 0;
                                      i <
                                          widget.event.guestUsers
                                              .length;
                                      i++) {
                                        if (widget.event
                                            .guestUsers[i].name ==
                                            widget
                                                .event
                                                .billList[index]
                                                .payer) {
                                          widget.event.guestUsers[i]
                                              .amountToGet +=
                                              widget
                                                  .event
                                                  .billList[index]
                                                  .value;
                                        }
                                        for (int j = 0;
                                        j <
                                            widget
                                                .event
                                                .billList[index]
                                                .payeeList
                                                .length;
                                        j++) {
                                          if (widget.event
                                              .guestUsers[i].name ==
                                              widget
                                                  .event
                                                  .billList[index]
                                                  .payeeList[j]
                                                  .name) {
                                            widget
                                                .event
                                                .guestUsers[i]
                                                .amountToPay +=
                                                widget
                                                    .event
                                                    .billList[index]
                                                    .payeeList[j]
                                                    .debt;
                                          }
                                        }
                                        widget.event.guestUsers[i]
                                            .balance = widget
                                            .event
                                            .guestUsers[i]
                                            .amountToGet -
                                            widget
                                                .event
                                                .guestUsers[i]
                                                .amountToPay;
                                      }
                                      ;
                                      _updateDb();
                                      setState(() {});
                                    },
                                  )
                                      : SizedBox(),

                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.lightBlue[300]),
                                onPressed: () {
                                  for (int i = 0;
                                      i < widget.event.guestUsers.length;
                                      i++) {
                                    if (widget.event.guestUsers[i].name ==
                                        widget.event.billList[index]
                                            .payer) {
                                      widget.event.guestUsers[i]
                                              .amountToGet -=
                                          widget.event.billList[index]
                                              .value;

                                      print("entered if");
                                    }

                                    for (int j = 0;
                                        j <
                                            widget.event.billList[index]
                                                .payeeList.length;
                                        j++) {
                                      if (widget
                                              .event.guestUsers[i].name ==
                                          widget.event.billList[index]
                                              .payeeList[j].name) {
                                        widget.event.guestUsers[i]
                                                .amountToPay -=
                                            widget.event.billList[index]
                                                .payeeList[j].debt;
                                      }
                                    }
                                    widget.event.guestUsers[i].balance =
                                        widget.event.guestUsers[i]
                                                .amountToGet -
                                            widget.event.guestUsers[i]
                                                .amountToPay;
                                  }
                                  ;
                                  widget.event.billList.removeAt(index);
                                  _updateDb();
                                  setState(() {});
                                },
                              ), ],
                            ),
                              title: Text(widget.event.billList[index].title ??
                                  'No title'),
                              subtitle: Text(widget.event.billList[index].value
                                      .toString() ??
                                  'No value'),
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: RaisedButton(
                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserSettlePage(event: widget.event),
                    );
                    Navigator.of(context).push(route);
                  },
                  child: Text(
                    'Settle Payments',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: RaisedButton(
                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    _handleUserSettleEvent();
                  },
                  child: Text(
                    'Remove event from homepage',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  void _updateDb() async {
    Db.instance
        .collection('Events')
        .document(widget.event.id)
        .setData(widget.event.toJson());
  }

  Future<void> refreshEvent() async {
    await Db.instance
        .collection('Events')
        .document(widget.event.id)
        .get()
        .then((snapshot) {
      setState(() {
        widget.event = Event.fromJson(snapshot.data);
      });
    });
  }

  Future<void> _handleUserSettleEvent() async {
    widget.user.eventIDList.remove(widget.event.id);
    widget.user.pastEvents.add(widget.event.id);
    FirebaseAuth mAuth = FirebaseAuth.instance;
    FirebaseUser currentUser = await mAuth.currentUser();
    await Firestore.instance
        .collection("Users")
        .document(currentUser.uid)
        .setData(widget.user.toJson());
    Navigator.pop(context, widget.user);
  }

/*
  Future<void> getUsers() async {
    widget.users = new List();
    for(String userID in widget.event.userIDList) {
      Db.instance.collection('Users').document(userID).get().then(
              (snapshot) => widget.users.add(User.fromJson(snapshot.data))
      );
    }
  }
   */
}
