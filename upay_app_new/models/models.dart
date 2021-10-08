class GuestEvent {
  String creatorName;
  String id;
  int numUsers;
  String title;
  String phoneNumber;
  List<GuestUser> guestUsers;
  List<GuestBill> guestBills;

  GuestEvent(
      {this.creatorName,
        this.id,
        this.numUsers,
        this.title,
        this.guestUsers,
        this.guestBills,
       this.phoneNumber});

  GuestEvent.fromJson(Map<String, dynamic> json) {
    creatorName = json['creatorName'];
    id = json['id'];
    numUsers = json['numUsers'];
    title = json['title'];
    phoneNumber = json['phoneNumber'];
    if (json['GuestUsers'] != null) {
      guestUsers = new List<GuestUser>();
      json['GuestUsers'].forEach((v) {
        guestUsers.add(new GuestUser.fromJson(v));
      });
    }
    if (json['GuestBills'] != null) {
      guestBills = new List<GuestBill>();
      json['GuestBills'].forEach((v) {
        guestBills.add(new GuestBill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creatorName'] = this.creatorName;
    data['id'] = this.id;
    data['numUsers'] = this.numUsers;
    data['title'] = this.title;
    data['phoneNumber'] = this.phoneNumber;
    if (this.guestUsers != null) {
      data['GuestUsers'] = this.guestUsers.map((v) => v.toJson()).toList();
    }
    if (this.guestBills != null) {
      data['GuestBills'] = this.guestBills.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GuestUser {
  String phoneNumber;
  double balance;
  String name;
  String id;
  double amountToGet;
  double amountToPay;

  GuestUser({this.phoneNumber, this.balance, this.name, this.id, this.amountToGet, this.amountToPay});

  GuestUser.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    balance = json['balance'];
    name = json['name'];
    id = json['id'];
    amountToGet = json['amountToGet'];
    amountToPay = json['amountToPay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['balance'] = this.balance;
    data['name'] = this.name;
    data['id'] = this.id;
    data['amountToGet'] = this.amountToGet;
    data['amountToPay'] = this.amountToPay;

    return data;
  }
}

class GuestBill {


  String title;
  String date;
  String id;
  String payer;
  double value;
  String photoURL;
  String notes;
  bool settled;
  String type;
  List<GuestPayee> guestPayee;

  GuestBill(

      { this.title,
        this.date,
        this.id,
        this.payer,
        this.value,
        this.settled,
        this.type,
        this.guestPayee,
        this.notes,
        this.photoURL});

  GuestBill.fromJson(Map<String, dynamic> json) {

    title = json['title'];

    date = json['date'];
    id = json['id'];
    payer = json['payer'];
    value = json['value'];
    settled = json['settled'];
    type = json['type'];
    if (json['GuestPayee'] != null) {
      guestPayee = new List<GuestPayee>();
      json['GuestPayee'].forEach((v) {
        guestPayee.add(new GuestPayee.fromJson(v));
      });
    }
    photoURL = json['photoURL'];
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
    if (this.guestPayee != null) {
      data['GuestPayee'] = this.guestPayee.map((v) => v.toJson()).toList();
    }
    data['photoURL'] = this.photoURL;
    data['notes'] = this.notes;
    return data;
  }
}

class GuestPayee {

  double debt;
  bool settled;
  String name;
  int index;


  GuestPayee({this.debt, this.settled, this.name, this.index});


  GuestPayee.fromJson(Map<String, dynamic> json) {
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
