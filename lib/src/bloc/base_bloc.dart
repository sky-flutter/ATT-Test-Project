import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S> {
  late StreamSubscription<ConnectivityResult> subscription;
  ConnectivityResult? result;

  BaseBloc(S initialState) : super(initialState) {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      this.result = result;
    });
  }

  Future<bool> isConnectionAvailable() async {
    var result = await Connectivity().checkConnectivity();
    return result != null && result != ConnectivityResult.none;
  }

  CollectionReference usersRef() => FirebaseFirestore.instance.collection('users');
  CollectionReference notesRef() => FirebaseFirestore.instance.collection('notes');

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
