import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/screens/screen_editbillpage.dart';
import 'package:upayappnew/services/db.dart';

import '../models/models.dart';

class BillInfoPage extends StatefulWidget {
  GuestEvent guestEvent;
  int billIndex;

  BillInfoPage({Key key, @required this.guestEvent, @required this.billIndex}) : super(key: key);

  @override
  _BillInfoPageState createState() => _BillInfoPageState();
}

// The state will handle whether a payment is settled as well as settling the whole bill
class _BillInfoPageState extends State<BillInfoPage> {
  var _imageFile;
  bool _billSettled;
  bool _billChanged;

  @override
  void initState() {
    // TODO: implement initState
    _billChanged = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar( title: Text(''),
          backgroundColor: Colors.grey[100],
          elevation: 0.0,
          automaticallyImplyLeading:  true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              color: Colors.lightBlue[300],
              onPressed:() {
                if (_billChanged) _updateDb();
                Navigator.pop(context, '/EventPage');
              }
            ),actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.lightBlue[300],
              ),
              onPressed: () {
                if (_billChanged) _updateDb();
                var route = MaterialPageRoute(
                  builder: (BuildContext context) =>
                      EditBillPage(guestEvent: widget.guestEvent, billIndex: widget.billIndex),
                );
                Navigator.of(context).push(route);
              },
            )
          ], ),),
        body:
        Column(
            children: <Widget>[
              Text(widget.guestEvent.title,
                style: (TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue[300],
                    fontSize: 28
                )),),
              Text(widget.guestEvent.guestBills[widget.billIndex].title??'Bill with null title',
                style: (
                    TextStyle(
                        color: Colors.lightBlue[300],
                        fontSize: 20,
                    )
                ),
              ),
              widget.guestEvent.guestBills[widget.billIndex].notes == null ?
              SizedBox(height: 0) : Text(widget.guestEvent.guestBills[widget.billIndex].notes,
                style: TextStyle(color: Colors.lightBlue[300]),
              ),
              SizedBox( width: 20, height: 30,),
              /*ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
                child: _imageFile == null ? Text('No image selected.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue[300])) : Image.file(_imageFile, fit: BoxFit.cover,),
              ),*/
              Expanded(
                child: _myListView(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child:  Text('Mark all payments as settled',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),),
                  onPressed: () => handleSettleAll(),
                ),
              ),
            ]
        ),
      );
  }

  Widget _myListView() {
    final _payments = widget.guestEvent.guestBills[widget.billIndex].guestPayee;
    int _counter = 0;
    return ListView.builder(
      itemCount: _payments.length,
      itemBuilder: (context, index) {
        if (_payments[index].settled) {
          _counter++;
        }
        return ListTile(
          leading: Icon(Icons.arrow_forward_ios),
          title: Text(_payments[index].name+' owes '+  widget.guestEvent.guestBills[widget.billIndex].payer+ ' ' +_payments[index].debt.toString()),
          trailing: _payments[index].settled ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
          onTap: () {
            _billChanged = true;
            widget.guestEvent.guestBills[widget.billIndex].guestPayee[index]
                .settled = !_payments[index].settled;
            if (_counter > _payments.length - 1) {
              setState(() {
                widget.guestEvent.guestBills[widget.billIndex].settled = true;
                _billSettled = true;
              });
            }
            setState(() => {
              _billSettled = false,
            });
          },
        );
      },
    );
  }

  Future<void> _updateDb() async {
    await Db.instance.collection(Db.GUEST_EVENTS_DB_COLLECTION_NAME).document(widget.guestEvent.id).setData(
        widget.guestEvent.toJson()
    );
  }

  handleSettleAll() {
    for (int i=0;i<widget.guestEvent.guestBills[widget.billIndex].guestPayee.length;i++) {
      widget.guestEvent.guestBills[widget.billIndex].guestPayee[i].settled = true;
    }
    setState(() => {
      _billSettled = true,
    });
  }

}