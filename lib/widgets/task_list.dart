import '../provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  DateTime time;

  @override
  void initState() {
    // TODO: implement initState

    time = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //settled the listnear

    final taskList = Provider.of<TaskProvider>(context);

    final myTasks = taskList.task;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: HexColor('#7A7A7A'),
      key: _scaffoldKey,
      body: Column(children: [
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                DateFormat.yMMMMEEEEd().format(time).toString(),
                style: TextStyle(color: Colors.white),
              ),
            )),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: myTasks.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Card(
                  elevation: 15,
                  color: HexColor('#4A4A4A'),
                  child: ListTile(
                    leading: Wrap(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            CircleAvatar(
                              backgroundColor: HexColor('#383838'),
                              radius: 15,
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    title: Text(
                      myTasks[index].title,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    subtitle: Text(
                      myTasks[index].details,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    trailing: Wrap(
                      direction: Axis.vertical,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              print('onclick');
                              print(myTasks[index].id);

                              Navigator.of(context).pushNamed('/update-page',
                                  arguments: myTasks[index].id);
                            }),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (ctx) => AlertDialog(
                                elevation: 25,
                                backgroundColor: HexColor('#323232'),
                                title: Text(
                                  'Is your task finished ?',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                content: Text(
                                    'You are about to delete the task.',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancle',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  TextButton(
                                    onPressed: () {
                                      taskList.delete(myTasks[index].id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ]),
    );
  }
}
