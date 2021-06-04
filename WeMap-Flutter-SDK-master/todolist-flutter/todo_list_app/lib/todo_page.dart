import 'package:flutter/material.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'edit_todo_page.dart';
import 'models/todo.dart';
import 'task_page.dart';


class TodoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TodoPageState();
  }
}

class _TodoPageState extends State<TodoPage> {
  Todo _todo = Todo(id: "", name: "", description: "", createdAt: "");

  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  void _createTodo() {
    _nameController.text = "";
    _descController.text = "";
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(padding: EdgeInsets.all(10), child: TextField(
                decoration: InputDecoration(labelText: 'Tên công việc'),
                onChanged: (text) {
                  setState(() {
                    _todo.name = text;
                  });
                },
                controller: _nameController,
              )),
              Container(padding: EdgeInsets.all(10), child:TextField(
                decoration: InputDecoration(labelText: 'Mô tả'),
                onChanged: (text){
                  setState(() {
                    _todo.description = text;
                  });
                },
                controller: _descController,
              )),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(child: SizedBox(child: RaisedButton(
                      color: Colors.teal,
                      child: Text('Save', style: TextStyle(fontSize: 16, color: Colors.white),),
                      onPressed: () async {
                        if( this._todo.name.isEmpty || this._todo.description.isEmpty ) {
                          return;
                        }
                        print('press Save');
                        Map<String, dynamic> params = Map<String, dynamic>();
                        params["name"] = this._todo.name;
                        params["description"] = this._todo.description;
                        await createTodo(http.Client(), params);
                        setState(() {
                          this._createTodo();
                        });
                        Navigator.of(context).pop();
                      },
                    ),height: 50,)),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(child: SizedBox(child: RaisedButton(
                      color: Colors.pinkAccent,
                      child: Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.white),),
                      onPressed: () {
                        print('Press cancel');
                        setState(() {
                          this._createTodo();
                        });
                        Navigator.of(context).pop();
                      },
                    ),height: 50,))
                  ],
                ),
              ),
              //ok button

            ],
          );
        });
  } //Modal tạo mới công việc

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách công việc")
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Todo",
        child: Icon(Icons.add),
        onPressed: () {
          _showModalSheet();
        },
      ),
      body: FutureBuilder(
        future: fetchTodoList(http.Client()),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            print(snapshot.error);
          }
          return snapshot.hasData ? TodoList(todos: snapshot.data):Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  final todos;
  TodoList({ required this.todos });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TodoListState();
  }
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      this.todos = widget.todos;
    });
    // TODO: implement build
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: index % 2 == 0 ? Color.fromARGB(211, 71, 231, 156) : Color.fromARGB(
                  230, 243, 171, 94),
            ),
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(todos[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                    Text(todos[index].description, style: TextStyle(fontSize: 16.0, color: Colors.red)),
                    Text('Date: ${todos[index].createdAt}', style: TextStyle(fontSize: 16.0),)
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new EditTodoPage(id: this.todos[index].id)
                          )
                      ).then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodoPage()
                            )
                        );
                      });
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                  //delete button
                    onPressed: () async {
                      await deleteTodo(http.Client(), this.todos[index].id);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TodoPage()
                          )
                      );
                    },
                    icon: Icon(Icons.delete))
              ],
            ),
          ),
          onTap: () {
            //Navigate when tap on Todo
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TaskPage(todoId: todos[index].id))
            );
          },
        );
      },
    );
  }
}
