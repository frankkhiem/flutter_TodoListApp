import 'package:flutter/material.dart';
import 'models/task.dart';
import 'models/location.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'dart:async';
import 'full_map.dart';

class CreateTaskPage extends StatefulWidget {
  final String todoId;
  CreateTaskPage({ required this.todoId });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateTaskPageState();
  }
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  Task _task = new Task(
      id: '',
      todoId: '',
      name: '',
      description: '',
      finished: false,
      address: 'Nhà riêng',
      location: new Location());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextField _txtName = TextField(
      decoration: InputDecoration(
          hintText: "Tên nhiệm vụ",
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
      ),
      autocorrect: false,
      textAlign: TextAlign.left,
      onChanged: (text) {
        setState(() {
          this._task.name = text;
        });
      },
    );
    TextField _txtDesc = TextField(
      decoration: InputDecoration(
      hintText: "Mô tả",
      contentPadding: EdgeInsets.all(10.0),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
      ),
      autocorrect: false,
      textAlign: TextAlign.left,
      onChanged: (text) {
        setState(() {
          this._task.description = text;
        });
      },
    );
    final Text _txtFinished = Text("Hoàn thành:", style: TextStyle(fontSize: 16.0));
    final Checkbox _cbFinished = Checkbox(
        value: this._task.finished,
        onChanged: (bool? value) {
          setState(() {
            this._task.finished = value!;
          });
        }
    );
    TextField _txtAddress = TextField(
      decoration: InputDecoration(
          hintText: "Địa chỉ",
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
      ),
      autocorrect: false,
      textAlign: TextAlign.left,
      onChanged: (text) {
        setState(() {
          this._task.address = text;
        });
      },
    );
    ElevatedButton _btnLocation = ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => Scaffold(
              body: SafeArea(
                child: FullMapPage(),
              ),
            )));
      },
      child: Text("Bản đồ"),
    );

    final _btnSave = RaisedButton(
        child: Text("Tạo"),
        color: Theme.of(context).accentColor,
        elevation: 4.0,
        onPressed: () async {
          //Update an existing task ?
          Map<String, dynamic> params = Map<String, dynamic>();
          params["todoId"] = widget.todoId;
          params["name"] = this._task.name;
          params["description"] = this._task.description;
          params["finished"] = this._task.finished;
          params["address"] = this._task.address;
          var location = {};
          location["longitude"] = this._task.location.longitude;
          location["latitude"] = this._task.location.latitude;
          params["location"] = location;
          await createTask(http.Client(), params);
          Navigator.pop(context);
          Navigator.pop(context);
        }
    );

    ElevatedButton _btnCancel = ElevatedButton(
      child: Text("Hủy"),
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.redAccent
      ),
    );

    final _column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _txtName,
        _txtDesc,
        _txtAddress,
        _btnLocation,
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _txtFinished,
              _cbFinished
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(child: _btnSave),
            Expanded(child: _btnCancel),
          ],
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo nhiệm vụ"),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: _column,
      ),
    );
  }
}