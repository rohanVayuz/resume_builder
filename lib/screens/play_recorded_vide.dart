import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:hive/hive.dart';
import 'package:resume_builder/screens/main_screen.dart';
import 'package:uuid/uuid.dart';

import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart' as PackagageVideoPlayer;

class PlayRecordedVideo extends StatefulWidget {
  final String path;

  PlayRecordedVideo({@required this.path});

  @override
  _PlayRecordedVideoState createState() => _PlayRecordedVideoState();
}

class _PlayRecordedVideoState extends State<PlayRecordedVideo> {
  FlutterFFmpeg fFmpeg;
  Box<String> videoPathsBox;
  PackagageVideoPlayer.VideoPlayerController _controller;
  File fileInfo;
  var uuid = Uuid();
  List<String> previewPaths = [];

  // final spinkit = SpinKitChasingDots(
  //   color: Colors.white,
  //   size: 50.0,
  // );
  void getVideo() async {
    fileInfo = File(widget.path);
    _controller = PackagageVideoPlayer.VideoPlayerController.file(fileInfo)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void initState() {
    super.initState();
    getVideo();
    fFmpeg = new FlutterFFmpeg();
    videoPathsBox = Hive.box<String>("videoPaths");
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: double.infinity,
        child: _controller == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _controller.value.initialized
                ? GestureDetector(
                    onTap: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          PackagageVideoPlayer.VideoPlayer(
                            _controller,
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 120.0,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        // RaisedButton(
                                        //   onPressed: () async {
                                        //     final Directory extDir =
                                        //     await getTemporaryDirectory();
                                        //     final String dirPath =
                                        //         '${extDir.path}/ResumeBuilder/Filtered';
                                        //     await Directory(dirPath)
                                        //         .create(recursive: true);
                                        //     final String filePath =
                                        //         '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}';
                                        //     await fFmpeg.execute('-i ' +
                                        //         widget.path +
                                        //         ' -vf hue=H=-7  ' +
                                        //         // ' -vf hue="H=2*PI*t: s=sin(2*PI*t)+1",eq=contrast=1.5,eq=brightness=0.3  ' +
                                        //         filePath +
                                        //         '-output.mp4');
                                        //     _controller = PackagageVideoPlayer
                                        //         .VideoPlayerController
                                        //         .file(
                                        //         File(filePath + '-output.mp4'))
                                        //       ..initialize().then((_) {
                                        //         setState(() {
                                        //           _controller.play();
                                        //           _controller.setLooping(true);
                                        //           print("FILTERED FILE SAVED " +
                                        //               filePath +
                                        //               '-output.mp4');
                                        //           previewPaths.add(filePath);
                                        //         });
                                        //       });
                                        //   },
                                        //   child: Text("Filter 1"),
                                        // ),
                                        // RaisedButton(
                                        //   onPressed: () async {
                                        //     final Directory extDir =
                                        //     await getTemporaryDirectory();
                                        //     final String dirPath =
                                        //         '${extDir.path}/ResumeBuilder/Filtered';
                                        //     await Directory(dirPath)
                                        //         .create(recursive: true);
                                        //     final String filePath =
                                        //         '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}';
                                        //     await fFmpeg.execute('-i ' +
                                        //         widget.path +
                                        //         ' -vf hue=H=7  ' +
                                        //         // ' -vf hue="H=2*PI*t: s=sin(2*PI*t)+1",eq=contrast=1.5,eq=brightness=0.3  ' +
                                        //         filePath +
                                        //         '-output.mp4');
                                        //     _controller = PackagageVideoPlayer
                                        //         .VideoPlayerController
                                        //         .file(
                                        //         File(filePath + '-output.mp4'))
                                        //       ..initialize().then((_) {
                                        //         setState(() {
                                        //           _controller.play();
                                        //           _controller.setLooping(true);
                                        //           print("FILTERED FILE SAVED " +
                                        //               filePath +
                                        //               '-output.mp4');
                                        //           previewPaths.add(filePath);
                                        //         });
                                        //       });
                                        //   },
                                        //   child: Text("Filter 2"),
                                        // ),
                                        // RaisedButton(
                                        //   onPressed: () async {
                                        //     final Directory extDir =
                                        //     await getTemporaryDirectory();
                                        //     final String dirPath =
                                        //         '${extDir.path}/ResumeBuilder/Filtered';
                                        //     await Directory(dirPath)
                                        //         .create(recursive: true);
                                        //     final String filePath =
                                        //         '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}';
                                        //     await fFmpeg.execute('-i ' +
                                        //         widget.path +
                                        //         // ' -vf hue=H=-7  ' +
                                        //         ' -vf hue="H=2*PI*t: s=sin(2*PI*t)+1" ' +
                                        //         filePath +
                                        //         '-output.mp4');
                                        //     _controller = PackagageVideoPlayer
                                        //         .VideoPlayerController
                                        //         .file(
                                        //         File(filePath + '-output.mp4'))
                                        //       ..initialize().then((_) {
                                        //         setState(() {
                                        //           _controller.play();
                                        //           _controller.setLooping(true);
                                        //           print("FILTERED FILE SAVED " +
                                        //               filePath +
                                        //               '-output.mp4');
                                        //           previewPaths.add(filePath);
                                        //         });
                                        //       });
                                        //   },
                                        //   child: Text("Filter 3"),
                                        // ),

                                        GestureDetector(
                                          onTap: () {
                                            final uniqueID = uuid.v1();
                                            videoPathsBox.put(
                                                uniqueID, widget.path);
                                            print(
                                                "===================================");
                                            print("PATH added to HIVE");
                                            print(
                                                "===================================");

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        MainScreen()));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                16.0, 2.0, 4.0, 2.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 80.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                    ),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                        child: Center(
                                                          child: Text(
                                                            "/",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 44.0),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                Text(
                                                  "Normal",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final Directory extDir =
                                                await getTemporaryDirectory();
                                            final String dirPath =
                                                '${extDir.path}/ResumeBuilder/Filtered';
                                            await Directory(dirPath)
                                                .create(recursive: true);
                                            final String filePath =
                                                '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}';
                                            await fFmpeg
                                                .execute('-i ' +
                                                    widget.path +
                                                    // ' -vf hue=H=-7  ' +
                                                    ' -vf "hue=H=2*PI*t:s=sin(2*PI*t)+1, curves=cross_process" ' +
                                                    // ' -vf hue="H=2*PI*t: s=sin(2*PI*t)+1",eq=contrast=1.5,eq=brightness=0.3  ' +
                                                    filePath +
                                                    '-output.mp4')
                                                .catchError((e) => {

                                                  print("RHN: "+e)
                                            });
                                            _controller = PackagageVideoPlayer
                                                    .VideoPlayerController
                                                .file(File(
                                                    filePath + '-output.mp4'))
                                              ..initialize().then((_) {
                                                setState(() {
                                                  _controller.play();
                                                  _controller.setLooping(true);
                                                  print("FILTERED FILE SAVED " +
                                                      filePath +
                                                      '-output.mp4');
                                                  previewPaths.add(filePath);
                                                });
                                              });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 2.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 80.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      color: Colors.white,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      child: Opacity(
                                                        opacity: 0.6,
                                                        child: Image.network(
                                                          "https://sabe.io/classes/css/filters/hue-rotate.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Lumetric",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final Directory extDir =
                                                await getTemporaryDirectory();
                                            final String dirPath =
                                                '${extDir.path}/ResumeBuilder/Filtered';
                                            await Directory(dirPath)
                                                .create(recursive: true);
                                            final String filePath =
                                                '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}';
                                            await fFmpeg
                                                .execute('-i ' +
                                                    widget.path +
                                                    ' -vf hue=H=7  ' +
                                                    // ' -vf hue="H=2*PI*t: s=sin(2*PI*t)+1",eq=contrast=1.5,eq=brightness=0.3  ' +
                                                    filePath +
                                                    '-output.mp4')
                                                .catchError((e) => print(e));
                                            _controller = PackagageVideoPlayer
                                                    .VideoPlayerController
                                                .file(File(
                                                    filePath + '-output.mp4'))
                                              ..initialize().then((_) {
                                                setState(() {
                                                  _controller.play();
                                                  _controller.setLooping(true);
                                                  print("FILTERED FILE SAVED " +
                                                      filePath +
                                                      '-output.mp4');
                                                  previewPaths.add(filePath);
                                                });
                                              });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 2.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 80.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      color: Colors.white,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      child: Opacity(
                                                        opacity: 0.85,
                                                        child: Image.network(
                                                          "https://sabe.io/classes/css/filters/hue-rotate.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Sepia",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final Directory extDir =
                                                await getTemporaryDirectory();
                                            final String dirPath =
                                                '${extDir.path}/ResumeBuilder/Filtered';
                                            await Directory(dirPath)
                                                .create(recursive: true);
                                            final String filePath =
                                                '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}';
                                            await fFmpeg
                                                .execute('-i ' +
                                                    widget.path +
                                                    // ' -vf hue=H=-7  ' +
                                                    ' -vf hue="H=2*PI*t: s=sin(2*PI*t)+1" ' +
                                                    filePath +
                                                    '-output.mp4')
                                                .catchError((e) => print(e));
                                            _controller = PackagageVideoPlayer
                                                    .VideoPlayerController
                                                .file(File(
                                                    filePath + '-output.mp4'))
                                              ..initialize().then((_) {
                                                setState(() {
                                                  _controller.play();
                                                  _controller.setLooping(true);
                                                  print("FILTERED FILE SAVED " +
                                                      filePath +
                                                      '-output.mp4');
                                                  previewPaths.add(filePath);
                                                });
                                              });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 2.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 80.0,
                                                    width: 80.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      color: Colors.white,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      child: Opacity(
                                                        opacity: 1.0,
                                                        child: Image.network(
                                                          "https://sabe.io/classes/css/filters/hue-rotate.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Creama",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 2.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  height: 80.0,
                                                  width: 80.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    child: Opacity(
                                                      opacity: 0.56,
                                                      child: Image.network(
                                                        "https://sabe.io/classes/css/filters/hue-rotate.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Slumber",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 2.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  height: 80.0,
                                                  width: 80.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    child: Opacity(
                                                      opacity: 0.6,
                                                      child: Image.network(
                                                        "https://sabe.io/classes/css/filters/hue-rotate.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Space",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // RaisedButton(
                                  //   onPressed: () {
                                  //     final uniqueID = uuid.v1();
                                  //     videoPathsBox.put(uniqueID, widget.path);
                                  //     print(
                                  //         "===================================");
                                  //     print("PATH added to HIVE");
                                  //     print(
                                  //         "===================================");
                                  //
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (BuildContext context) =>
                                  //                 MainScreen()));
                                  //   },
                                  //   child: Text("Save without Filter"),
                                  // ),

                                  GestureDetector(
                                    onTap: () {
                                      if (previewPaths.isNotEmpty &&
                                          previewPaths != null) {
                                        int lastIndex = previewPaths.length - 1;
                                        saveToHive(previewPaths[lastIndex]);
                                      } else {
                                        final uniqueID = uuid.v1();
                                        videoPathsBox.put(
                                            uniqueID, widget.path);
                                        print(
                                            "===================================");
                                        print("PATH added to HIVE");
                                        print(
                                            "===================================");

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        MainScreen()));
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      margin: EdgeInsets.all(8.0),
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreenAccent,
                                        borderRadius:
                                            BorderRadius.circular(28.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(0.6, 0.2),
                                                  blurRadius: 1,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // RaisedButton(
                                  //   onPressed: () {
                                  //
                                  //   },
                                  //   child: Text("Save Current Filter"),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }

  saveToHive(String path) {
    final uniqueID = uuid.v1();
    videoPathsBox.put(uniqueID, path + '-output.mp4');
    print("===================================");
    print("PATH added to HIVE");
    print(previewPaths.length);
    print("===================================");

    deleteTempPreviews();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }

  deleteTempPreviews() {
    print("Delete Temp Preview Called " + previewPaths.length.toString());
    // [P1,P2]
    //Size 2
    if (previewPaths.length > 1) {
      for (int i = 0; i < (previewPaths.length - 2); i++) {
        File file = File(previewPaths[i]);
        file.delete();
        print("===================================");
        print("FILE DELETED " + i.toString() + "  " + previewPaths[i]);
        print("===================================");
      }
    }
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:hive/hive.dart';
// import 'package:resume_builder/screens/main_screen.dart';
// import 'package:uuid/uuid.dart';
//
// import 'package:path_provider/path_provider.dart';
// import 'package:video_player/video_player.dart' as PackagageVideoPlayer;
//
// class PlayRecordedVideo extends StatefulWidget {
//   final String path;
//
//   PlayRecordedVideo({@required this.path});
//
//   @override
//   _PlayRecordedVideoState createState() => _PlayRecordedVideoState();
// }
//
// class _PlayRecordedVideoState extends State<PlayRecordedVideo> {
//   FlutterFFmpeg fFmpeg;
//   Box<String> videoPathsBox;
//   PackagageVideoPlayer.VideoPlayerController _controller;
//   File fileInfo;
//   var uuid = Uuid();
//
//   //Final Video Path with Filters applied
//   String filteredPath;
//
//   // final spinkit = SpinKitChasingDots(
//   //   color: Colors.white,
//   //   size: 50.0,
//   // );
//   void getVideo() async {
//     fileInfo = File(widget.path);
//     _controller = PackagageVideoPlayer.VideoPlayerController.file(fileInfo)
//       ..initialize().then((_) {
//         setState(() {
//           _controller.play();
//           _controller.setLooping(true);
//         });
//       });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getVideo();
//     fFmpeg = new FlutterFFmpeg();
//     videoPathsBox = Hive.box<String>("videoPaths");
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,
//       child: _controller == null
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : _controller.value.initialized
//               ? GestureDetector(
//                   onTap: () {
//                     if (_controller.value.isPlaying) {
//                       _controller.pause();
//                     } else {
//                       _controller.play();
//                     }
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     child: Stack(
//                       children: [
//                         PackagageVideoPlayer.VideoPlayer(
//                           _controller,
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   children: [
//                                     RaisedButton(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       onPressed: () async {
//                                         final Directory extDir =
//                                             await getApplicationDocumentsDirectory();
//                                         final String dirPath =
//                                             '${extDir.path}/ResumeBuilder/Filtered';
//                                         await Directory(dirPath)
//                                             .create(recursive: true);
//                                         final String filePath =
//                                             '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}';
//                                         await fFmpeg.execute('-i ' +
//                                             widget.path +
//                                             ' -vf hue=s=2 ' +
//                                             filePath +
//                                             '-output.mp4');
//                                         _controller = PackagageVideoPlayer
//                                                 .VideoPlayerController
//                                             .file(
//                                                 File(filePath + '-output.mp4'))
//                                           ..initialize().then((_) {
//                                             setState(() {
//                                               _controller.play();
//                                               _controller.setLooping(true);
//                                               filteredPath = filePath;
//                                               print(
//                                                   "=============================================");
//                                               print("FILE PATH UPDATED 1");
//                                               print(
//                                                   "=============================================");
//                                             });
//                                           });
//                                       },
//                                       child: Text("Filter 1"),
//                                     ),
//                                     RaisedButton(
//                                       color: Colors.grey.withOpacity(1.0),
//                                       onPressed: () async {
//                                         final Directory extDir =
//                                             await getApplicationDocumentsDirectory();
//                                         final String dirPath =
//                                             '${extDir.path}/ResumeBuilder/Filtered';
//                                         await Directory(dirPath)
//                                             .create(recursive: true);
//                                         final String filePath =
//                                             '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}';
//                                         await fFmpeg.execute('-i ' +
//                                             widget.path +
//                                             ' -vf hue="H=2*PI*t: s=sin(2*PI*t)+1" ' +
//                                             filePath);
//                                         _controller = PackagageVideoPlayer
//                                                 .VideoPlayerController
//                                             .file(
//                                                 File(filePath + '-output.mp4'))
//                                           ..initialize().then((_) {
//                                             setState(() {
//                                               _controller.play();
//                                               _controller.setLooping(true);
//                                               filteredPath = filePath;
//
//                                             });
//                                           });
//                                         print(
//                                             "=============================================");
//                                         print("FILE PATH UPDATED 2");
//                                         print(
//                                             "=============================================");
//                                       },
//                                       child: Text("Filter 2"),
//                                     ),
//                                     RaisedButton(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       onPressed: () async {
//                                         final Directory extDir =
//                                             await getApplicationDocumentsDirectory();
//                                         final String dirPath =
//                                             '${extDir.path}/ResumeBuilder/Filtered';
//                                         await Directory(dirPath)
//                                             .create(recursive: true);
//                                         final String filePath =
//                                             '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}';
//                                         await fFmpeg.execute('-i ' +
//                                             widget.path +
//                                             ' -vf eq=contrast=1.5,eq=brightness=1.3 ' +
//                                             filePath +
//                                             '-output.mp4');
//                                         _controller = PackagageVideoPlayer
//                                                 .VideoPlayerController
//                                             .file(
//                                                 File(filePath + '-output.mp4'))
//                                           ..initialize().then((_) {
//                                             setState(() {
//                                               _controller.play();
//                                               _controller.setLooping(true);
//                                               filteredPath = filePath;
//                                               print(
//                                                   "=============================================");
//                                               print("FILE PATH UPDATED 3");
//                                               print(
//                                                   "=============================================");
//                                             });
//                                           });
//                                       },
//                                       child: Text("Filter 3"),
//                                     ),
//                                   ],
//                                 ),
//                                 RaisedButton.icon(
//                                   color: Colors.green.withOpacity(0.6),
//                                   onPressed: () {
//                                     if (filteredPath == null) {
//                                       print(
//                                           "=========================================");
//                                       print("FILTERED PATH FOUND EMPTY");
//                                       print(
//                                           "=========================================");
//                                       //No Filtered Applied---Save the original to Hive
//                                       setState(() {
//                                         filteredPath = widget.path;
//                                       });
//                                     }
//
//                                     print(
//                                         "FILTERED FILE SAVED " + filteredPath + '-output.mp4');
//                                     final uniqueID = uuid.v1();
//                                     videoPathsBox.put(uniqueID, filteredPath + '-output.mp4');
//                                     print(
//                                         "===================================");
//                                     print("PATH added to HIVE");
//                                     print(
//                                         "===================================");
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (BuildContext context) =>
//                                                 MainScreen()));
//                                   },
//                                   icon: Icon(
//                                     Icons.done,
//                                     color: Colors.black87,
//                                   ),
//                                   label: Text("SAVE"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : Center(
//                   child: CircularProgressIndicator(),
//                 ),
//     );
//   }
// }
