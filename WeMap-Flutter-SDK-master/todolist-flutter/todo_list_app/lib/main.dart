import 'package:flutter/material.dart';
import 'todo_page.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:wemapgl/wemapgl.dart' as WEMAP;

void main() {
  WEMAP.Configuration.setWeMapKey('GqfwrZUEfxbwbnQUhtBMFivEysYIxelQ');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KHyM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoPage(),
    );
  }
}

//chạy bằng lệnh này flutter run --no-sound-null-safety