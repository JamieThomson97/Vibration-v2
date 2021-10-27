import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vibration/bloc/audio_controller/audio_controller_bloc.dart';
import 'package:vibration/cubit/now_playing_scroll/now_playing_scroll_cubit.dart';
import 'package:vibration/presentation/widgets/marquee.dart';
import 'package:vibration/presentation/widgets/now_playing_scrollable.dart';

class NowPlayingPage extends StatelessWidget {
  const NowPlayingPage({Key? key}) : super(key: key);

  static ScrollController _scrollController = ScrollController();
  static ScrollController _panelScrollerController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.vertical,
      key: const Key('key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: SlidingUpPanel(
        minHeight: 0,
        panelBuilder: (sc) => _panel(sc, context),
        body: Material(
          child: SafeArea(
            child: Container(
              // padding: EdgeInsets.all(6),
              child: Stack(
                children: [
                  BlocBuilder<AudioControllerBloc, AudioControllerState>(
                    builder: (context, audioControllerState) {
                      return BlocProvider(
                        create: (context) => NowPlayingScrollCubit(
                          _scrollController,
                          audioControllerState.mix!,
                          context.read<AudioControllerBloc>(),
                        ),
                        child: BlocBuilder<NowPlayingScrollCubit, NowPlayingScrollState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: () {
                                context.read<AudioControllerBloc>().add(MixPlayPausedEvent());
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage("resources/Now_Playing_Screen/KaytranadaLive.jpeg"),
                                        alignment: Alignment(state.songPercentage.abs() * 0.4, 0),
                                      ),
                                    ),
                                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                                  ),
                                  TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                      begin: 0.0,
                                      end: audioControllerState.isPlaying ? 0 : 12.0,
                                    ),
                                    duration: const Duration(milliseconds: 250),
                                    builder: (_, value, child) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                                        child: child,
                                      );
                                    },
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Column(
                    children: [
                      SizedBox(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<AudioControllerBloc, AudioControllerState>(
                                builder: (context, state) {
                                  return Container(
                                    color: Colors.white,
                                    child: MarqueeWidget(
                                      direction: Axis.horizontal,
                                      text: Text(
                                        state.mix!.producer,
                                        style: Theme.of(context).textTheme.headline5,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              BlocBuilder<AudioControllerBloc, AudioControllerState>(
                                // todo: buildWhen
                                builder: (context, state) {
                                  return Container(
                                    color: Colors.white,
                                    child: MarqueeWidget(
                                      text: Text(
                                        state.mix!.event,
                                        style: Theme.of(context).textTheme.headline6,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              BlocBuilder<AudioControllerBloc, AudioControllerState>(
                                // todo: buildWhen
                                builder: (context, state) {
                                  return Container(
                                    color: Colors.white,
                                    child: MarqueeWidget(
                                      text: Text(
                                        DateFormat('yyyy-MM-dd').format(state.mix!.dateUploaded),
                                        style: Theme.of(context).textTheme.headline5,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        height: 340,
                      ),
                      BlocBuilder<AudioControllerBloc, AudioControllerState>(
                        buildWhen: (prev, current) => prev.isPlaying != current.isPlaying,
                        builder: (context, state) {
                          return Center(
                            child: AnimatedOpacity(
                              duration: new Duration(milliseconds: 300),
                              opacity: state.isPlaying ? 0 : 1,
                              child: InkWell(
                                child: Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.white,
                                  size: 100,
                                ),
                                onTap: () {
                                  context.read<AudioControllerBloc>().add(MixPlayPausedEvent());
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      BlocBuilder<AudioControllerBloc, AudioControllerState>(
                        buildWhen: (prev, current) {
                          return current.secondsIn == 0;
                        },
                        builder: (context, state) {
                          return BlocProvider(
                            create: (context) => NowPlayingScrollCubit(
                              _scrollController,
                              state.mix!,
                              context.read<AudioControllerBloc>(),
                            ),
                            child: BlocBuilder<NowPlayingScrollCubit, NowPlayingScrollState>(
                              builder: (context, state) {
                                return Container(
                                  color: Colors.white,
                                  child: Text(
                                    "${state.songPositionString} | ${state.songLengthString}",
                                    style: Theme.of(context).textTheme.headline5,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      BlocBuilder<AudioControllerBloc, AudioControllerState>(
                        // todo: this won't work
                        buildWhen: (prev, current) {
                          return current.secondsIn == 0;
                        },
                        builder: (context, state) {
                          return BlocProvider(
                            create: (context) => NowPlayingScrollCubit(
                              _scrollController,
                              state.mix!,
                              context.read<AudioControllerBloc>(),
                            ),
                            child: Container(
                              height: 100,
                              child: NowPlayingScrollable(
                                scrollController: _scrollController,
                                songLength: state.mix!.length,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NowPlayingPageIcon(
                              icon: Icons.favorite_border_rounded,
                              onPressed: () {},
                            ),
                            // todo : get better repost icon
                            NowPlayingPageIcon(
                              icon: Icons.sync_alt_outlined,
                              onPressed: () {},
                            ),
                            NowPlayingPageIcon(
                              icon: Icons.upcoming_rounded,
                              onPressed: () {},
                            ),
                            NowPlayingPageIcon(
                              icon: Icons.more_horiz_rounded,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel(ScrollController sc, BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration:
                      BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Explore Pittsburgh",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 36.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[],
            ),
            SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Images",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("About",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    """Pittsburgh is a city in the state of Pennsylvania in the United States, and is the county seat of Allegheny County. A population of about 302,407 (2018) residents live within the city limits, making it the 66th-largest city in the U.S. The metropolitan population of 2,324,743 is the largest in both the Ohio Valley and Appalachia, the second-largest in Pennsylvania (behind Philadelphia), and the 27th-largest in the U.S.\n\nPittsburgh is located in the southwest of the state, at the confluence of the Allegheny, Monongahela, and Ohio rivers. Pittsburgh is known both as "the Steel City" for its more than 300 steel-related businesses and as the "City of Bridges" for its 446 bridges. The city features 30 skyscrapers, two inclined railways, a pre-revolutionary fortification and the Point State Park at the confluence of the rivers. The city developed as a vital link of the Atlantic coast and Midwest, as the mineral-rich Allegheny Mountains made the area coveted by the French and British empires, Virginians, Whiskey Rebels, and Civil War raiders.\n\nAside from steel, Pittsburgh has led in manufacturing of aluminum, glass, shipbuilding, petroleum, foods, sports, transportation, computing, autos, and electronics. For part of the 20th century, Pittsburgh was behind only New York City and Chicago in corporate headquarters employment; it had the most U.S. stockholders per capita. Deindustrialization in the 1970s and 80s laid off area blue-collar workers as steel and other heavy industries declined, and thousands of downtown white-collar workers also lost jobs when several Pittsburgh-based companies moved out. The population dropped from a peak of 675,000 in 1950 to 370,000 in 1990. However, this rich industrial history left the area with renowned museums, medical centers, parks, research centers, and a diverse cultural district.\n\nAfter the deindustrialization of the mid-20th century, Pittsburgh has transformed into a hub for the health care, education, and technology industries. Pittsburgh is a leader in the health care sector as the home to large medical providers such as University of Pittsburgh Medical Center (UPMC). The area is home to 68 colleges and universities, including research and development leaders Carnegie Mellon University and the University of Pittsburgh. Google, Apple Inc., Bosch, Facebook, Uber, Nokia, Autodesk, Amazon, Microsoft and IBM are among 1,600 technology firms gene7 billion in annual Pittsburgh payrolls. The area has served as the long-time federal agency headquarters for cyber defense, software engineering, robotics, energy research and the nuclear navy. The nation's eighth-largest bank, eight Fortune 500 companies, and six of the top 300 U.S. law firms make their global headquarters in the area, while RAND Corporation (RAND), BNY Mellon, Nova, FedEx, Bayer, and the National Institute for Occupational Safety and Health (NIOSH) have regional bases that helped Pittsburgh become the sixth-best area for U.S. job growth.
                    """,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ));
  }
}

class NowPlayingPageIcon extends StatelessWidget {
  const NowPlayingPageIcon({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
      ),
      iconSize: 30,
      color: Colors.white,
    );
  }
}
