import 'package:flutter/material.dart';
import 'expandable_tile_list.dart';

class ExpandableTileListStyled extends StatefulWidget {
  final String title;
  final List<Object> listContent;
  const ExpandableTileListStyled({super.key, required this.title, required this.listContent});

  @override
  State<ExpandableTileListStyled> createState() => _ExpandableTileListStyledState();
}

class _ExpandableTileListStyledState extends State<ExpandableTileListStyled> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 25),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Divider(height: 1, indent: 20, endIndent: 350 , thickness: 1.8, color: const Color.fromARGB(165, 165, 232, 203),),
                      ExpandableTileList(listContent: widget.listContent),
                    ],
                  ),
                );
  }
}