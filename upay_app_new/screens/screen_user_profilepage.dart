import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upayappnew/screens/screen_create_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upayappnew/models/user.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:upayappnew/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:upayappnew/services/db.dart';




class UserProfilePage extends StatefulWidget {
  User user;
  UserProfilePage({this.user});
  UserProfilePageState createState() => UserProfilePageState();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
class UserProfilePageState extends State<UserProfilePage> {
  final _db = Firestore.instance;
  User user;
  final _formkeyprofile = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  TextEditingController editName = new TextEditingController();
  TextEditingController editPassword = new TextEditingController();
  TextEditingController editPhoneNr = new TextEditingController();
  bool showEditUserName = false;
  bool showEditUserPas = false;
  bool showeEditUserNr = false;
  File _imageFile;
  String _uploadedFileURL;

  @override

  /*void initState(){
    editName.text = user.name;
    editPassword.text = user.password;
    editPhoneNr.text = user.phoneNr;


  }*/

  Widget build(BuildContext context) {
    print(widget.user.toJson());
    final FormData formData = ModalRoute.of(context).settings.arguments;
    print(widget.user.toJson());
    return Scaffold(
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          title: Text('Profile Settings',
            style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading:  true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              color: Colors.lightBlue[300],
              onPressed:() => Navigator.pop(context) ), ),
      ),

