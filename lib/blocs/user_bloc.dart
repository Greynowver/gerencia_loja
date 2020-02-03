import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {

  final _userController = BehaviorSubject();

  Map<String, Map<String, dynamic>> _user = {};

  Firestore _firestore = Firestore.instance;

  UserBloc(){
    _addUsersListener();
  }

  void _addUsersListener(){
    _firestore.collection("users").snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){

        String uid = change.document.documentID;

        switch(change.type){
          case DocumentChangeType.added:
            _user[uid] = change.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _user[uid].addAll(change.document.data);
            _userController.add(_user.values.toList());
            break;
          case DocumentChangeType.removed:
            _user.remove(uid);
            _unsubscribeToOrders(uid);
            _userController.add(_user.values.toList());
            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _user[uid]["subscription"] = _firestore.collection("users").document(uid)
        .collection("orders").snapshots().listen((orders) async {

          int numOrders = orders.documents.length;
          double totalPrice = 0.0;

          for(DocumentSnapshot d in orders.documents){
            DocumentSnapshot order = await _firestore.collection("orders")
                .document(d.documentID).get();

            if(order.data == null) continue;

            totalPrice += order.data["totalPrice"];
          }

          _user[uid].addAll(
            {"money" : totalPrice, "orders": numOrders}
          );
          
          _userController.add(_user.values.toList());
    });
  }

  void _unsubscribeToOrders(String uid){
    _user[uid]["subscription"].cancel();
  }

  @override
  void dispose() {
    _userController.close();
  }
}