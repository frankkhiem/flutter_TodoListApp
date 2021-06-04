import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_list_app/config.dart';

class Todo {
  String id;
  String name;
  String description;
  String createdAt;

  Todo({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["createdAt"]
    );
  }

  factory Todo.clone(Todo anotherTodo) {
    return Todo(
        id: anotherTodo.id,
        name: anotherTodo.name,
        description: anotherTodo.description,
        createdAt: anotherTodo.createdAt);
  }
}

// Lấy danh sách Todo từ API
Future<List<Todo>> fetchTodoList(http.Client client) async {
  final response = await client.get(Uri.parse(URL_TODOLIST));
  if( response.statusCode == 200 ) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if( mapResponse["success"] ) {
      final todos = mapResponse["TodoList"].cast<Map<String, dynamic>>();
      final todoList = await todos.map<Todo>((json) {
        return Todo.fromJson(json);
      }).toList();
      return todoList;
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load TodoList from the Internet');
  }
}

//Lấy 1 Todo theo id
Future<Todo> fetchTodoById(http.Client client, String id) async {
  String url = "$URL_TODOBYID/$id";
  final response = await client.get(Uri.parse(url));
  if( response.statusCode == 200 ) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if( mapResponse["success"] ) {
      Map<String, dynamic> mapTodo = mapResponse["Todo"];
      return Todo.fromJson(mapTodo);
    } else {
      return Todo(id: '', name: '', description: '', createdAt: '');
    }

  } else {
    throw Exception('Failed to load Todo by Id from the Internet');
  }
}

//Thêm 1 Todo
Future<bool> createTodo(http.Client client, Map<String, dynamic> params) async {
  final response = await client.post(Uri.parse(URL_CREATE_TODO), body: params);
  if( response.statusCode == 200 ) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return mapResponse["success"];
  } else {
    throw Exception('Failed to create a Todo. Error: ${response.toString()}');
  }
}

//Update 1 Todo
Future<bool> updateTodo(http.Client client, Map<String, dynamic> params) async {
  String url = '$URL_UPDATE_TODO/${params["id"]}';
  final response = await client.put( Uri.parse(url), body: params);
  if( response.statusCode == 200 ) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return mapResponse["success"];
  } else {
    throw Exception('Failed to update a Todo. Error: ${response.toString()}');
  }
}

//Delete 1 Todo
Future<bool> deleteTodo(http.Client client, String id) async {
  String url = "$URL_DELETE_TODO/$id";
  final response = await client.delete(Uri.parse(url));
  if( response.statusCode == 200 ) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    return mapResponse["success"];
  } else {
    throw Exception('Failed to delete a Todo. Error: ${response.toString()}');
  }
}