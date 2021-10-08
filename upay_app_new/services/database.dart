import 'package:cloud_firestore/cloud_firestore.dart';
import'package:upayappnew/models/user.dart';
class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference UsersCollection = Firestore.instance.collection('Users');

  Future<void> updateUserData(String email, String name, String phoneNr, List <Contact> contactList, List<String> eventList, List<String> pastEvents)  async {
    return await UsersCollection.document(uid).setData({
      'email': email,
      'name': name,
      'phoneNr': phoneNr,
      'contactList': contactList,
      'eventList': eventList,
      'pastEvents': pastEvents,
    });
  }

List<User> _userListSnapshot (QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return User(
        name: doc.data['name'] ?? 'No name',
        phoneNr: doc.data['phoneNr'] ?? 'No phone number'
      );
    }).toList();
}

}