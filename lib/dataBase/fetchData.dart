import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:akshayam/model/services.dart';

const String Service_Collection = "services";

class DataBaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  late final CollectionReference _servicesRef;

  DataBaseService() {
    _servicesRef = _fireStore
        .collection(Service_Collection)
        .withConverter<Service>(
      fromFirestore: (snapshots, _) => Service.fromJson(snapshots.data()!),
      toFirestore: (service, _) => service.toJson(),
    );
  }

  Stream<QuerySnapshot?> getServices() {
    return _servicesRef.snapshots();
  }

  Future<void> addService(Service service) async {
    _servicesRef.add(service);
  }

  void updateService(String serviceId, Service service) {
    _servicesRef.doc(serviceId).update(service.toJson());
  }

  void removeService(String serviceId) {
    _servicesRef.doc(serviceId).delete();
  }
}