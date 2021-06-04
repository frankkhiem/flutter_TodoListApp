import 'package:flutter/material.dart';
import 'models/todo.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'todo_page.dart';

class EditTodoPage extends StatefulWidget {
  final String id;
  EditTodoPage({ required this.id });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditTodoPageState();
  }
}

class _EditTodoPageState extends State<EditTodoPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa công việc"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: fetchTodoById(http.Client(), widget.id),
          builder:(context, snapshot){
            if (snapshot.hasError) print(snapshot.error);
            if (snapshot.hasData) {
              return DetailTodo(todo: snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class DetailTodo extends StatefulWidget {
  final todo;
  DetailTodo({ required this.todo });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailTodoState();
  }
}

class _DetailTodoState extends State<DetailTodo> {
  Todo todo = new Todo(id: '', name: '', description: '', createdAt: '');
  bool isLoadedTodo = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(isLoadedTodo == false) {
      setState(() {
        this.todo = Todo.clone(widget.todo);
        this.isLoadedTodo = true;
      });
    }
    final TextFormField _txtTodoName = new TextFormField(
      decoration: InputDecoration(
          hintText: "Nhập vào tên công việc",
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
      ),
      autocorrect: false,
      initialValue: this.todo.name,
      textAlign: TextAlign.left,
      onChanged: (text) {
        setState(() {
          this.todo.name = text;
        });
      },
    );
    final TextFormField _txtTodoDesc = new TextFormField(
      decoration: InputDecoration(
          hintText: "Mô tả",
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
      ),
      autocorrect: true,
      initialValue: this.todo.description,
      onChanged: (text) {
        setState(() {
          this.todo.description = text;
        });
      },
    );
    final Text _txtCreateAt = Text("Finished: ${this.todo.createdAt}", style: TextStyle(fontSize: 16.0));

    final _btnSave = RaisedButton(
        child: Text("Save"),
        color: Theme.of(context).accentColor,
        elevation: 4.0,
        onPressed: () async {
          //Update an existing task ?
          Map<String, dynamic> params = Map<String, dynamic>();
          params["id"] = this.todo.id;
          params["name"] = this.todo.name;
          params["description"] = this.todo.description;
          await updateTodo(http.Client(), params);
          Navigator.pop(context);
        }
    );

    final _btnDelete = RaisedButton(
      child: Text("Delete"),
      color: Colors.redAccent,
      elevation: 4.0,
      onPressed: () async {
        //Delete a Task
        //await deleteATask(http.Client(), this.task.id);
        //Navigator.pop(context);
        //Show "Confirmation dialog"
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Xác nhận xóa!"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Bạn có chắc muốn xóa \"${this.todo.name}\" không?")
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('Đồng ý'),
                    onPressed: () async {
                      await deleteTodo(http.Client(), this.todo.id);
                      Navigator.pop(context);//Quit Dialog
                      Navigator.pop(context);//Quit to previous screen
                    },
                  ),
                  new FlatButton(
                    child: new Text('Không'),
                    onPressed: () async {
                      Navigator.pop(context);//Quit to previous screen
                    },
                  ),
                ],
              );
            }
        );
      },
    );

    final _column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _txtTodoName,
        _txtTodoDesc,
        _txtCreateAt,
        Row(
          children: <Widget>[
            Expanded(child: _btnSave),
            Expanded(child: _btnDelete)
          ],
        )
      ],
    );

    return Container(
      margin: EdgeInsets.all(10.0),
      child: _column,
    );
  }
}