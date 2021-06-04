import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'location.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:todo_list_app/config.dart';

class Task {
  String id;
  String todoId;
  String name;
  String description;
  bool finished;
  String address;
  Location location;

  Task({
    required this.id,
    required this.todoId,
    required this.name,
    required this.description,
    required this.finished,
    required this.address,
    required this.location
});

  factory Task.fromJson(Map<String, dynamic> json) {
    Location location = Location.fromJson(json["location"]);
    Task newTask = new Task(
        id: json["_id"],
        todoId: json["todoId"],
        name: json["name"],
        description: json["description"],
        finished: json["finished"],
        address: json["address"],
        location: location);

    return newTask;
 }

  factory Task.clone(Task anotherTask) {
    return Task(
        id: anotherTask.id,
        todoId: anotherTask.todoId,
        name: anotherTask.name,
        description: anotherTask.description,
        finished: anotherTask.finished,
        address: anotherTask.address,
        location: anotherTask.location);
  }
}

//Các hàm gọi API liên quan tới Task

//Lấy danh sách Task theo todoId
Future<List<Task>> fetchTaskListByTodoId(http.Client client, String todoId) async {
  String url = '$URL_TASK_LIST_BY_TODO_ID/$todoId';
  final response = await client.get(Uri.parse(url));
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (mapResponse["success"]) {
      final tasks = mapResponse["TaskList"].cast<Map<String, dynamic>>();
      return tasks.map<Task>((json){
        return Task.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load Task');
  }
}

//Lấy 1 Task theo id
Future<Task> fetchTaskById(http.Client client, String id) async {
  String url = "$URL_TASK_BY_ID/$id";
  final response = await client.get(Uri.parse(url));
  if( response.statusCode == 200 ) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if( mapResponse["success"] ) {
      Map<String, dynamic> mapTask = mapResponse["Task"];
      return Task.fromJson(mapTask);
    } else {
      return Task(id: '', todoId: '', name: '', description: '', finished: false, address: '', location: new Location());
    }
  } else {
    throw Exception('Failed to load Task by Id from the Internet');
  }
}

// Tạo 1 Task mới trong 1 Todo
Future<bool> createTask(http.Client client, Map<String, dynamic> params) async {
  final response = await client.post(Uri.parse(URL_CREATE_TASK), headers: {"Content-Type": "application/json"}, body: jsonEncode(params));
  if( response.statusCode == 200 ) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return mapResponse["success"];
  } else {
    throw Exception('Failed to create a Task. Error: ${response.toString()}');
  }
}

//Update Task
Future<bool> updateTask(http.Client client, Map<String, dynamic> params) async {
  String url = "$URL_UPDATE_TASK/${params["id"]}";
  final response = await client.put(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: jsonEncode(params));
  if( response.statusCode == 200 ) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return mapResponse["success"];
  } else {
    throw Exception('Failed to update a Todo. Error: ${response.toString()}');
  }
}

// Delete Task
Future<bool> deleteTask(http.Client client, String id) async {
  String url = "$URL_DELETE_TASK/$id";
  final response = await client.delete(Uri.parse(url));
  if( response.statusCode == 200 ) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return mapResponse["success"];
  } else {
    throw Exception('Failed to delete a Task. Error: ${response.toString()}');
  }
}