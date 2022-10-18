import 'dart:async';

import 'package:distractfreeyt/bookmark.dart';
import 'package:distractfreeyt/playvideo.dart';
import 'package:distractfreeyt/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_video_info/youtube.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.blue, // navigation bar color
  //   statusBarColor: Colors.pink, // status bar color
  // ));
  await Bookmarklink.init();
  runApp(MyApp());
}

// List<String> bookmarklinks = [];
List<String> link = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "MyApp": (context) => MyApp(),
        "PlayVideo": (context) => PlayVideo(),
        "SearchPage": (context) => SearchPage()
      },
      home: DemoApp(),
    );
  }
}

List<YouTubeVideo> videoResult = [];
var playurl;
var videotitle;
var channelname;
var videodesc;

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

bool? progress = false;
var search;
var pressed = false;

var index = 0;

class _DemoAppState extends State<DemoApp> {
  static String key = "AIzaSyBTglUmF94tWmU292ydDVb03ZrwX38XiYU";

  YoutubeAPI youtube = YoutubeAPI(key);

  List title = [];
  List thumbnail = [];
  List authorname = [];
  List desc = [];

  bool dataloaded = false;

  Future<void> callAPI() async {
    videoResult = await youtube.search(
      search,
      order: 'relevance',
      videoDuration: 'any',
    );
    //
    setState(() {});
  }

  late Timer _timer;
  YoutubeDataModel? videoData;
  @override
  void initState() {
    super.initState();
    // _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
    //   setState(() {});
    // });
    link = Bookmarklink.getdata() ?? [];
    link!.forEach((element) {
      print("hety");
      getvideodata(element);
    });

    setState(() {});
    callAPI();
    print('done');
  }

  void getvideodata(videoitem) async {
    setState(() {});
    // return ("date bora bora");
    videoData = await YoutubeData.getData(videoitem);
    thumbnail.add(videoData!.thumbnailUrl);
    title.add(videoData!.title);
    authorname.add(videoData!.authorName);
    desc.add(videoData!.fullDescription);
    dataloaded = true;
    setState(() {});
  }

