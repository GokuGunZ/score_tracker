import 'package:flutter/material.dart';
import 'match_listtile.dart';
import 'package:score_tracker/models/game.dart';
import 'dart:math';

class ExpandableTileList extends StatefulWidget {
  final List<Object> listContent;
  const ExpandableTileList({super.key, required this.listContent});

  @override
  State<ExpandableTileList> createState() => _ExpandableTileListState();
}

class _ExpandableTileListState extends State<ExpandableTileList>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  final int minCount = 4;
  final int maxCount = 10;

  @override
  Widget build(BuildContext context) {
    final itemCount = expanded ? maxCount : minCount;

    return Column(
      children: [
        // lista animata
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            children: List.generate(
              min(itemCount, widget.listContent.length),
              (index) => MatchListtile(
                    match: widget.listContent[index] as Game
                  ),
            ),
          ),
        ),

        // bottone toggle
        GestureDetector(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 35, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0.0, // 0.5 giri = 180°
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.keyboard_arrow_down, size: 32),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}