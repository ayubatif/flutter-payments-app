import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/screens/screen_editbillpage.dart';
import 'package:upayappnew/screens/screen_user_editbillpage.dart';
import 'package:upayappnew/services/db.dart';

import '../models/models.dart';

class UserBillInfoPage extends StatefulWidget {
  Event event;
  int billIndex;

  UserBillInfoPage({Key key, @required this.event, @required this.billIndex}) : super(key: key);

  @override
  _UserBillInfoPageState createState() => _UserBillInfoPageState();
}

// The state will handle whether a payment is settled as well as settling the whole bill
class _UserBillInfoPageState extends State<UserBillInfoPage> {
  var _imageFile;
  bool _billSettled;
  bool _billChanged;
  Bill billBeforeChanges;

  @override
  void initState() {
    // TODO: implement initState
    _billChanged = false;
    billBeforeChanges = Bill.fromJson(widget.event.billList[widget.billIndex].toJson());
    
    print('^');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar( title: Text(''),
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading:  true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              color: Colors.lightBlue[300],
              onPressed:() {
                if (_billChanged) _updateDb();
                Navigator.pop(context);
              }
          ),actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.undo,
                color: Colors.lightBlue[300],
              ),
              onPressed: (){
                
                setState(() {
                  widget.event.billList[widget.billIndex] = Bill.fromJson(billBeforeChanges.toJson());
                });

              },
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.lightBlue[300],
              ),
              onPressed: () {
                if (_billChanged) _updateDb();
                var route = MaterialPageRoute(
                  builder: (BuildContext context) =>
                      UserEditBillPage(event: widget.event, billIndex: widget.billIndex),
                );
                Navigator.of(context).push(route);
              },
            )
          ], ),),
      body:
      Column(
          children: <Widget>[
            Text(widget.event.title,
              style: (TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue[300],
                  fontSize: 28
              )),),
            Text(widget.event.billList[widget.billIndex].title,
              style: (
                  TextStyle(
                    color: Colors.lightBlue[300],
                    fontSize: 20,
                  )
              ),
            ),
            widget.event.billList[widget.billIndex].notes == null ?
            SizedBox(height: 0) : Text(widget.event.billList[widget.billIndex].notes,
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
              padding: const EdgeInsets.symmetric(vertical: 20.0),
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
    final _payments = widget.event.billList[widget.billIndex].payeeList;
    int _counter = 0;
    return ListView.builder(
      itemCount: _payments.length,
      itemBuilder: (context, index) {
        if (_payments[index].settled) {
          _counter++;
        }
        if(_payments[index].name == widget.event.billList[widget.billIndex].payer){
          return SizedBox();
        }
        return ListTile(
          leading: Icon(Icons.arrow_forward_ios),
          title: Text(_payments[index].name+' owes '+  widget.event.billList[widget.billIndex].payer+ ' ' +_payments[index].debt.toString()),
          trailing: _payments[index].settled ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
          onTap: () {
            if (!_payments[index].settled) {
              _billChanged = true;

              widget.event.billList[widget.billIndex].payeeList[index]
                  .settled = true;

              if (_counter > _payments.length - 2) {
                setState(() {
                  widget.event.billList[widget.billIndex].settled = true;
                  _billSettled = true;
                });
              }
            }
          },
        );
      },
    );
  }

  Future<void> _updateDb() async {
    await Db.instance.collection('Events').document(widget.event.id).setData(
        widget.event.toJson()
    );
  }

  handleSettleAll() {
    for (int i=0;i<widget.event.billList[widget.billIndex].payeeList.length;i++) {
      widget.event.billList[widget.billIndex].payeeList[i].settled = true;
    }
    setState(() => {
      _billSettled = true,
    });
  }

}