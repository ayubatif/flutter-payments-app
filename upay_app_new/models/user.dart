import 'package:upayappnew/models/models.dart';

class User {
  String uid;
  String email;
  String phoneNr;
  String name;
  String password;
  String photoURL;
  //TODO FIX EVENT LIST INSTEAD OF GUEST EVENT
  List <String> pastEvents;
  List<String> eventIDList;
  List<Contact> contactList;


  User({this.phoneNr, this.email, this.name,this.password, this.uid, this.eventIDList, this.contactList, this.pastEvents, this.photoURL});

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    phoneNr = json['phoneNr'];
    name = json['name'];
    password= json['password'];
    email = json['email'];
    photoURL = json['photoURL'];
    if (json['pastEvents'] != null) {
      pastEvents = new List<String>();
      json['pastEvents'].forEach((v) {
        pastEvents.add(v);
      });
    }
    if (json['eventList'] != null) {
      eventIDList = new List<String>();
      json['eventList'].forEach((v) {
        eventIDList.add(v);
      });
    }
    if (json['contactList'] != null) {
      contactList = new List<Contact>();
      json['contactList'].forEach((v) {
        contactList.add(new Contact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNr'] = this.phoneNr;
    data['name'] = this.name;
    data['password'] = this.password;
    data['uid'] = this.uid;
    data['email'] = this.email;
    if (this.pastEvents != null) {
      data['pastEvents'] = this.pastEvents.map((v) => v).toList();
    }
    if (this.eventIDList != null) {
      data['eventList'] = this.eventIDList.map((v) => v).toList();
    }
    if (this.contactList != null) {
      data['contactList'] = this.contactList.map((v) => v.toJson()).toList();
    }
    data['photoURL'] = this.photoURL;

    return data;
  }
}

class Event {
  String id;
  String title;
  String creatorName;
  int numUsers;
  List<Bill> billList;
  List<GuestUser> guestUsers;

  Event({this.id, this.creatorName, this.numUsers, this.guestUsers, this.billList, this.title});

   //TODO implement this
  Event.fromJson(Map<String, dynamic> json){
    creatorName = json['creatorName'];
    id = json['id'];
    numUsers = json['numUsers'];
    title = json['title'];
    if (json['GuestUsers'] != null) {
      guestUsers = new List<GuestUser>();
      json['GuestUsers'].forEach((v) {
        guestUsers.add(new GuestUser.fromJson(v));
      });
    }
    if (json['billList'] != null) {
      billList = new List<Bill>();
      json['billList'].forEach((v) {
        billList.add(new Bill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creatorName'] = this.creatorName;
    data['id'] = this.id;
    data['numUsers'] = this.numUsers;
    data['title'] = this.title;
    if (this.guestUsers != null) {
    data['GuestUsers'] = this.guestUsers.map((v) => v.toJson()).toList();
    }
    if (this.billList != null) {
    data['billList'] = this.billList.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Bill {


  String title;
  String date;
  String id;
  String payer;
  double value;
  String photoURL;
  String notes;
  bool settled;
  String type;
  List<Payee> payeeList;

  Bill(

      { this.title,
        this.date,
        this.id,
        this.payer,
        this.value,
        this.settled,
        this.type,
        this.payeeList,
        this.notes,
        this.photoURL});

  Bill.fromJson(Map<String, dynamic> json) {

    title = json['title'];

    date = json['date'];
    id = json['id'];
    payer = json['payer'];
    value = json['value'];
    settled = json['settled'];
    type = json['type'];
    if (json['GuestPayee'] != null) {
      payeeList = new List<Payee>();
      json['GuestPayee'].forEach((v) {
        payeeList.add(new Payee.fromJson(v));
      });
    }
    photoURL = json['photoReference'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;

    data['date'] = this.date;
    data['id'] = this.id;
    data['payer'] = this.payer;
    data['value'] = this.value;
    data['settled'] = this.settled;
    data['type'] = this.type;
    if (this.payeeList != null) {
      data['GuestPayee'] = this.payeeList.map((v) => v.toJson()).toList();
    }
    data['photoReference'] = this.photoURL;
    data['notes'] = this.notes;
    return data;
  }
}

class Payee {

  double debt;
  bool settled;
  String name;
  int index;


  Payee({this.debt, this.settled, this.name, this.index});


  Payee.fromJson(Map<String, dynamic> json) {
    debt = json['debt'];
    settled = json['settled'];
    name = json['name'];
    index = json['index'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['debt'] = this.debt;
    data['settled'] = this.settled;
    data['name'] = this.name;
    data['index'] = this.index;

    return data;
  }
}


class Contact {
  String name;
  String id;
  String phoneNr;
  bool selected = false;

  Contact({this.name, this.phoneNr, this.id});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNr = json['phoneNr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phoneNr'] = this.phoneNr;

    return data;
  }

}