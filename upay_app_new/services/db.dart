import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Db {
  static final  instance = Firestore.instance;
  static final String EVENT_IMAGES_DB = "events";
  static final  String GUEST_EVENTS_DB_COLLECTION_NAME = "GuestEvents";
  static final String SAMPLE_GUEST_EVENT_NAME ="mJ2OrstztwE6swM2Uhoi";
  static final String USERS_DB_COLLECTION_NAME = 'Users';

}