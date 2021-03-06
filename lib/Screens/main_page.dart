import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../widgets/add_button.dart';
import '../widgets/task_list.dart';
import '../provider/task_provider.dart';
// import '../widgets/empty_image.dart';
import 'package:rive/rive.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/empty.riv').then(
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
            _controller = SimpleAnimation('emptysection'),
          );
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Image.asset(
          //   'assets/bucket.png',
          //   width: 50,
          //   height: 50,
          // ),
        ],
        backgroundColor: HexColor('#4A4A4A'),
        title: Text(
          'My To Do Task\'s ',
          style: TextStyle(fontSize: 16),
        ),
      ),
      backgroundColor: HexColor('#7A7A7A'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          addButton(context),
          FutureBuilder(
            future:
                Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Consumer<TaskProvider>(
                        builder: (ctx, tx, ch) => tx.task.length <= 0
                            ? Center(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 250,
                                      height: 250,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Rive(artboard: _riveArtboard),
                                      ),
                                    ),
                                    Text(
                                      "No Task is added yet !",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              )
                            : Flexible(
                                child: TaskList(),
                              ),
                      ),
          ),
        ],
      ),
    );
  }
}
