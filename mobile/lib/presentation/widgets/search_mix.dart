import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:vibration/bloc/audio_controller/audio_controller_bloc.dart';
import 'package:vibration/model/mix.dart';

import '../../theme.dart';

class SearchMix extends StatelessWidget {
  const SearchMix(this.mix) : super();

  final Mix mix;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Ink(
              decoration: BoxDecoration(
                boxShadow: [
                  CustomBoxShadow(
                    color: Colors.grey.withOpacity(1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0), // changes position of shadow
                    //  blurStyle: BlurStyle.outer,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: InkWell(
                child: Image(
                  height: 145,
                  width: 145,
                  fit: BoxFit.cover,
                  image: AssetImage(mix.imageUrl),
                ),
                onTap: () {
                  context.read<AudioControllerBloc>().add(MixStartedEvent(mix));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mix.name,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    mix.producer,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}