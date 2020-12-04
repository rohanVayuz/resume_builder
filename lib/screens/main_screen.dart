import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:resume_builder/screens/add_video_screen.dart';
import 'package:resume_builder/screens/play_recorded_vide.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Box<String> videoPathsBox;
  VideoPlayerController _videoPlayerController;
  final picker = ImagePicker();
  String _galleryVideo;
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();

    videoPathsBox = Hive.box<String>("videoPaths");
  }

  pickMyVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    setState(() {
      _galleryVideo = pickedFile.path;

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => PlayRecordedVideo(
            path: _galleryVideo,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => RecordVideoScreen()));
      */
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.add_event,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),

        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,

        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(
                Icons.image,
                color: Colors.white,
              ),
              backgroundColor: Colors.indigoAccent,
              label: 'Gallery',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                pickMyVideo();
              }),
          SpeedDialChild(
            child: Icon(
              Icons.fiber_manual_record,
              color: Colors.white,
            ),
            backgroundColor: Colors.indigoAccent,
            label: 'Record',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => RecordVideoScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: ValueListenableBuilder(
                valueListenable: videoPathsBox.listenable(),
                builder: (BuildContext context, Box<String> videoPaths, _) {
                  if (videoPaths.keys.isEmpty) {
                    return Center(
                      child: Text("No Videos Found!"),
                    );
                  }
                  // return ListView.separated(
                  //   itemCount: videoPaths.keys.toList().length,
                  //   itemBuilder: (context, index) {
                  //     final key = videoPaths.keys.toList()[index];
                  //     final value = videoPaths.get(key);
                  //     return ListTile(
                  //       title: Text("$value"),
                  //       subtitle: Text("$key"),
                  //     );
                  //   },
                  //   separatorBuilder: (BuildContext context, int index) {
                  //     return Divider();
                  //   },
                  // );
                  return PageView.builder(
                    onPageChanged: (index) {
                      // _videoPlayerController.pause();

                      // controller.pause();
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: videoPaths.keys.length,
                    itemBuilder: (context, index) {
                      final key = videoPaths.keys.toList()[index];
                      final value = videoPaths.get(key);

                      // File currVideoFile = File(value);
                      _videoPlayerController =
                          VideoPlayerController.file(File(value));

                      return VideoCard(
                        controller: _videoPlayerController,
                      );
                    },
                  );
                },
              ))
        ],
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoCard({Key key, this.controller}) : super(key: key);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize().then((_) {
      setState(() {
        widget.controller.play();
        widget.controller.setLooping(true);
      });
    }).catchError((e) {
      print('Video initializing error = $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.value != null &&
            widget.controller.value.initialized
        ? GestureDetector(
            onTap: () {
              setState(() {
                if (widget.controller.value.isPlaying) {
                  widget.controller.pause();
                } else {
                  widget.controller.play();
                }
              });
            },
            child: Stack(
              children: [
                SizedBox.expand(
                    child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: widget.controller.value.size?.width ?? 0,
                    height: widget.controller.value.size?.height ?? 0,
                    child: VideoPlayer(widget.controller),
                  ),
                )),
                Visibility(
                  visible: !widget.controller.value.isPlaying,
                  child: Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
