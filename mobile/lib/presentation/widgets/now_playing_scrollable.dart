import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/cubit/now_playing_scroll/now_playing_scroll_cubit.dart';

import 'SongLengthScrollController.dart';

class NowPlayingScrollable extends StatelessWidget {
  const NowPlayingScrollable({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    int itemCount = 585;
    return ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: ((BuildContext context, int index) {
        if (index < 600 * 0.065 || index > 600 * 0.91) {
          return Container(
            width: 5,
          );
        }
        if (index & 2 == 0)
          return Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            height: 30,
            width: 0.5,
            // child: Text('Item: '),
          );
        else
          return BlocBuilder<NowPlayingScrollCubit, NowPlayingScrollState>(
            builder: (context, state) {
              return Container(
                alignment: Alignment.center,
                color: _getColour(itemCount, index, state.songPercentage),
                height: 30,
                width: 1,
              );
            },
          );
      }),
    );
  }

  static bool areCurrentlyOver = false;

  static Color _getColour(int itemCount, int index, double percentage) {
    var isOver = percentage * itemCount > index;
    // if (isOver != areCurrentlyOver) {
    //   print("index: $index , itemCount as percentage: ${percentage * index} ,percentage: $percentage, isOver: $isOver");
    //   areCurrentlyOver = isOver;
    // }
    return isOver ? Colors.red : Colors.white;
  }
}