    body: Padding(
      padding: const EdgeInsets.all(0),
    child: Form(
    key: _formkeyprofile,
      child: Container(height: 800.0,
        child: Stack(
          fit: StackFit.expand,
            children: <Widget>[ Positioned(width:400.0,
                // top: MediaQuery.of(context).size.height/100,
                child: Column(children: <Widget>[
                  Container(
                    width: 150.0, height: 150.0, decoration: BoxDecoration(
                        color: Colors.lightBlue[300],
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.grey)], image:
                  DecorationImage(
                    fit: BoxFit.fill, image: (widget.user.photoURL == null) ?
                  NetworkImage(
                      'https://ayubatif.github.io/II1305-web-public/res/split_it_logo_icon.png') :
                  NetworkImage(
                      widget.user.photoURL),) ),

                   /* child: _imageFile == null ? Padding(
                      padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      _imageFile, fit: BoxFit.cover,),

                    ): image: NetworkImage(widget.user.photoURL),*/),
                ],)),

              Center(
                child: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              SizedBox(height: 140,),
              Row(
                  children: <Widget>[
                    SizedBox(width: 125.0, height: 5.0),
                    Center(
               // padding: const EdgeInsets.symmetric(vertical:5.0,horizontal:160.0),
                child: FloatingActionButton(
                  heroTag: 'camera',
                  onPressed:(){ print("button");
                  getImage();},
                  tooltip: 'Pick Image',
                  backgroundColor:Colors.lightBlue[300],
                  child: Icon(Icons.add_a_photo),
                ),
              ),
              SizedBox(width: 20, height: 5.0,),
              new FloatingActionButton(
                heroTag: 'gallery',
                onPressed:(){ print("button");
                getImageGallery();},
                tooltip: 'Pick Image',
                backgroundColor:Colors.lightBlue[300],
                child: Icon(Icons.image),
              ),
             ] ),

              Card(
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.lightBlue[300],
                child: ListTile(
                  title: Text(
                    'E-mail:  ' + widget.user.email,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),



                /**/
                SizedBox(height: 10,),

              Card(
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))
                ,
                color: Colors.lightBlue[300],

                child: (showEditUserName == false) ? ListTile(
                  title: Text(
                    'Full Name:  ' + widget.user.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {
                    setState(() {
                      showEditUserName = true;
                    });
                  },),
                ):
                TextFormField(controller: editName,
                  decoration: InputDecoration(
                    hintText: ' New Name :  ' ,
                    hintStyle: TextStyle(color: Colors.white),
                  ),

                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a new name';
                    }
                    return null;
                  },
                ),

              ) ,


              SizedBox(height: 10,),

                Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  color: Colors.lightBlue[300],
                  child: (showeEditUserNr == false) ? ListTile(
                    title: Text(
                      'PhoneNumber:  ' +  widget.user.phoneNr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {setState(() {
                      showeEditUserNr = true;
                    });},),
                  ):
                  TextFormField(
                    controller: editPhoneNr,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      hintText: ' New Number :  ' ,
                      hintStyle:
                      TextStyle(
                          color: Colors.white),
                    ),
                    validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter new number';
                    }
                    return null;
                  },),
                ),
               SizedBox(height:10.0, ),
              Center(
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {  setState(() {
                      showEditUserPas = true;
                    });
                    resetPassword(user.email);
                    print("Password reset email sent to " + user.email); },
                    child: Text("Reset Password", style: TextStyle(color: Colors.red, fontSize: 20.0),)),
              ),


                  Row(
                      children: <Widget>[
                        SizedBox(width: 100.0,),
                   Center(

                 child: new RaisedButton(
                     shape: RoundedRectangleBorder(
                         borderRadius: new BorderRadius.circular(30.0)),
                   onPressed: () => Navigator.pop(context),
                     child: Text("Cancel", style: TextStyle(color: Colors.lightBlue[300], fontSize: 20.0),)),
               ),
                 SizedBox(width: 20.0,),

                 new RaisedButton(
                  color: Colors.lightBlue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0)),
                  onPressed: (){
                    widget.user.name = (editName.text == null) ? widget.user.name  : ((editName.text.length > 0) ? editName.text : widget.user.name);
                    widget.user.phoneNr = (editPhoneNr.text == null) ? widget.user.phoneNr  : ((editPhoneNr.text.length > 0) ? editPhoneNr.text : widget.user.phoneNr);
                    _updateDb();
                  Navigator.pop(context);
                  },
                /*  async {

                    if(!_formKey.currentState.validate()) {
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text('Username is taken, please enter another')));
                    }else {
                      user.password = editPassword.text;
                      user.name = editName.text;
                      user.phoneNr = editPhoneNr.text;
                      //dynamic result = await _auth.registerWithEmailAndPassword(user.email, user.password, user.name, user.phoneNr, contactList, eventList, user.pastEvents );
                      // login should take you to ActivityPage and make calls to database with username and password
                    }; },*/
                  child: Text("Save",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),),
                ),
                   ],),


            ],

          ),),
              )
            ],
        ),
      ),
    ),
    ),

    //  body: CreateOrJoinForm(),

    );

  }

  @override
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email);
  }


  Future<void> getImage() async {
    print("getImage");
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
  }
  Future<void> getImageGallery() async {
    print("getImage");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }
  void _updateDb() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (_imageFile != null){

      StorageReference storageRef = FirebaseStorage.instance.ref().child(
          Db.USERS_DB_COLLECTION_NAME + '/' + currentUser.uid);
      StorageUploadTask uploadTask = storageRef.putFile(_imageFile);
      await uploadTask.onComplete;
      await storageRef.getDownloadURL().then((imageUrl) {
        widget.user.photoURL = imageUrl;
        print('PhotoUploaded');
      });
    }
    _db.collection(Db.USERS_DB_COLLECTION_NAME).document(currentUser.uid).setData(widget.user.toJson());
  }

  /* buildEditName(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 12.0),
        child:  Text("User Name" , style: TextStyle(color: Colors.lightBlue[300])
     ,)
          ,),
        TextField(controller: editName,
        decoration: InputDecoration(
          hintText: "Edit User Name"
        ),)
      ],
    );
}

  Column buildEditPhoneNr(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 12.0),
          child:  Text(" Name" , style: TextStyle(color: Colors.lightBlue[300])
            ,)
          ,),
        TextField(controller: editName,
          decoration: InputDecoration(
              hintText: "Edit User Name"
          ),)
      ],
    );
  }

*/


  Future<void> _handleEditSubmission() async{

  }
}
