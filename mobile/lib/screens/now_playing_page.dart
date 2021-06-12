import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/widgets/now_playing_scrollable.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("resources/Now_Playing_Screen/KaytranadaLive.jpeg"),
        ),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Column(
        children: [
          SizedBox(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    child: Text(
                      "Kaytranada",
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: Text(
                      "Pitchfork 2018 - Paris",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            height: 300,
          ),
          SizedBox(
            height: 300,
          ),
          Container(
              height: 50,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification) {
                    _onStartScroll(scrollNotification.metrics);
                  } else if (scrollNotification is ScrollUpdateNotification) {
                    _onUpdateScroll(scrollNotification.metrics);
                  } else if (scrollNotification is ScrollEndNotification) {
                    _onEndScroll(scrollNotification.metrics);
                  }
                  return true;
                },
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 600,
                  itemBuilder: ((BuildContext context, int index) {
                    if (index < 42 || index > 600 - 42) {
                      return Container(
                        width: 5,
                      );
                    }
                    if (index & 2 == 0)
                      return Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        height: 30,
                        width: 1,
                        // child: Text('Item: $index'),
                      );
                    else
                      return NowPlayingScrollable();
                  }),
                ),
              )),
        ],
      ),
    );
  }

  _onStartScroll(ScrollMetrics metrics) {
    print("Scroll Start");
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    // if there is 0 before, haven't moved.
    // The position in the track is directly related to the extentBefore
    // Need to use the extent after to work out when at the end.
    // print("Scroll Update");
    int songLength = 300;
    int maxPixels = 542;
    // print(metrics.pixels);
    var percentage = metrics.pixels / maxPixels;
    var seconds = (songLength * percentage).round();
    if (seconds > songLength) seconds = songLength;
    int minutes = (seconds / 60).truncate();
    var remainingSeconds = seconds - (minutes * 60);

    // maybe use the pixels metric.
    // print(metrics.pixels);
    print("$minutes:$remainingSeconds");
  }

  _onEndScroll(ScrollMetrics metrics) {
    print("Scroll End");
  }
}