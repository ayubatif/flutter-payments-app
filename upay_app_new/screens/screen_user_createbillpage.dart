import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/models/models.dart';
import 'package:upayappnew/models/user.dart';
import 'package:upayappnew/screens/screen_guest_eventpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:upayappnew/services/db.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class UserCreateBillPage extends StatelessWidget {
  Event event;

  UserCreateBillPage({Key key, @required this.event,}) : super(key: key);

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
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), color: Colors.lightBlue[300]
              , onPressed:() => Navigator.pop(context) ), ),),
      body: createNewBill(event: event),
    );
  }
}

class FormDataBills  {

  static final List<String>names = ['name1', 'name2',];
  final map = names.asMap();
  final int length = names.length;
  final int date  = createNewBillState().dateController.hashCode;
  final String billTitle  = createNewBillState().billController.text;

}
// Create a Form widget.
class createNewBill extends StatefulWidget {
  Event event;
  Bill _currentBill;

  createNewBill({Key key, this.event}) : super(key: key);

  @override
  createNewBillState createState() {
    return createNewBillState();
  }
}
// Create a corresponding State class.
// This class holds data related to the form.
class createNewBillState extends State<createNewBill> {
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
  final noteController = TextEditingController();

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

  bool pressed = false;
  double totalAmount;
  int _selectedCustom;
  bool _invalidSplitting;
  List<TextEditingController> _debtControllers;
  Map<int, double> _debts;
  var selectedUser;
  File _imageFile;
  String _uploadedFileURL;
  List <bool> showFields = [false,false];

  void initState(){
    super.initState();
    showFields =[false, false];
  }


  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Create New Bill",
                        style: TextStyle(color: Colors.lightBlue[300], fontSize: 24.0),
                      ),
                    ),
                    ToggleButtons(
                      borderColor: Colors.white,
                      color: Colors.lightBlue[300],
                      children: <Widget>[
                        Icon(Icons.add_a_photo),
                        Icon(Icons.edit),
                      ],
                      isSelected: showFields,
                      onPressed: (index){
                        setState(() {
                          showFields[index] = !showFields[index];
                        });
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Bill Paid By  ', style: TextStyle(color: Colors.lightBlue[300], fontSize: 16.0),),
                    Icon(Icons.supervised_user_circle),
                    DropdownButton(
                      items: widget.event.guestUsers.map<DropdownMenuItem<String>>((GuestUser user) {
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
                      hint: new Text(
                        "Select user",
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    )
                  ],),
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
                (showFields[0] == true) ?
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center ,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
                          child: _imageFile == null ? Text('No image selected.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue[300])) : Image.file(_imageFile, fit: BoxFit.cover,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            getImage();
                          },
                          tooltip: 'Pick Image',
                          backgroundColor:Colors.lightBlue[300],
                          child: Icon(Icons.add_a_photo),
                        ),


                      ),
                    ],
                  ),
                ) : SizedBox(),
                (showFields[1] == true) ?
                Padding(

                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(

                        child: TextFormField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(Icons.note),
                              hintText: "Notes",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0))),


                          controller: noteController,

                        ),
                      ),
                    ],
                  ),
                ) : SizedBox(),


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
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: widget.event.guestUsers.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        _debtControllers.add(
                                            new TextEditingController());
                                        return Column(
                                          children: <Widget>[

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: Text(
                                                      widget.event
                                                          .guestUsers[index].name,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: Colors
                                                            .lightBlue[300],
                                                        fontSize: 20,
                                                      )
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0),
                                                    child:
                                                    ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                          maxWidth: 150
                                                      ),
                                                      child: TextField(
                                                        controller: _debtControllers[index],
                                                        inputFormatters: [
                                                          WhitelistingTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        keyboardType: TextInputType
                                                            .number,
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets
                                                              .fromLTRB(
                                                              35.0, 15.0, 15.0,
                                                              15.0),
                                                          hintText: "Amount ...",
                                                          border: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .lightBlue[300],
                                                                  width: 32.0),
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  5.0)),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 32.0),
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  5.0)),
                                                        ),
                                                      ),
                                                    )
                                                )
                                              ],
                                            )
                                          ],);
                                      }),);
