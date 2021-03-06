import './Screens/add_task.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Screens/add_task.dart';
import 'Screens/main_page.dart';
import 'package:provider/provider.dart';
import './provider/task_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => TaskProvider(),
      child: MaterialApp(
        title: 'MyToDo',
        theme: ThemeData(
          fontFamily: 'ReggaeOne',
          primaryColor: HexColor('#4A4A4A'),
          accentColor: HexColor('#727272'),
        ),
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        routes: {
          '/update-page': (ctx) => AddNewTask(),
        },
      ),
    );
  }
}