  Future<void> remove(
      {playurl,
      titlename,
      thumbnailimg,
      authornameelement,
      descelement}) async {
    for (var l in link) {
      if (l == playurl) {
        print('''
FOUND the link
value of playurl = $playurl
link listt = $link''');
        link.remove(playurl);

        await Bookmarklink.save(link) ?? [];
        for (var t in title) {
          if (t == titlename) {
            title.remove(titlename);
          }

          setState(() {});
          print('''
FOUND the title
value of titlename = $titlename
title listt = $title''');

// thumbnail
// authorname
// desc
        }
        for (var t in thumbnail) {
          if (t == thumbnailimg) {
            thumbnail.remove(thumbnailimg);
          }

          setState(() {});
        }
        for (var a in authorname) {
          if (a == authornameelement) {
            authorname.remove(authornameelement);
          }

          setState(() {});
        }
        for (var d in desc) {
          if (d == descelement) {
            desc.remove(descelement);
          }

          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            setState(() {
              pressed = false;
              index = 0;
            });
            return null!;
          },
          child: Scaffold(
              floatingActionButtonLocation: index == 0
                  ? FloatingActionButtonLocation.endFloat
                  : FloatingActionButtonLocation.centerFloat,
              floatingActionButton: pressed == true
                  ? index == 0
                      ? FloatingActionButton(
                          backgroundColor: Color.fromARGB(255, 255, 48, 65),
                          onPressed: () async {
                            progress = true;
                            setState(() {});
                            videoResult = await youtube.nextPage();
                            index += 1;
                            setState(() {});
                            progress = false;
                            setState(() {});
                          },
                          child: Icon(
                            Icons.keyboard_double_arrow_right_outlined,
                            size: 30,
                          ))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (index > 0)
                                FloatingActionButton(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 48, 65),
                                    onPressed: () async {
                                      progress = true;
                                      setState(() {});
                                      if (index == 1) {
                                        await callAPI();
                                      } else {
                                        videoResult =
                                            (await youtube.prevPage())!;
                                      }
                                      index -= 1;
                                      setState(() {});
                                      progress = false;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.keyboard_double_arrow_left_outlined,
                                      size: 30,
                                    )),
                              FloatingActionButton(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 48, 65),
                                  onPressed: () async {
                                    progress = true;
                                    setState(() {});
                                    videoResult = await youtube.nextPage();
                                    index += 1;
                                    setState(() {});
                                    progress = false;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.keyboard_double_arrow_right_outlined,
                                    size: 30,
                                  )),
                            ],
                          ),
                        )
                  : SizedBox(),
              backgroundColor: Color.fromARGB(115, 66, 66, 66),
              appBar: pressed == true
                  ? AppBar(
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: Color.fromARGB(255, 199, 34, 47)),
                      backgroundColor: Color.fromARGB(255, 255, 48, 65),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            pressed = false;
                            index = 0;
                          });
                        },
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: TextFormField(
                          onFieldSubmitted: (value) async {
                            progress = true;
                            setState(() {});
                            await callAPI();
                            setState(() {});
                            progress = false;
                            index = 0;
                            setState(() {});
                          },
                          initialValue: search,
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) {
                            search = value;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 17),
                              alignLabelWithHint: true,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  progress = true;
                                  setState(() {});
                                  await callAPI();
                                  setState(() {});
                                  progress = false;
                                  index = 0;
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ),
                    )
                  : AppBar(
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: Color.fromARGB(255, 199, 34, 47)),
                      backgroundColor: Color.fromARGB(255, 255, 48, 65),
                      title: Text(
                        "Distraction Free Youtube",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      centerTitle: true,
                      toolbarHeight: 80,
                      bottom: TabBar(
                        tabs: [
                          Tab(
                              child: Column(
                            children: [Icon(Icons.search), Text("Search")],
                          )),
                          Tab(
                              child: Column(
                            children: [
                              Icon(Icons.bookmark_border),
                              Text("Saved"),
                            ],
                          ))
                        ],
                      )),
              body: TabBarView(children: [
                pressed == true
                    ? SearchPage()
                    : Padding(
                        padding: const EdgeInsets.only(top: 95.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 255, 48, 65),
                                    blurRadius: 6.0,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 0,
                                      color: Colors.transparent,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage("assets/logo.png"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 45),
                            Text(
                              'Search - Watch - Study',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'No Recommended videos and No ADs',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white,
                                  )),
                              child: TextFormField(
                                onFieldSubmitted: (value) async {
                                  pressed = true;
                                  progress = true;
                                  setState(() {});
                                  await callAPI();
                                  progress = false;
                                  index = 0;
                                  setState(() {});
                                },
                                // textInputAction: TextInputAction.search,
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  search = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "search your topics here",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    focusedBorder: InputBorder.none,
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        pressed = true;
                                        progress = true;
                                        setState(() {});
                                        await callAPI();
                                        progress = false;
                                        index = 0;
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                link.isEmpty
                    ? Center(
                        child: Text(
                        'No Saved',
                        style: TextStyle(color: Colors.grey),
                      ))
                    : Column(
                        mainAxisAlignment: dataloaded == true
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          dataloaded == true
                              ? Expanded(
                                  child: ListView(
                                    children: [
                                      //                   ...testitems.map((testitems){i + = 1; return Text(${testitems)})
                                      // print(testitems[0]['a']);

                                      ...title.map<Widget>((item) {
                                        // print('list runiingh');

                                        // getvideodata(item);
                                        // setState(() {});
                                        // return Text("${videoData!.authorName}");
                                        var index = title.indexOf(item);
                                        print("link listt = $link");

                                        return InkWell(
                                          onTap: () {
                                            playurl = link[index];
                                            videotitle = title[index];
                                            channelname = authorname[index];
                                            videodesc = desc[index];
                                            Navigator.pushReplacementNamed(
                                                context, "PlayVideo");
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 7.0),
                                            padding: EdgeInsets.all(12.0),
                                            child: Slidable(
                                              endActionPane: ActionPane(
                                                  motion: BehindMotion(),
                                                  children: [
                                                    SlidableAction(
                                                      // An action can be bigger than the others.
                                                      flex: 2,
                                                      onPressed: (value) {
                                                        remove(
                                                            playurl:
                                                                link![index],
                                                            titlename:
                                                                title[index],
                                                            authornameelement:
                                                                authorname[
                                                                    index],
                                                            descelement:
                                                                desc[index],
                                                            thumbnailimg:
                                                                thumbnail[
                                                                    index]);
                                                        setState(() {});
                                                      },
                                                      backgroundColor:
                                                          Color(0xFFFE4A49),
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.delete,
                                                      label: 'Delete',
                                                    ),
                                                  ]),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20.0),
                                                    child: Image.network(
                                                      thumbnail[index] ?? '',
                                                      width: 120.0,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "${title[index]}",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 13.0,
                                                              color: Color
                                                                  .fromARGB(
                                                                      223,
                                                                      255,
                                                                      253,
                                                                      253)),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      3.0),
                                                          child: Text(
                                                            "${authorname[index]}",
                                                            softWrap: true,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                          child: Text(
                                                            "${desc[index]}",
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                        ],
                      )
              ])),
        ),
      ),
    );
  }
}
