import 'package:firebase_auth/firebase_auth.dart';
import 'package:upayappnew/models/user.dart';

import 'database.dart';
class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid): null;
  }

  // auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  Future getCurrenctUser() async{
    return await _auth.currentUser();
    
  }

  //sign-up using e-mail and password


  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }




  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String name, String phoneNr, List<Contact> contactList, List<String> eventList, List<String> pastEvents, String photoURL) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(email, name, phoneNr, contactList, eventList, pastEvents);

      return _userFromFirebaseUser(user);
    }  catch (error) {
      switch (error.code) {
        case 'ERROR_WEAK_PASSWORD': return 'Weak password, passwords should be at least 6 characters long';
        case 'ERROR_INVALID_EMAIL': return 'Invalid email address';
        case 'ERROR_EMAIL_ALREADY_IN_USE': return 'This email is already in use by a different account';
      }
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
        switch (error.code) {
          case 'ERROR_INVALID_EMAIL': return 'Invalid email address';
          case 'ERROR_WRONG_PASSWORD': return 'Incorrect password';
          case 'ERROR_USER_NOT_FOUND': return 'Not registered user, please create an account before logging in';
          case 'ERROR_USER_DISABLED': return 'User is disabled';
          case 'ERROR_TOO_MANY_REQUESTS': return 'Too many requests, please wait and try again later';
          case 'ERROR_OPERATION_NOT_ALLOWED': return 'Error';
      }
    }
  }


//sign-out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}