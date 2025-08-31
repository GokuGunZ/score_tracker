import 'package:flutter/material.dart';
import 'package:score_tracker/utils/constants.dart';

class GameTrackerAppbar extends StatelessWidget {
  const GameTrackerAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(50, 30),
          bottomRight: Radius.elliptical(50, 30),
        ),
        child: Container(
          color: gtAppbarColor,
          height: 20,
          child: Center(
            child: Text(
              'game tracker',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 4,
                wordSpacing: 23,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
