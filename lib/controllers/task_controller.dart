import 'package:get/get.dart';

import '../models/task.dart';

import 'package:to_do_app/database/db_helper.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTask();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  void getTask() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTask();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTask();
  }
}