//                                Padding(
//                                  padding: const EdgeInsets.all(8.0),
//                                  child: GridView.builder(
//                                    shrinkWrap: true,
//                                    physics: ClampingScrollPhysics(),
//                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                      crossAxisCount: 2,
//                                    ),
//                                    itemCount: widget.event.guestUsers.length,
//                                    itemBuilder: (BuildContext ctxt, int index) {
//                                      _debtControllers.add(new TextEditingController());
//                                      return new Card(
//                                          child: new GridTile(
//                                              child: Column(
//                                                children: <Widget>[
//                                                  Padding(
//                                                    padding: const EdgeInsets.symmetric(vertical: 20),
//                                                    child: Text(
//                                                        widget.event.guestUsers[index].name,
//                                                        style: TextStyle(
//                                                          fontWeight: FontWeight.bold,
//                                                          color: Colors.lightBlue[300],
//                                                          fontSize: 20,
//                                                        )
//                                                    ),
//                                                  ),
//                                                  Padding(
//                                                      padding: const EdgeInsets.symmetric(horizontal: 30),
//                                                      child:
//                                                      TextField(
//                                                        controller: _debtControllers[index],
//                                                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
//                                                        keyboardType: TextInputType.number,
//                                                        decoration: InputDecoration(
//                                                          contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
//                                                          hintText: "0.00",
//                                                          border: OutlineInputBorder(
//                                                              borderSide: BorderSide(color: Colors.lightBlue[300], width: 32.0),
//                                                              borderRadius: BorderRadius.circular(5.0)),
//                                                          focusedBorder: OutlineInputBorder(
//                                                              borderSide: BorderSide(color: Colors.white, width: 32.0),
//                                                              borderRadius: BorderRadius.circular(5.0)),
//                                                        ),
//                                                      )
//                                                  )
//                                                ],
//                                              )
//                                          )
//                                      );
//                                    },
//                                  ),
//                                );
                            }
                            else return
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight:450
                                  ),
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: widget.event.guestUsers.length,
                                      itemBuilder:(BuildContext context, int index) {
                                        return Column(
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                                    child: Text(widget.event.guestUsers[index].name,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.lightBlue[300],
                                                          fontSize: 20),),
                                                  ),


                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                    child: Text(((totalAmount)/(widget.event.guestUsers.length)).toStringAsFixed(2),
                                                      style: TextStyle(color: Colors.lightBlue[300], fontSize: 20.0),),
                                                  ),



                                                ]
                                            ),
                                          ],
                                        );

                                      }),
                                ),
                              );
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: ListView.builder(
//                                    scrollDirection: Axis.vertical,
//                                    shrinkWrap: true,
//                                    itemCount: widget.event.guestUsers.length,
//                                    itemBuilder:(BuildContext ctxt, int index) {
//                                      return Column(
//                                          children: <Widget>[Padding(
//                                            padding: const EdgeInsets.symmetric(vertical: 20),
//                                            child: Text(widget.event.guestUsers[index].name,
//                                              style: TextStyle(
//                                                  fontWeight: FontWeight.bold,
//                                                  color: Colors.lightBlue[300],
//                                                  fontSize: 20),),
//                                          ),
//
//
//                                            Padding(
//                                              padding: const EdgeInsets.symmetric(
//                                                  vertical: 5.0),
//                                              child: Text(((totalAmount)/(widget.event.guestUsers.length)).toStringAsFixed(2),
//                                                style: TextStyle(color: Colors.lightBlue[300], fontSize: 20.0),),
//                                            ),
//
//
//
//                                          ]
//                                      );
//
//                                    }),
//                              );
                          }()),

                          _invalidSplitting ?
                          Center(
                              child: Text('Enter a more accurate custom split or add a payee',
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

  Future<void> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
  }

  //TODO add bill param, db update, and currency stuff
  Future<void> _handleBillSubmission () async {
    //await uploadImage();

    widget._currentBill = new Bill(
        date: finaldate == null
            ? ("${today.day}-${today
            .month}-${today.year}")
            : ("${finaldate
            .day}-${finaldate
            .month}-${finaldate
            .year}"),
        value:totalAmount,
        settled: false,
        photoURL: _uploadedFileURL ?? '',
        notes: noteController.text ?? '',
        payer: selectedUser,
        // photoReference: ,
        payeeList: new List<Payee>(),
        title: billController.text.length > 0 ? billController.text : 'Untitled Bill'
    );

    int i = 0;
    int numPayer =0;
    int length = widget.event.guestUsers.length;


    for (; i < length; i++) {
      if( widget.event.guestUsers[i].name == selectedUser)
        {
          numPayer = i;
        }

    }


    if (_selectedCustom > 0) {
      _debts.forEach((index, debt) {
        widget._currentBill.payeeList.add(
            new Payee(
                debt: debt,
                index: index,
                settled: false,
                name: widget.event.guestUsers[index].name
            )
        );
        widget.event.guestUsers[index].amountToPay += debt;
      });
      widget.event.guestUsers[numPayer].amountToGet += totalAmount;
    } else {

      for (i =0 ; i < length; i++) {
        widget._currentBill.payeeList.add(
            new Payee(
                debt: totalAmount / length,
                settled: false,
                index: i,
                name: widget.event.guestUsers[i].name
            )
        );
        widget.event.guestUsers[i].amountToPay += totalAmount / length;

      }
      widget.event.guestUsers[numPayer].amountToGet += totalAmount;
    }

    for (i =0 ; i < length; i++) {
      widget.event.guestUsers[i].balance = widget.event.guestUsers[i].amountToGet - widget.event.guestUsers[i].amountToPay;
    }

    widget.event.billList.add(widget._currentBill);
    await Db.instance.collection('Events').document(widget.event.id).setData(
        widget.event.toJson()
    );
    Navigator.pop(context, widget.event);
  }

  /// Sum up debt controller values and return true if greater than 99% and less than 101% of totalAmount
  bool _validateCustomBill() {
    double sumDebts = 0;
    for(int i=0;i<widget.event.guestUsers.length;i++) {
      var enteredAmount = double.tryParse(_debtControllers[i].text) ?? 0;
      if (enteredAmount > 0) {
        _debts[i] = enteredAmount;
        sumDebts += enteredAmount;
      }
    }
    return sumDebts >= totalAmount * 0.99 && sumDebts < totalAmount * 1.01 && !(selectedUser == null);
  }

  Future<String> uploadImage () async {
    if (_imageFile == null)
      _uploadedFileURL = '';
    StorageReference storageRef = FirebaseStorage.instance.ref().child(Db.EVENT_IMAGES_DB+'/'+widget.event.id);
    StorageUploadTask uploadTask = storageRef.putFile(_imageFile);
    await uploadTask.onComplete;
    await storageRef.getDownloadURL().then((imageUrl) {
      _uploadedFileURL = imageUrl;
    });
  }
}

class ListItem extends StatefulWidget {
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        enabled: _isEnabled,
        decoration: InputDecoration(
          hintText: '0.00',
        ),
      ),

      // The icon button which will notify list item to change
      trailing: GestureDetector(
        child: new Icon(
          Icons.edit,
          color: Colors.black,
        ),
        onTap: () {
          setState((){
            _isEnabled = !_isEnabled;
          });
        },
      ),
    );
  }
}