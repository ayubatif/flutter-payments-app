import 'package:flutter/material.dart';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/screens/screen_guest_eventpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:upayappnew/services/db.dart';

class EditBillPage extends StatelessWidget {
  GuestEvent guestEvent;
  int billIndex;

  EditBillPage({Key key, @required this.guestEvent, @required this.billIndex}) : super(key: key);

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
              onPressed:() => Navigator.pop(context, '/EventPage') ),),),
      body: editBill(guestEvent: guestEvent, billIndex: billIndex),
    );
  }
}

class FormDataBills  {
  final int date  = editBillState().dateController.hashCode;
  final String billTitle  = editBillState().billController.text;

}
// Create a Form widget.
class editBill extends StatefulWidget {
  GuestEvent guestEvent;
  int billIndex;
  GuestBill _currentBill;

  editBill({Key key, this.guestEvent, this.billIndex}) : super(key: key);

  @override
  editBillState createState() {
    return editBillState();
  }
}
// Create a corresponding State class.
// This class holds data related to the form.
class editBillState extends State<editBill> {
  TextEditingController _textFieldController = TextEditingController();
  _onClear() {
    setState(() {
      _textFieldController.text = "";
    });
  }
  // final namesMap = FormData().names.asMap();
  final _formKey = GlobalKey<FormState>();
  final billController = TextEditingController();
  final dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  //final amount1Controller = TextEditingController(text: FormData().amount1Amount.toString(),);
  // final amount2Controller = TextEditingController(text: FormData().amount1Amount.toString(),);
  @override

  void dispose(){
    billController.dispose();
    dateController.dispose();
    amountController.dispose();
    // amount1Controller.dispose();
    // amount2Controller.dispose();
    super.dispose();
  }

  static DateTime today = DateTime.now();
  DateTime finaldate;

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finaldate = order;
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  bool pressed = true;
  double totalAmount;
  int _selectedCustom;
  bool _invalidSplitting;
  List<TextEditingController> _debtControllers;
  Map<int, double> _debts;
  var selectedUser;
  double oldTotal;
  double oldPayerDebt;

  @override
  void initState() {
    GuestBill bill = widget.guestEvent.guestBills[widget.billIndex];

    selectedUser = bill.payer;

    totalAmount = bill.value;
    oldTotal = bill.value;
    billController.text = bill.title;
    amountController.text = totalAmount.toString();

    _debtControllers = new List();
    _debts = new Map();
    double check = bill.guestPayee[0].debt;
    for (int i = 0; i < bill.guestPayee.length; i++) {
      _debtControllers.add(new TextEditingController());
      _debtControllers[i].text = bill.guestPayee[i].debt.toString();
      if(check != bill.guestPayee[i].debt)
        _selectedCustom = 1;
      if (bill.guestPayee[i].name == selectedUser)
        oldPayerDebt = bill.guestPayee[i].debt;
    }

    if (bill.guestPayee.length < widget.guestEvent.guestUsers.length && bill.guestPayee.length > 1) {
      _selectedCustom = 1;
    }
    if (_selectedCustom == null){
      _selectedCustom = 0;
    }

    _invalidSplitting = false;
  }

