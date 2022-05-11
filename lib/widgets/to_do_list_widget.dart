import 'package:app/providers/stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo_model.dart';
import '../services/firestore_service.dart';

class ToDoListWidget extends StatefulWidget {
  @override
  State<ToDoListWidget> createState() => _ToDoListWidgetState();
}

class _ToDoListWidgetState extends State<ToDoListWidget> {
  List? toDoList;

  @override
  Widget build(BuildContext context) {
    final streamProviderToDo = Provider.of<StreamProviderToDo>(context);
    Stream<List<ToDo>?> streamListToDo = streamProviderToDo.listOrder;

    return StreamBuilder<List<ToDo>?>(
      stream: streamListToDo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ToDo>? toDoList = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: toDoList!.length,
                itemBuilder: (BuildContext context, int index) {
                  final String strDate;
                  strDate = toDoList[index].dateTime != ""
                      ? toDoList[index].dateTime!.substring(0, 10)
                      : "Sin Fecha";

                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: const Color.fromARGB(31, 232, 102, 85),
                      child: const Center(
                        child: Text(
                          'Eliminado',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                    ),
                    onDismissed: (DismissDirection dismissDir) {
                      FirestoreServiceDB().deleteToDo(toDoList[index].uid);
                    },
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            FirestoreServiceDB()
                                .completeToDo(toDoList[index].uid);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:
                                    const Color.fromARGB(255, 165, 207, 228)),
                            child: toDoList[index].isComplet!
                                ? const Icon(
                                    Icons.thumb_up_rounded,
                                  )
                                : Container(),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (Text(
                              (toDoList[index].title != null)
                                  ? toDoList[index].title!
                                  : "",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            Text(
                              strDate,
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                        subtitle: (Text((toDoList[index].description != null)
                            ? toDoList[index].description!
                            : "")),
                        trailing: IconButton(
                          onPressed: () {
                            showEditToDoForm(context, toDoList[index]);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ),
                  );
                }),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  Future<dynamic> showEditToDoForm(BuildContext context, ToDo toDo) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: const Text(
              'Añadir R5 ToDo',
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: 350,
                  height: 230,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: toDo.title,
                        onChanged: (value) {
                          toDo.title = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Título ToDo',
                        ),
                      ),
                      TextFormField(
                        initialValue: toDo.description,
                        onChanged: (value) {
                          setState(() {
                            toDo.description = value;
                          });
                        },
                        decoration:
                            const InputDecoration(hintText: 'Descripción ToDo'),
                      ),
                      Row(
                        children: [
                          const Text('Pendiente'),
                          Switch(
                            value: toDo.isComplet!,
                            onChanged: (value) {
                              setState(() {
                                toDo.isComplet = value;
                              });
                            },
                          ),
                          const Text('Completada'),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Fecha Límite',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2024))
                                    .then((value) {
                                  setState(() {
                                    toDo.dateTime = value.toString();
                                  });
                                });
                              },
                              icon: const Icon(
                                Icons.date_range_rounded,
                                color: Colors.redAccent,
                              ))
                        ],
                      ),
                      Text((toDo.dateTime != null ? toDo.dateTime! : '')),
                    ],
                  ),
                );
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    //createToDo();
                    FirestoreServiceDB().editToDo(toDo.uid, toDo.title,
                        toDo.description, toDo.isComplet, toDo.dateTime);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar Cambios'),
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }
}
