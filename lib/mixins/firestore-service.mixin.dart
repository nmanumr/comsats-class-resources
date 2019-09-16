import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceMixin {
  final Firestore firestore = Firestore.instance;
  List<StreamSubscription> subscriptions = [];

  /// subscribe to firebase document changes
  /// and close the stream when service is closed
  void subscribeDocument(
    String path,
    void Function(DocumentSnapshot) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) {
    subscriptions.add(firestore.document(path).snapshots().listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        ));
  }

  /// subscribe to firebase collection changes
  /// and close the stream when service is closed
  void subscribeCollection(
    String path,
    void Function(QuerySnapshot) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) {
    subscriptions.add(firestore.collection(path).snapshots().listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        ));
  }

  void subscribeStream<T>(
    Stream<T> stream,
    void Function(T) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) {
    subscriptions.add(stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    ));
  }

  Future<void> close() async {
    for (var subscription in subscriptions) {
      await subscription.cancel();
    }
  }
}
