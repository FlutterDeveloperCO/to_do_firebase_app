import 'package:app/services/firestore_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/stream_provider.dart';
import '../widgets/to_do_list_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? toDoList;
  String? title, description;
  bool completedToDo = false;
  String? dateTimeLimit;

  @override
  Widget build(BuildContext context) {
    final streamProviderToDo = Provider.of<StreamProviderToDo>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.checklist_rounded),
            SizedBox(width: 8),
            Text(
              'ToDo App',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => streamProviderToDo.setOrderByDate(),
            icon: const Icon(Icons.date_range_rounded),
          ),
          IconButton(
            onPressed: () => streamProviderToDo.setOrderByComplete(),
            icon: const Icon(Icons.playlist_add_check_rounded),
          ),
        ],
      ),
      body: ToDoListWidget(),
      floatingActionButton: addNewToDo(context),
    );
  }

  FloatingActionButton addNewToDo(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(
          Icons.post_add_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          dateTimeLimit = "";
          completedToDo = false;
          showNewToDoForm(context);
        });
  }

  Future<dynamic> showNewToDoForm(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          title = "";
          description = "";
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: const Text(
              'Añadir ToDo',
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: 350,
                  height: 220,
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          title = value;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Título ToDo'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                        decoration:
                            const InputDecoration(hintText: 'Descripción ToDo'),
                      ),
                      Row(
                        children: [
                          const Text('Pendiente'),
                          Switch(
                            onChanged: (value) {
                              setState(() {
                                completedToDo = value;
                              });
                            },
                            value: completedToDo,
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
                                    if (value != null) {
                                      dateTimeLimit = value.toString();
                                    }
                                  });
                                });
                              },
                              icon: const Icon(
                                Icons.date_range_rounded,
                                color: Colors.redAccent,
                              ))
                        ],
                      ),
                      Text((dateTimeLimit != null
                          ? dateTimeLimit.toString()
                          : '')),
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
                    FirestoreServiceDB().createNewToDo(
                        title, description, completedToDo, dateTimeLimit);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Añadir'),
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }
}
