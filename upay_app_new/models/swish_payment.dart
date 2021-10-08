import 'package:upayappnew/models/models.dart';

class SwishPayment {
  String phoneNr;
  double amount;
  String message;
  String payer; //this is used for creating a new bill when settling a debt
  String payee;


  SwishPayment({this.phoneNr, this.amount, this.message, this.payer, this.payee});
}