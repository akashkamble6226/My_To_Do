import '../provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import 'package:rive/rive.dart';

class AddNewTask extends StatefulWidget {
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final _formKey = GlobalKey<FormState>();

  bool isInit = true;

  DateTime selectedDate = DateTime.now();

  var _editedProdct = Task(
    id: null,
    title: '',
    details: '',
  );

  // final _nextField = FocusNode();
  // final _prevField = FocusNode();
  // final _dtField = FocusNode();

  var _initilValues = {
    'title': '',
    'details': '',
  };

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/addTask.riv').then(
      (data) async {
        var file = RiveFile();
        // Load the RiveFile from the binary data.
        var success = file.import(data);
        if (success) {
          // The artboard is the root of the animation and is what gets drawn
          // into the Rive widget.
          var artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(
            _controller = SimpleAnimation('addtask'),
          );
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final taskId = ModalRoute.of(context).settings.arguments as String;

      print(taskId);

      if (taskId != null)
      //means i do have task
      {
        _editedProdct =
            Provider.of<TaskProvider>(context, listen: false).findById(taskId);

        _initilValues = {
          'title': _editedProdct.title,
          'details': _editedProdct.details,
        };
      }
    }

    isInit = false;
    super.didChangeDependencies();
  }

  int lng = 0;

  void _saveForm() {
    final _isValid = _formKey.currentState.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();

    print(_editedProdct.id);
    if (_editedProdct.id != null) {
      Provider.of<TaskProvider>(context, listen: false)
          .edit(_editedProdct.id, _editedProdct);
      Navigator.of(context).pop();
    } else {
      Provider.of<TaskProvider>(context, listen: false)
          .addProduct(_editedProdct);

      Navigator.of(context).pop();
    }
  }

  //disposing focus node to avoid memory leak
  @override
  void dispose() {
    // _nextField.dispose();
    // _prevField.dispose();
    super.dispose();
  }

  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#4A4A4A'),
      ),
      backgroundColor: HexColor('#7A7A7A'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 80,
                            height: 80,
                            child: Rive(artboard: _riveArtboard),
                          ),
                        ),
                        _editedProdct.id != null
                            ? Text(
                                'Update Your Task ',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )
                            : Text(
                                ' Add your today\s task',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(50),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                //sending map further

                                Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(50),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          initialValue: _initilValues['title'],
                                          onSaved: (val) {
                                            _editedProdct = Task(
                                              id: _editedProdct.id,
                                              title: val,
                                              details: _editedProdct.details,
                                            );
                                          },
                                          validator: (val) {
                                            if (val.isEmpty) {
                                              return 'Please write something';
                                            }

                                            return null;
                                          },
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.left,
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              hintText: 'Name Of Task',
                                              hintStyle: TextStyle(
                                                  color: Colors.white),
                                              filled: true,
                                              fillColor: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          initialValue:
                                              _initilValues['details'],
                                          onSaved: (val) {
                                            _editedProdct = Task(
                                              id: _editedProdct.id,
                                              title: _editedProdct.title,
                                              details: val,
                                            );
                                          },
                                          validator: (val) {
                                            if (val.isEmpty) {
                                              return 'Please write something';
                                            }

                                            return null;
                                          },
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.left,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 10),
                                              border: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              alignLabelWithHint: true,
                                              hintText: 'Details',
                                              hintStyle: TextStyle(
                                                  color: Colors.white),
                                              filled: true,
                                              fillColor: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            _saveForm();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(27),
                                              color: HexColor('#8D8D8D'),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                child: Text(
                                                  _editedProdct.id != null
                                                      ? 'Update Task'
                                                      : 'Add Task',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
