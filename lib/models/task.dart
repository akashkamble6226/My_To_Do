import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Task {
  final String id;
  final String title;
  final String details;

  Task({
    @required this.id,
    @required this.title,
    @required this.details,
  });
}
