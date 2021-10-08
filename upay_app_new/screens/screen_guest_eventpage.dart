import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/screens/screen_guest_landingpage.dart';
import 'package:upayappnew/screens/screen_createbillpage.dart';
import 'package:share/share.dart';
import 'package:upayappnew/screens/screen_guest_settlepage.dart';
import 'screen_bill_info.dart';

class GuestEventPage extends StatefulWidget {
  GuestEvent guestEvent;

  GuestEventPage({Key key, @required this.guestEvent}) : super(key: key);

  @override
  _GuestEventPageState createState() => _GuestEventPageState();
}

class _GuestEventPageState extends State<GuestEventPage> {
  final _db = Firestore.instance;
  final String GUEST_EVENTS_DB_COLLECTION_NAME = "GuestEvents";
  final String GUEST_USERS_DB_COLLECTION_NAME = "GuestUsers";
  final String GUEST_BILLS_DB_COLLECTION_NAME = "GuestBills";
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
                'Event ID: ' + widget.guestEvent.id,
                style: TextStyle(color: Colors.lightBlue[300], fontSize: 14.0),
              ),
            ),
            backgroundColor: Colors.grey[100],
            elevation: 0.0,
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.lightBlue[300],
                onPressed: () => Navigator.pop(context, '/guestJoinEvent')),
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
                          widget.guestEvent.id);
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
                child: Text('Host: ' + widget.guestEvent.creatorName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[300])),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    widget.guestEvent.title,
                    style: (TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[300],
                        fontSize: 28)),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 105),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.guestEvent.guestUsers.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Column(
                        children: <Widget>[
                          (index != 0)
                              ? Text(
                                  widget.guestEvent.guestUsers[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlue[300]),
                                )
                              : SizedBox(height: 0),
                        ],
                      );
                    }),
              ),
              (showAddUserField == true)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 80.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: newUser,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  prefixIcon: Icon(Icons.label),
                                  hintText: "Enter nickname",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue[300],
                                          width: 32.0),
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 32.0),
                                      borderRadius:
                                          BorderRadius.circular(25.0))),
                              // controller: titleController,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            color: Colors.blueAccent,
                            onPressed: () {
                              List<String> userNames = new List<String>();
                              newUser.text = newUser.text.trim();
                              for (var user in widget.guestEvent.guestUsers)
                                userNames.add(user.name);
                              if ((newUser.text.length > 0) &&
                                  !(userNames.contains(newUser.text))) {
                                var myUser = new GuestUser(
                                    balance: 0,
                                    name: newUser.text,
                                    amountToGet: 0,
                                    amountToPay: 0);
                                widget.guestEvent.guestUsers.add(myUser);
                                widget.guestEvent.numUsers++;
                                _updateDb();
                                setState(() {
                                  showAddUserField = false;
                                  newUser.clear();
                                });
                              }
//                            else if (!(newUser.text.length > 0)) {
//                              final snackBar = SnackBar(content: Text('Please type a name!'));
//                              Scaffold.of(context).showSnackBar(snackBar);
//                            }
//                            else if (userNames.contains(newUser.text)) {
//                              final snackBar = SnackBar(content: Text('User already exists!'));
//                              Scaffold.of(context).showSnackBar(snackBar);
//                            }
                            },
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FlatButton.icon(
                  onPressed: () {
                    setState(() {
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
                    "Add User",
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
                          CreateBillPage(guestEvent: widget.guestEvent),
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
              widget.guestEvent.guestBills != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.guestEvent.guestBills.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: widget.guestEvent.guestBills[index].type ==
                                    "payment"
                                ? Colors.lightBlue[50]
                                : Colors.white,
                            child: ListTile(
                              onTap: () {
                                var route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BillInfoPage(
                                          guestEvent: widget.guestEvent,
                                          billIndex: index),
                                );
                                Navigator.of(context).push(route);
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  widget.guestEvent.guestBills[index].type !=
                                          "payment"
                                      ? IconButton(
                                          icon: Icon(Icons.content_copy,
                                              color: Colors.lightBlue[300]),
                                          onPressed: () {
                                            final snackBar = SnackBar(
                                                content: Text(
                                                    'Bill: ${widget.guestEvent.guestBills[index].title} has been duplicated!'));
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                            widget.guestEvent.guestBills.add(
                                                widget.guestEvent
                                                    .guestBills[index]);
                                            for (int i = 0;
                                                i <
                                                    widget.guestEvent.guestUsers
                                                        .length;
                                                i++) {
                                              if (widget.guestEvent
                                                      .guestUsers[i].name ==
                                                  widget
                                                      .guestEvent
                                                      .guestBills[index]
                                                      .payer) {
                                                widget.guestEvent.guestUsers[i]
                                                        .amountToGet +=
                                                    widget
                                                        .guestEvent
                                                        .guestBills[index]
                                                        .value;
                                              }
                                              for (int j = 0;
                                                  j <
                                                      widget
                                                          .guestEvent
                                                          .guestBills[index]
                                                          .guestPayee
                                                          .length;
                                                  j++) {
                                                if (widget.guestEvent
                                                        .guestUsers[i].name ==
                                                    widget
                                                        .guestEvent
                                                        .guestBills[index]
                                                        .guestPayee[j]
                                                        .name) {
                                                  widget
                                                          .guestEvent
                                                          .guestUsers[i]
                                                          .amountToPay +=
                                                      widget
                                                          .guestEvent
                                                          .guestBills[index]
                                                          .guestPayee[j]
                                                          .debt;
                                                }
                                              }
                                              widget.guestEvent.guestUsers[i]
                                                  .balance = widget
                                                      .guestEvent
                                                      .guestUsers[i]
                                                      .amountToGet -
                                                  widget
                                                      .guestEvent
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
                                          i <
                                              widget
                                                  .guestEvent.guestUsers.length;
                                          i++) {
                                        if (widget.guestEvent.guestUsers[i]
                                                .name ==
                                            widget.guestEvent.guestBills[index]
                                                .payer) {
                                          widget.guestEvent.guestUsers[i]
                                                  .amountToGet -=
                                              widget.guestEvent
                                                  .guestBills[index].value;

                                          print("entered if");
                                        }

                                        for (int j = 0;
                                            j <
                                                widget
                                                    .guestEvent
                                                    .guestBills[index]
                                                    .guestPayee
                                                    .length;
                                            j++) {
                                          if (widget.guestEvent.guestUsers[i]
                                                  .name ==
                                              widget
                                                  .guestEvent
                                                  .guestBills[index]
                                                  .guestPayee[j]
                                                  .name) {
                                            widget.guestEvent.guestUsers[i]
                                                    .amountToPay -=
                                                widget
                                                    .guestEvent
                                                    .guestBills[index]
                                                    .guestPayee[j]
                                                    .debt;
                                          }
                                        }
                                        widget.guestEvent.guestUsers[i]
                                            .balance = widget.guestEvent
                                                .guestUsers[i].amountToGet -
                                            widget.guestEvent.guestUsers[i]
                                                .amountToPay;
                                      }
                                      ;
                                      widget.guestEvent.guestBills
                                          .removeAt(index);
                                      _updateDb();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              title: Text(
                                  widget.guestEvent.guestBills[index].title ??
                                      'No title'),
                              subtitle: Text(widget
                                      .guestEvent.guestBills[index].value
                                      .toString() ??
                                  'No value'),
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: RaisedButton(
                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    refreshEvent();
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          GuestSettlePage(guestEvent: widget.guestEvent),
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
            ],
          ),
        )));
  }

  void _updateDb() async {
    _db
        .collection(GUEST_EVENTS_DB_COLLECTION_NAME)
        .document(widget.guestEvent.id)
        .setData(widget.guestEvent.toJson());
  }

  Future<void> refreshEvent() async {
    await _db
        .collection(GUEST_EVENTS_DB_COLLECTION_NAME)
        .document(widget.guestEvent.id)
        .get()
        .then((snapshot) {
      setState(() {
        widget.guestEvent = GuestEvent.fromJson(snapshot.data);
      });
    });
  }
}
