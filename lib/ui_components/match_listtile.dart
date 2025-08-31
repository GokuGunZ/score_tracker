import 'package:flutter/material.dart';
import 'package:score_tracker/models/game.dart';
import 'package:score_tracker/screens/game_detail_screen.dart';
import 'package:intl/intl.dart';

class MatchListtile extends StatefulWidget {
  final Game match;
  const MatchListtile({super.key, required this.match});

  @override
  State<MatchListtile> createState() => _MatchListtileState();
}

class _MatchListtileState extends State<MatchListtile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Partita del ${DateFormat('dd MMM yyyy – HH:mm').format(widget.match.playedAt)}",
      ),
      subtitle: Text(
        "Giocatori: ${widget.match.scores.length}   |  Tornei: ${widget.match.tournamentIds.length}",
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetailScreen(game: widget.match),
          ),
        );
      },
    );
  }
}
