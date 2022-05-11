import 'package:app/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../models/todo_model.dart';

class StreamProviderToDo extends ChangeNotifier {
  Stream<List<ToDo>?> listOrder = FirestoreServiceDB().listToDo();

  setOrderByDate() {
    listOrder = FirestoreServiceDB().listToDoByDate();
    notifyListeners();
  }

  setOrderByComplete() {
    listOrder = FirestoreServiceDB().listToDoByComplete();
    notifyListeners();
  }
}
