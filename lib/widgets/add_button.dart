import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Screens/add_task.dart';

Widget addButton(context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipOval(
      child: Material(
        color: HexColor('#4A4A4A'),
        child: InkWell(
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNewTask(),
              ),
            );
          },
        ),
      ),
    ),
  );
}
