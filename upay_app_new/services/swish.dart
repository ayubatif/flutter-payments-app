import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_package_manager/flutter_package_manager.dart';

Future<bool> isSwishAppInstalled(SwishPackageName) async {
  bool isSwishInstalled = false;
  try {
    final value = await FlutterPackageManager.getPackageInfo(SwishPackageName);
    if (value != null) {
      isSwishInstalled = true;
    }
  } catch(error) {
  }
  return isSwishInstalled;
}

String prepareSwishRecipientInformation(String phoneNumber, double amount, String message)  {
//  valid phone number examples: +46701111111, 0701111111
//  non valid phone number example: 46701111111
  String prepareSwishRecipientInformation =
  """{
  "version":1,
  "payee":{
    "value":"$phoneNumber",
    "editable": true
  },
  "amount":{
    "value":$amount,
    "editable": true},
  "message":{
    "value":"$message",
    "editable":true}
  }""";
  return prepareSwishRecipientInformation;
}

AssetGiffyDialog getSwishNotInstalledDialogue (){
  Future<void> _launchUniversalLink(String url) async {
    final bool nativeAppLaunchSucceeded = await launch(url, forceSafariVC: false);
    if (!nativeAppLaunchSucceeded) {
      await launch(url, forceSafariVC: true);
    }
  };
  AssetGiffyDialog swishNotInstalledDialogue;
  Future<void> _launched;
  swishNotInstalledDialogue = AssetGiffyDialog(
    image: Image.asset('assets/images/men_wearing_jacket.gif',
      fit: BoxFit.cover,
    ),
    buttonCancelText : Text("Cash is king"),
    title: Text('Swish is not installed',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 22.0, fontWeight: FontWeight.w600),
    ),
    entryAnimation: EntryAnimation.BOTTOM,
    description: Text('',
      textAlign: TextAlign.center,
      style: TextStyle(),
    ),
    buttonOkText : Text("Install"),
    onOkButtonPressed: () {
      String callBackUrl = "com.i1304andromeda.upayappnew:";
      String url = "https://play.google.com/store/apps/details?id=se.bankgirot.swish"+"&callbackurl=$callBackUrl";//+"&callbackresultparameter=$tempVariable";
      if (Platform.isIOS) {
        String url = "https://apps.apple.com/se/app/swish-payments/id563204724?l=en"+"&callbackurl=$callBackUrl";//+"&callbackresultparameter=$tempVariable";
      }
      _launched = _launchUniversalLink(url);
    },
  );
return swishNotInstalledDialogue;
}
