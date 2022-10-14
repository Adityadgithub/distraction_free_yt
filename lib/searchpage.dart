import 'package:distractfreeyt/main.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_data_api/models/video_data.dart';
import 'package:youtube_data_api/youtube_data_api.dart';
import 'package:youtube_video_info/youtube.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(115, 66, 66, 66),
      body: progress == false
          ? ListView(
              children: videoResult.map<Widget>(listItem).toList(),
            )
          : Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return Container(
      width: MediaQuery.of(context).size.width - 200,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white70))),
      child: TextButton(
        onPressed: () async {
          playurl = video.url;
          videotitle = video.title;
          channelname = video.channelTitle;
          Navigator.pushReplacementNamed(context, "PlayVideo");

          var videoData = await YoutubeData.getData(playurl!);
          videodesc = videoData.fullDescription;
          // videodesc = "dd";
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7.0),
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.network(
                  video.thumbnail.small.url ?? '',
                  width: 120.0,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      video.title,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 13.0,
                          color: Color.fromARGB(223, 255, 253, 253)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        video.channelTitle,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                      child: Text(
                        "${video.description}",
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
        ),
      ),
    );
  }
}
