import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required TaskModel task});
  Future<TaskModel?> getTask({required String id});
  Future<List<TaskModel>> getAllTask();
  Future<bool> deleteTask({required TaskModel task});
  Future<TaskModel> updateTask({required TaskModel task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<TaskModel> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box<TaskModel>('tasks');
  }

  @override
  Future<void> addTask({required TaskModel task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required TaskModel task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<TaskModel>> getAllTask() async {
    List<TaskModel> _allTask = <TaskModel>[];
    _allTask = _taskBox.values.toList();
    if (_allTask.isNotEmpty) {
      _allTask.sort(
          (TaskModel a, TaskModel b) => b.createdAt.compareTo(a.createdAt));
    }
    return _allTask;
  }

  @override
  Future<TaskModel?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<TaskModel> updateTask({required TaskModel task}) async {
    await task.save();
    return task;
  }
}