  Widget build(BuildContext context) {
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
                  "Create New Bill",
                  style: TextStyle(color: Colors.lightBlue[300], fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.label),
                      hintText: "Bill Title",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0))),
                  controller: billController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Bill Paid By  ', style: TextStyle(color: Colors.lightBlue[300], fontSize: 16.0),),
                  Icon(Icons.supervised_user_circle),
                  DropdownButton(
                    items: widget.guestEvent.guestUsers.map<DropdownMenuItem<String>>((GuestUser user) {
                      return DropdownMenuItem<String>(
                        value: user.name,
                        child: Text(user.name),
                      );
                    })
                        .toList(),
                    onChanged: (usersValue){
                      setState(() {
                        selectedUser = usersValue;

                      });
                    },
                    value: selectedUser,
                    isExpanded: false,
                    hint:
                    selectedUser == null ?
                    new Text(
                      "<Bill payed By>",
                      style: TextStyle(color: Colors.lightBlue),
                    )
                        :
                    new Text(
                      selectedUser,
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  )

                ],),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                          child: finaldate == null ? Text("${today.day}-${today.month}-${today.year}",style: TextStyle(color: Colors.lightBlue[300]), textScaleFactor: 1.5,)
                              : Text("${finaldate.day}-${finaldate.month}-${finaldate.year}",style: TextStyle(color: Colors.lightBlue[300]),textScaleFactor: 1.5,),
                        ),
                      ),
                    ),
                    Container(
                      child: new RaisedButton.icon(
                        onPressed: callDatePicker,
                        color: Colors.lightBlue[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10)),
                        label: Text('Select date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        icon: Icon(Icons.date_range, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: amountController,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.monetization_on),
                      hintText: "Total Amount",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      suffixText: ("kr"),
                    ),
                  )
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: new RaisedButton(
                        onPressed: () {
                          setState(() {
                            var enteredAmount = double.tryParse(amountController.text)??0.00;
                            totalAmount = enteredAmount > 0 ? enteredAmount : null;
                            pressed = true;
                            _invalidSplitting = false;
                            _selectedCustom = 0;
                          });
                        },
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10)
                        ),
                        child: Text('Equal Split', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue[300])),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: new RaisedButton(
                        onPressed: () {
                          setState(() {
                            var enteredAmount = double.tryParse(amountController.text)??0.00;
                            totalAmount = enteredAmount > 0 ? enteredAmount : null;
                            _debtControllers = new List();
                            _debts = new Map();
                            pressed = true;
                            _invalidSplitting = false;
                            _selectedCustom = 1;
                          });
                        },
                        color: Colors.redAccent[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10)
                        ),
                        child: Text('Custom Split', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue[300])),
                      ),
                    ),
                  ),
                ],
              ),

              totalAmount != null  ?
              Center(
                  widthFactor: 0.8,
                  child: Column (
                      children: [
                        (() {
                          if (_selectedCustom > 0) {
                            return
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: widget.guestEvent.guestUsers.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    _debtControllers.add(new TextEditingController());
                                    return new Card(
                                        child: new GridTile(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                                  child: Text(
                                                      widget.guestEvent.guestUsers[index].name,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.lightBlue[300],
                                                        fontSize: 20,
                                                      )
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                                    child:
                                                    TextField(
                                                      controller: _debtControllers[index],
                                                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                                      keyboardType: TextInputType.number,
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                                                        hintText: "0.00",
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                                                            borderRadius: BorderRadius.circular(5.0)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.white, width: 32.0),
                                                            borderRadius: BorderRadius.circular(5.0)),
                                                      ),
                                                    )
                                                )
                                              ],
                                            )
                                        )
                                    );
                                  },
                                ),
                              );
                          }
                          else return
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: widget.guestEvent.guestUsers.length,
                                  itemBuilder:(BuildContext ctxt, int index) {
                                    return Column(
                                        children: <Widget>[Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          child: Text(widget.guestEvent.guestUsers[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.lightBlue[300],
                                                fontSize: 20),),
                                        ),


                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(((totalAmount)/(widget.guestEvent.guestUsers.length)).toString(),
                                              style: TextStyle(color: Colors.lightBlue[300], fontSize: 20.0),),
                                          ),



                                        ]
                                    );

                                  }),
                            );
                        }()),

                        _invalidSplitting ?
                        Center(
                            child: Text('Enter a more accurate custom split',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                  fontSize: 20),)
                        )
                            : SizedBox(),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0),

                          child: RaisedButton(

                            color: Colors.lightBlue[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius
                                    .circular(30.0)),
                            onPressed: () {
                              if(_selectedCustom > 0) {
                                if(!_validateCustomBill()) {
                                  setState(() {
                                    _invalidSplitting = true;
                                  });
                                  return;
                                }
                              }

                              _handleBillSubmission();
                            },

                            child: Text(
                              'Submit', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                            ),
                          ),
                        ),
                      ]
                  )
              )
                  : pressed ? Center(
                  child: Text('Enter a valid amount',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[300],
                        fontSize: 18),)
              )
                  : SizedBox(),

            ],
          ),
        ),
      ),
    );

  }
  //TODO add bill param, db update, and currency stuff
  Future<void> _handleBillSubmission() async{
    widget._currentBill = new GuestBill(
        date: finaldate == null
            ? widget.guestEvent.guestBills[widget.billIndex].date
            : ("${finaldate
            .day}-${finaldate
            .month}-${finaldate
            .year}"),
        value: totalAmount,
        id: widget.guestEvent.guestBills[widget.billIndex].id,
        settled: widget.guestEvent.guestBills[widget.billIndex].settled,
        payer: selectedUser,
        guestPayee: new List<GuestPayee>(),
        title: billController.text.length > 0 ? billController.text : 'No Title'
    );

    int i = 0;
    int numPayer;
    int length = widget.guestEvent.guestUsers.length;
    GuestBill oldBill = widget.guestEvent.guestBills[widget.billIndex];
    int oldLength = oldBill.guestPayee.length;
    int numOldPayer;

    for (; i < length; i++) {
      if( widget.guestEvent.guestUsers[i].name == selectedUser)
      {
        numPayer = i;
      }
      if( widget.guestEvent.guestUsers[i].name == oldBill.payer)
      {
        numOldPayer = i;
      }

    }
    widget.guestEvent.guestUsers[numOldPayer].amountToGet -= oldTotal - oldPayerDebt;
    if (_selectedCustom > 0) {
      for(i=0; i < oldLength; i++){
        widget.guestEvent.guestUsers[oldBill.guestPayee[i].index].amountToPay -= oldBill.guestPayee[i].debt;
      }
      _debts.forEach((index, debt) {
        widget._currentBill.guestPayee.add(
            new GuestPayee(
                debt: debt,
                settled: false,
                index: index,
                name: widget.guestEvent.guestUsers[index].name
            )
        );
        widget.guestEvent.guestUsers[i].amountToPay+= debt;
      });
      widget.guestEvent.guestUsers[numPayer].amountToGet += totalAmount;
    } else {
      for (i=0; i < widget.guestEvent.guestUsers.length; i++) {
        widget._currentBill.guestPayee.add(
            new GuestPayee(
                debt: totalAmount / widget.guestEvent.guestUsers.length,
                settled: false,
                index: i,
                name: widget.guestEvent.guestUsers[i].name
            )
        );
        widget.guestEvent.guestUsers[i].amountToPay-= oldTotal / oldLength;
        widget.guestEvent.guestUsers[i].amountToPay+= totalAmount / length;
      }
      widget.guestEvent.guestUsers[numPayer].amountToGet += totalAmount;
    }

    for (i =0 ; i < length; i++) {
      widget.guestEvent.guestUsers[i].balance = widget.guestEvent.guestUsers[i].amountToGet - widget.guestEvent.guestUsers[i].amountToPay;
    }

    widget.guestEvent.guestBills[widget.billIndex] = widget._currentBill;
    await Db.instance.collection(Db.GUEST_EVENTS_DB_COLLECTION_NAME).document(widget.guestEvent.id).setData(
        widget.guestEvent.toJson()
    );
    Navigator.pop(context, widget.guestEvent);
  }
  

  /// Sum up debt controller values and return true if greater than 99% and less than 101% of totalAmount
  bool _validateCustomBill() {
    double sumDebts = 0;
    for(int i=0;i<widget.guestEvent.guestUsers.length;i++) {
      var enteredAmount = double.tryParse(_debtControllers[i].text) ?? 0;
      if (enteredAmount > 0) {
        _debts[i] = enteredAmount;
        sumDebts += enteredAmount;
      }
    }
    return sumDebts >= totalAmount * 0.99 && sumDebts < totalAmount * 1.01 && !(selectedUser == null);
  }

  void handleBillCancel() {
    Navigator.pop(context, widget.guestEvent);
  }
}