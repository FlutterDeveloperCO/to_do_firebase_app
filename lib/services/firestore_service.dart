import 'package:app/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceDB {
  CollectionReference toDoCollection =
      FirebaseFirestore.instance.collection('ToDoList');

  Future createNewToDo(String? title, String? description, bool isComplet,
      String? dateTime) async {
    return await toDoCollection.add({
      "title": title ?? "",
      "description": description ?? "",
      "isComplet": isComplet,
      "dateLimit": dateTime ?? "",
    });
  }

  Future completeToDo(uid) async {
    await toDoCollection.doc(uid).update({"isComplet": true});
  }

  List<ToDo>? toDoListFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return ToDo(
            uid: e.id,
            title: e["title"],
            description: e["description"],
            isComplet: e["isComplet"],
            dateTime: e["dateLimit"]);
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<ToDo>?> listToDo() {
    return toDoCollection.snapshots().map(toDoListFromFirestore);
  }

  Stream<List<ToDo>?> listToDoByDate() {    
    return toDoCollection.orderBy("dateLimit").snapshots().map(toDoListFromFirestore);
  }

    Stream<List<ToDo>?> listToDoByComplete() {    
    return toDoCollection.orderBy("isComplet", descending: true).snapshots().map(toDoListFromFirestore);
  }

  Future editToDo(uid, title, description, isComplet, dateLimit) async {
    await toDoCollection.doc(uid).update({
      "title": title,
      "isComplet": isComplet,
      "description": description,
      "dateLimit": dateLimit
    });
  }

  deleteToDo(toDo) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('ToDoList').doc(toDo);

    documentReference
        .delete()
        .whenComplete(() => print('Eliminación Correcta'));
  }
}
