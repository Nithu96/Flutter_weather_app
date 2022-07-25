import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class crudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  var user = FirebaseAuth.instance.currentUser;

  Future<void> addData(carData) async {
    if (isLoggedIn()) {
      // This method use for small apps
      /*Firestore.instance
          .collection('testcrud')
          .add(carData).then((value){}).catchError((e) {print(e);}); */

      // This method use for large scale app
      FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference =
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('todo');
        reference.add(carData);
      });
    } else {
      print('You need to be logged in');
    }
  }

  getData() async {
    return await FirebaseFirestore.instance
        .collection('users').doc(user!.uid).collection('todo')
    //.orderBy('carName', descending: false)
        .snapshots();
  }

  updateData(selectDoc, newValues){
    FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('todo').doc(selectDoc).update(newValues).catchError((e){
      print(e);
    });
  }

  deleteData(docId){
    FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('todo').doc(docId).delete().catchError((e){
      print(e);
    });
  }
}