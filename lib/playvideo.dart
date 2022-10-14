import 'package:distractfreeyt/bookmark.dart';
import 'package:distractfreeyt/main.dart';
import 'package:flutter/services.dart';
import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlayVideo extends StatefulWidget {
  const PlayVideo({Key? key}) : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  List<String> bookmarklinks = [];
  late final PodPlayerController controller;
  bool drop = false;

  bool copied = false;

  bool saved = false;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube('$playurl'),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, "MyApp");
        saved = false;
        return null!;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  bookmarklinks = Bookmarklink.getdata() ?? [];
                  bookmarklinks.add(playurl);
                  await Bookmarklink.save(bookmarklinks) ?? [];
                  setState(() {
                    saved = true;
                  });
                  print("link saved");
                },
                icon: saved == false
                    ? Icon(Icons.bookmark_add_outlined)
                    : Icon(Icons.bookmark_added_rounded)),
            IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {
                  copied = false;
                  showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              title: Text("Copy the link to share"),
                              content: Container(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: 200,
                                      child: SelectableText(
                                        playurl!,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        FlutterClipboard.copy(playurl!);

                                        setState(() {
                                          copied = true;
                                        });
                                      },
                                      icon: copied == true
                                          ? Icon(
                                              Icons.done_rounded,
                                              size: 35,
                                              color: Colors.green,
                                            )
                                          : Icon(Icons.copy))
                                ],
                              )),
                            ),
                          ));
                }),
          ],
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(255, 199, 34, 47)),
          backgroundColor: Color.fromARGB(255, 255, 48, 65),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              saved = false;

              setState(() {});
              Navigator.pushNamed(context, "MyApp");
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PodVideoPlayer(controller: controller),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(38, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              if (drop == false) {
                                setState(() {});
                                drop = true;
                              } else {
                                setState(() {});
                                drop = false;
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.77,
                                  child: SelectableText(
                                    "${videotitle}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                                if (drop == false)
                                  Icon(Icons.arrow_drop_down_sharp),
                                if (drop == true)
                                  Icon(Icons.arrow_drop_up_outlined),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SelectableText("by - ${channelname}"),
                          if (drop == true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Description: ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SelectableText("${videodesc}"),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (drop == false)
                Padding(
                  padding: const EdgeInsets.only(top: 125),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View in fullscreen",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.fullscreen,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      SizedBox(height: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "for better focus!",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          SizedBox(
                            width: 15,
                          )
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

// import 'dart:developer';

// import 'package:distractfreeyt/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// // import 'video_list.dart';

// /// Creates [YoutubePlayerDemoApp] widget.

// /// Homepage
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late YoutubePlayerController _controller;
//   late TextEditingController _idController;
//   late TextEditingController _seekToController;

//   late PlayerState _playerState;
//   late YoutubeMetaData _videoMetaData;
//   double _volume = 100;
//   bool _muted = false;
//   bool _isPlayerReady = false;

//   // final List<String> _ids = ['$playurl'];

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: playurl!,
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: false,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: true,
//       ),
//     )..addListener(listener);
//     _idController = TextEditingController();
//     _seekToController = TextEditingController();
//     _videoMetaData = const YoutubeMetaData();
//     _playerState = PlayerState.unknown;
//   }

//   void listener() {
//     if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller.value.playerState;
//         _videoMetaData = _controller.metadata;
//       });
//     }
//   }

//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     _controller.pause();
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _idController.dispose();
//     _seekToController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       onExitFullScreen: () {
//         // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
//         SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//       },
//       player: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: Colors.blueAccent,
//         topActions: <Widget>[
//           const SizedBox(width: 8.0),
//           Expanded(
//             child: Text(
//               _controller.metadata.title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.settings,
//               color: Colors.white,
//               size: 25.0,
//             ),
//             onPressed: () {
//               log('Settings Tapped!');
//             },
//           ),
//         ],
//         onReady: () {
//           _isPlayerReady = true;
//         },
//         onEnded: (data) {
//           // _controller
//           //     .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
//           // _showSnackBar('Next Video Started!');
//         },
//       ),
//       builder: (context, player) => Scaffold(
//         appBar: AppBar(
//           leading: Padding(
//             padding: const EdgeInsets.only(left: 12.0),
//             child: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () {
//                 // Navigator.pushNamed(context, "MyApp");
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           title: const Text(
//             'Youtube Player Flutter',
//             style: TextStyle(color: Colors.white),
//           ),
//           actions: [],
//         ),
//         body: ListView(
//           children: [
//             player,

//             // Padding(
//             //   padding: const EdgeInsets.all(8.0),
//             //   child: Column(
//             //     crossAxisAlignment: CrossAxisAlignment.stretch,
//             //     children: [
//             //       _space,
//             //       _text('Title', _videoMetaData.title),
//             //       _space,
//             //       _text('Channel', _videoMetaData.author),
//             //       _space,
//             //       _text('Video Id', _videoMetaData.videoId),
//             //       _space,
//             //       Row(
//             //         children: [
//             //           _text(
//             //             'Playback Quality',
//             //             _controller.value.playbackQuality ?? '',
//             //           ),
//             //           const Spacer(),
//             //           _text(
//             //             'Playback Rate',
//             //             '${_controller.value.playbackRate}x  ',
//             //           ),
//             //         ],
//             //       ),
//             //       _space,
//             //       TextField(
//             //         enabled: _isPlayerReady,
//             //         controller: _idController,
//             //         decoration: InputDecoration(
//             //           border: InputBorder.none,
//             //           hintText: 'Enter youtube \<video id\> or \<link\>',
//             //           fillColor: Colors.blueAccent.withAlpha(20),
//             //           filled: true,
//             //           hintStyle: const TextStyle(
//             //             fontWeight: FontWeight.w300,
//             //             color: Colors.blueAccent,
//             //           ),
//             //           suffixIcon: IconButton(
//             //             icon: const Icon(Icons.clear),
//             //             onPressed: () => _idController.clear(),
//             //           ),
//             //         ),
//             //       ),
//             //       _space,
//             //       Row(
//             //         children: [
//             //           _loadCueButton('LOAD'),
//             //           const SizedBox(width: 10.0),
//             //           _loadCueButton('CUE'),
//             //         ],
//             //       ),
//             //       _space,
//             //       Row(
//             //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             //         children: [
//             //           IconButton(
//             //             icon: const Icon(Icons.skip_previous),
//             //             onPressed: _isPlayerReady
//             //                 ? () => _controller.load(_ids[
//             //                     (_ids.indexOf(_controller.metadata.videoId) -
//             //                             1) %
//             //                         _ids.length])
//             //                 : null,
//             //           ),
//             //           IconButton(
//             //             icon: Icon(
//             //               _controller.value.isPlaying
//             //                   ? Icons.pause
//             //                   : Icons.play_arrow,
//             //             ),
//             //             onPressed: _isPlayerReady
//             //                 ? () {
//             //                     _controller.value.isPlaying
//             //                         ? _controller.pause()
//             //                         : _controller.play();
//             //                     setState(() {});
//             //                   }
//             //                 : null,
//             //           ),
//             //           IconButton(
//             //             icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
//             //             onPressed: _isPlayerReady
//             //                 ? () {
//             //                     _muted
//             //                         ? _controller.unMute()
//             //                         : _controller.mute();
//             //                     setState(() {
//             //                       _muted = !_muted;
//             //                     });
//             //                   }
//             //                 : null,
//             //           ),
//             //           FullScreenButton(
//             //             controller: _controller,
//             //             color: Colors.blueAccent,
//             //           ),
//             //           IconButton(
//             //             icon: const Icon(Icons.skip_next),
//             //             onPressed: _isPlayerReady
//             //                 ? () => _controller.load(_ids[
//             //                     (_ids.indexOf(_controller.metadata.videoId) +
//             //                             1) %
//             //                         _ids.length])
//             //                 : null,
//             //           ),
//             //         ],
//             //       ),
//             //       _space,
//             //       Row(
//             //         children: <Widget>[
//             //           const Text(
//             //             "Volume",
//             //             style: TextStyle(fontWeight: FontWeight.w300),
//             //           ),
//             //           Expanded(
//             //             child: Slider(
//             //               inactiveColor: Colors.transparent,
//             //               value: _volume,
//             //               min: 0.0,
//             //               max: 100.0,
//             //               divisions: 10,
//             //               label: '${(_volume).round()}',
//             //               onChanged: _isPlayerReady
//             //                   ? (value) {
//             //                       setState(() {
//             //                         _volume = value;
//             //                       });
//             //                       _controller.setVolume(_volume.round());
//             //                     }
//             //                   : null,
//             //             ),
//             //           ),
//             //         ],
//             //       ),
//             //       _space,
//             //       AnimatedContainer(
//             //         duration: const Duration(milliseconds: 800),
//             //         decoration: BoxDecoration(
//             //           borderRadius: BorderRadius.circular(20.0),
//             //           color: _getStateColor(_playerState),
//             //         ),
//             //         padding: const EdgeInsets.all(8.0),
//             //         child: Text(
//             //           _playerState.toString(),
//             //           style: const TextStyle(
//             //             fontWeight: FontWeight.w300,
//             //             color: Colors.white,
//             //           ),
//             //           textAlign: TextAlign.center,
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _text(String title, String value) {
//     return RichText(
//       text: TextSpan(
//         text: '$title : ',
//         style: const TextStyle(
//           color: Colors.blueAccent,
//           fontWeight: FontWeight.bold,
//         ),
//         children: [
//           TextSpan(
//             text: value,
//             style: const TextStyle(
//               color: Colors.blueAccent,
//               fontWeight: FontWeight.w300,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStateColor(PlayerState state) {
//     switch (state) {
//       case PlayerState.unknown:
//         return Colors.grey[700]!;
//       case PlayerState.unStarted:
//         return Colors.pink;
//       case PlayerState.ended:
//         return Colors.red;
//       case PlayerState.playing:
//         return Colors.blueAccent;
//       case PlayerState.paused:
//         return Colors.orange;
//       case PlayerState.buffering:
//         return Colors.yellow;
//       case PlayerState.cued:
//         return Colors.blue[900]!;
//       default:
//         return Colors.blue;
//     }
//   }

//   Widget get _space => const SizedBox(height: 10);

//   Widget _loadCueButton(String action) {
//     return Expanded(
//       child: MaterialButton(
//         color: Colors.blueAccent,
//         onPressed: _isPlayerReady
//             ? () {
//                 if (_idController.text.isNotEmpty) {
//                   var id = YoutubePlayer.convertUrlToId(
//                         _idController.text,
//                       ) ??
//                       '';
//                   if (action == 'LOAD') _controller.load(id);
//                   if (action == 'CUE') _controller.cue(id);
//                   FocusScope.of(context).requestFocus(FocusNode());
//                 } else {
//                   _showSnackBar('Source can\'t be empty!');
//                 }
//               }
//             : null,
//         disabledColor: Colors.grey,
//         disabledTextColor: Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 14.0),
//           child: Text(
//             action,
//             style: const TextStyle(
//               fontSize: 18.0,
//               color: Colors.white,
//               fontWeight: FontWeight.w300,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontWeight: FontWeight.w300,
//             fontSize: 16.0,
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//         behavior: SnackBarBehavior.floating,
//         elevation: 1.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50.0),
//         ),
//       ),
//     );
//   }
// }
