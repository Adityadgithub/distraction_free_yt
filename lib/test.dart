import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:youtube_video_info/youtube.dart';

class Savedvideo extends StatefulWidget {
  const Savedvideo({Key? key}) : super(key: key);

  @override
  State<Savedvideo> createState() => _SavedvideoState();
}

class _SavedvideoState extends State<Savedvideo> {
  YoutubeDataModel? videoData;
  Future<YoutubeDataModel> getvideodata(videoitem) async {
    setState(() {});
    return videoData = await YoutubeData.getData(videoitem);
  }

  @override
  Widget build(BuildContext context) {
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
                      color: Color.fromARGB(223, 255, 253, 253)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0),
                  child: Text(
                    "${videoData?.authorName}",
                    softWrap: true,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
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
  }
}
