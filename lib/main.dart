import 'package:distractfreeyt/bookmark.dart';
import 'package:distractfreeyt/playvideo.dart';
import 'package:distractfreeyt/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_video_info/youtube.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.blue, // navigation bar color
  //   statusBarColor: Colors.pink, // status bar color
  // ));
  await Bookmarklink.init();
  runApp(MyApp());
}

List<String> bookmarklinks = [];

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

  Future<void> callAPI() async {
    videoResult = await youtube.search(
      search,
      order: 'relevance',
      videoDuration: 'any',
    );
    //
    setState(() {});
  }

  var link;

  YoutubeDataModel? videoData;
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 3; i++) {
      print("dsds");
    }
    link = Bookmarklink.getdata() ?? [];
    callAPI();
    print('done');
  }

  Future<Object> getvideodata(videoitem) async {
    setState(() {});
    // return ("date bora bora");
    return videoData = await YoutubeData.getData(videoitem);
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
                                      videoResult = (await youtube.prevPage())!;
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
                                    spreadRadius: -3,
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
                              width: 270,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white)),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  search = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "search your topics here",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding:
                                        EdgeInsets.only(top: 5, left: 10),
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
                ListView(
                  children: [
                    //                   ...testitems.map((testitems){i + = 1; return Text(${testitems)})
                    // print(testitems[0]['a']);

                    ...link!.map<Widget>((item) {
                      // print('list runiingh');
                      getvideodata(item);
                      // setState(() {});
                      // return Text("${videoData!.authorName}");
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 7.0),
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Image.network(
                                videoData?.thumbnailUrl ?? '',
                                width: 120.0,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${videoData?.title}",
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color:
                                            Color.fromARGB(223, 255, 253, 253)),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text(
                                      "${videoData?.authorName}",
                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                    child: Text(
                                      "${videoData?.description}",
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })
                  ],
                )
              ])),
        ),
      ),
    );
  }
}
