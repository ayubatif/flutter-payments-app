import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/screens/screen_guest_eventpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:upayappnew/models/swish_payment.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:upayappnew/services/db.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:upayappnew/services/swish.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class GuestSettlePage extends StatelessWidget {
  GuestEvent guestEvent;

  GuestSettlePage({
    Key key,
    @required this.guestEvent,
  }) : super(key: key);

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
              onPressed: () => Navigator.pop(context, '/guestEvent')),
        ),
      ),
      body: GuestSettle(guestEvent: guestEvent),
    );
  }
}

class GuestSettle extends StatefulWidget {
  GuestEvent guestEvent;

  GuestSettle({Key key, this.guestEvent}) : super(key: key);

  @override
  GuestSettleState createState() {
    return GuestSettleState();
  }
}

class GuestSettleState extends State<GuestSettle> {
  GuestEvent guestEvent;
  final List<GuestUser> positiveBalUsers = new List();
  final List<GuestUser> negativeBalUsers = new List();
  final List<GuestUser> zeroBalUsers = new List();
  final List<String> shouldPay = new List();
  final List<SwishPayment> swishPayments = new List();
  final List<bool> debtSettled = new List.filled(1000, false);

  bool _debtSettled = false;

  sortUserIntoLists(List<GuestUser> users) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].balance > 0) {
        positiveBalUsers.add(users[i]);
      } else if (users[i].balance < 0) {
        negativeBalUsers.add(users[i]);
      } else {
        zeroBalUsers.add(users[i]);
      }
    }
    print("list sort");
  }

  sortList(List<GuestUser> users) {
    Comparator<GuestUser> balanceComparator =
        (a, b) => a.balance.compareTo(b.balance);
    users.sort(balanceComparator);
    print("sort works");
  }

  whoPayswho(List<GuestUser> pos, List<GuestUser> neg) {
//    shouldPay.clear();

    for (int i = 0; i < pos.length; i++) {
      for (int j = 0; j < neg.length; j++) {
        if (pos[i].balance != 0 && neg[j].balance != 0) {
          if ((pos[i].balance + neg[j].balance) == 0) {
            shouldPay.add(neg[j].name +
                " should pay " +
                pos[i].name +
                " " + //If two users have inverse equal balance they can be cancelled out with one payment
                pos[i].balance.toStringAsFixed(2) +
                "kr");
            swishPayments.add(SwishPayment(
                phoneNr: pos[i].phoneNumber,
                amount: pos[i].balance,
                message: "Split event: ${widget.guestEvent.title}",
                payer: neg[j].name,
                payee: pos[i].name));
            print("THis is Should pay length1:" + shouldPay.length.toString());
            pos[i].balance = 0;
            neg[j].balance = 0;
          } else if ((pos[i].balance + neg[j].balance) > 0) {
            shouldPay.add(neg[j].name +
                " should pay " +
                pos[i].name +
                " " + //If the payee owes less than the total for a payer then they pay their full amount
                (-1 * neg[j].balance).toStringAsFixed(2) +
                "kr");
            swishPayments.add(SwishPayment(
                phoneNr: pos[i].phoneNumber,
                amount: (-1 * neg[j].balance),
                message: "Split event: ${widget.guestEvent.title}",
                payer: neg[j].name,
                payee: pos[i].name));

            pos[i].balance += neg[j].balance;
            neg[j].balance = 0;
          } else {
            shouldPay.add(neg[j].name +
                " should pay " +
                pos[i].name +
                " " + //If the amount to be payed is less than the total owed the payee pays once and will pay again
                (pos[j].balance).toStringAsFixed(2) +
                "kr");
            swishPayments.add(SwishPayment(
                phoneNr: pos[i].phoneNumber,
                amount: pos[j].balance,
                message: "Split event: ${widget.guestEvent.title}",
                payer: neg[j].name,
                payee: pos[i].name));
            neg[j].balance += pos[i].balance;
            pos[i].balance = 0;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    sortUserIntoLists(widget.guestEvent.guestUsers);
    sortList(positiveBalUsers);
    sortList(negativeBalUsers);
    whoPayswho(positiveBalUsers, negativeBalUsers);

    Future<void> _launched;

    return Center(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Text("Test"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                widget.guestEvent.title,
                style: (TextStyle(fontSize: 28)),
              ),
            ),
            shouldPay != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: shouldPay.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
//                            leading:,
                          leading: debtSettled[index]
                              ? Icon(Icons.check_circle,
                                  color: Colors.blue.shade400)
                              : Icon(Icons.check_circle_outline),
                          onTap: () {
                            debtSettled[index]
                                ? setState(() {
                                    debtSettled[index] = false;
                                  })
                                : setState(() {
                                    debtSettled[index] = true;
                                  });
                          },
                          title: Text(shouldPay[index] ?? 'No title'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset(
                                    'assets/images/Swish_Logo_Primary_RGB.png'),
                                onPressed: () async {
                                  bool swishInstalled =
                                      await isSwishAppInstalled(
                                          "se.bankgirot.swish");
                                  if (swishInstalled != false) {
                                    setState(() async {
                                      String swishRecipientInformation =
                                          prepareSwishRecipientInformation(
                                              swishPayments[index].phoneNr,
                                              swishPayments[index].amount,
                                              swishPayments[index].message);
                                      String URLEncodedJsonPayload =
                                          Uri.encodeFull(
                                              swishRecipientInformation);
                                      String callBackUrl =
                                          "com.i1304andromeda.upayappnew:";
                                      String url =
                                          "swish://payment?data=$URLEncodedJsonPayload" +
                                              "&callbackurl=$callBackUrl"; //+"&callbackresultparameter=";
                                      _launched = _launchUniversalLink(url);
                                    });
                                    //Execute this part of the code if the condition is true.
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            getSwishNotInstalledDialogue());
                                    //Execute this part of the code if the condition is not true.
                                  }
                                  ;
                                },
                              ),
                              FutureBuilder(
                                future: _launched,
                                builder: (BuildContext context,
                                    AsyncSnapshot<void> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Text('');
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(
                    child: Text("no bills "),
                  ),
            FloatingActionButton.extended(
              backgroundColor: shouldPay.length != 0
                  ? Colors.blue.shade400
                  : Colors.green.shade400,
              onPressed: () {
                for (int i = 0; i < debtSettled.length; i++) {
                  if (debtSettled[i] == true) {
                    DateTime today = DateTime.now();
                    GuestPayee guestPayee = new GuestPayee(
                        name: swishPayments[i].payee,
                        debt: swishPayments[i].amount,
                        settled: false);
                    List<GuestPayee> myList = List.filled(1, guestPayee);
                    GuestBill guestBill = new GuestBill(
                        title:
                            shouldPay[i].replaceAll(' should pay ', ' paid '),
                        date: '${today.day}-${today.month}-${today.year}',
                        payer: swishPayments[i].payer,
                        value: swishPayments[i].amount,
                        type: 'payment',
                        settled: false,
                        guestPayee: myList);
                    widget.guestEvent.guestBills.add(guestBill);
                    for (int i = 0;
                        i < widget.guestEvent.guestUsers.length;
                        i++) {
                      if (widget.guestEvent.guestUsers[i].name ==
                          guestBill.payer) {
                        widget.guestEvent.guestUsers[i].amountToGet +=
                            guestBill.value;
                      }
                      for (int j = 0; j < guestBill.guestPayee.length; j++) {
                        if (widget.guestEvent.guestUsers[i].name ==
                            guestBill.guestPayee[j].name) {
                          widget.guestEvent.guestUsers[i].amountToPay +=
                              guestBill.guestPayee[j].debt;
                        }
                      }
                      widget.guestEvent.guestUsers[i].balance =
                          widget.guestEvent.guestUsers[i].amountToGet -
                              widget.guestEvent.guestUsers[i].amountToPay;
                    }
                    ;
                    _updateDb();
                    refreshEvent();
                  }
                }
                ;
                Navigator.pop(context, '/guestEvent');
              },
              icon: Icon(Icons.check_circle),
              label: shouldPay.length != 0
                  ? Text("Mark as settled")
                  : Text("All set"),
            ),
          ],
        ),
      ),
    );
  }

  final _db = Firestore.instance;
  final String GUEST_EVENTS_DB_COLLECTION_NAME = "GuestEvents";

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

  Future<void> _launchUniversalLink(String url) async {
    final bool nativeAppLaunchSucceeded =
        await launch(url, forceSafariVC: false);
    if (!nativeAppLaunchSucceeded) {
      await launch(url, forceSafariVC: true);
    }
  }
}
