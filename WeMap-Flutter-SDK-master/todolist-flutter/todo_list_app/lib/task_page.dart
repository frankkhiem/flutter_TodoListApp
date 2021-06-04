import 'package:flutter/material.dart';
import 'models/task.dart';
import 'package:http/http.dart' as http;
import 'create_task_page.dart';
import 'dart:async';
import 'detail_task_page.dart';

class TaskPage extends StatefulWidget {
  final String todoId;
  TaskPage({ required this.todoId });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TaskPageState();
  }
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách các nhiệm vụ"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              //Press this button to navigate to create Task
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new CreateTaskPage(todoId: widget.todoId))
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: fetchTaskListByTodoId(http.Client(), widget.todoId),
          builder: (context, snapshot){
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? TaskList(tasks: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class TaskList extends StatefulWidget {
  final tasks;
  TaskList({ this.tasks });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TaskListState();
  }
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      this.tasks = widget.tasks;
    });
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: index % 2 == 0 ? Color.fromARGB(206, 238, 211, 33) : Color.fromARGB(
                  185, 55, 231, 57),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment:CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.tasks[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                Text('Vị trí: ${this.tasks[index].address} \(${this.tasks[index].location.longitude}, ${this.tasks[index].location.latitude}\)', style: TextStyle(fontSize: 16.0)),
                Row(
                  children: [
                    Text("Hoàn thành:", style: TextStyle(fontSize: 16.0)),
                    tasks[index].finished==true?Icon(Icons.done):Icon(Icons.clear),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {

                        },
                        icon: Icon(Icons.location_on)
                    ),
                    IconButton(
                        onPressed: () async {
                          await deleteTask(http.Client(), this.tasks[index].id);
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.delete_outline)
                    )
                  ],
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new DetailTaskPage(task: this.tasks[index]))
            );
          } ,
        );
      },
      itemCount: this.tasks.length,
    );
  }
}