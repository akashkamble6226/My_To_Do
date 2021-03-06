import '../helper/data_base_helper.dart';
import '../models/task.dart';
import 'package:flutter/cupertino.dart';

//this is one container of a provider

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  //just copied the list to another using the getter
  List<Task> get task {
    return [..._tasks];
  }

  void addProduct(Task tsk) {
    final task = Task(
      id: DateTime.now().toString(),
      title: tsk.title,
      details: tsk.details,
    );
    _tasks.add(task);

    notifyListeners();

    DataBaseHelper.insertData('user_tasks', {
      'id': task.id,
      'name': task.title,
      'info': task.details,
    });
  }

  Future<void> fetchTasks() async {
    final taskList = await DataBaseHelper.fetchData('user_tasks');
    _tasks = taskList
        .map((i) => Task(
              id: i['id'],
              title: i['name'],
              details: i['info'],
            ))
        .toList();
    notifyListeners();
  }

  void edit(String id, Task tsk) {
    final upTaskID = _tasks.indexWhere((tx) => tx.id == id);

    if (upTaskID >= 0) {
      _tasks[upTaskID] = tsk;
      notifyListeners();
    } else {
      print('id doesent exist');
    }

    DataBaseHelper.update(tsk, {
      'id': _tasks[upTaskID].id,
      'name': _tasks[upTaskID].title,
      'info': _tasks[upTaskID].details
    });
  }

  void delete(String id) {
    _tasks.removeWhere((element) => element.id == id);
    notifyListeners();
    DataBaseHelper.deleteData('user_tasks', id);
  }

  Task findById(String taskId) {
    final tsk = task.firstWhere((element) => element.id == taskId);
    return tsk;
  }

  int findLeng() {
    int len = _tasks.length;
    return len;
  }
}
