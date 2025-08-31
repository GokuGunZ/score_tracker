import 'package:flutter/material.dart';
import 'package:score_tracker/models/game.dart';
import 'package:score_tracker/models/player.dart';
import 'package:score_tracker/services/game_repository.dart';
import 'package:score_tracker/services/player_repository.dart';

class EditGameScreen extends StatefulWidget {
  final String gameId;
  const EditGameScreen({Key? key, required this.gameId}) : super(key: key);

  @override
  State<EditGameScreen> createState() => _EditGameScreenState();
}

class _EditGameScreenState extends State<EditGameScreen> {
  final _gameRepo = GameRepository();
  final _playerRepo = PlayerRepository();

  Game? _game;
  Map<String, Player> _players = {};
  Map<String, int> _scores = {};
  String? _winnerId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final game = await _gameRepo.getGameById(widget.gameId);

    // Recupero info giocatori
    final ids = game.scores.map((s) => s.playerId).toList();
    final playersList = await _playerRepo.getPlayersByIds(ids);

    setState(() {
      _game = game;
      _players = {for (var p in playersList) p.id: p};
      _scores = {
        for (var s in game.scores) s.playerId: s.score
      };
      _winnerId = game.winnerId;
      if (_winnerId != null) {
        _scores[_winnerId!] = _scores[_winnerId]! - 20;
      }
      _loading = false;
    });
  }

  Future<void> _saveChanges() async {
    if (_winnerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleziona un vincitore')),
      );
      return;
    }

    final updatedGame = _game!.copyWith(
      scores: _scores.entries
          .map((e) {
            final score;
            if (e.key == _winnerId) {
              score = e.value + 20;
            } else {
              score = e.value;
            }
            return PlayerScore(playerId: e.key, score: score);
            })
          .toList(),
      winnerId: _winnerId,
    );

    await _gameRepo.updateGame(widget.gameId, updatedGame);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Modifica partita')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Modifica partita')),
      body: ListView(
        children: [
          ..._scores.entries.map((entry) {
            final player = _players[entry.key]!;
            return ListTile(
              title: Text(player.name),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: (entry.value.toString()),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Punti'),
                      onChanged: (val) {
                        final parsed = int.tryParse(val) ?? 0;
                        setState(() {
                          _scores[entry.key] = parsed;
                        });
                      },
                    ),
                  ),
                  Radio<String>(
                    value: player.id,
                    groupValue: _winnerId,
                    onChanged: (val) {
                      setState(() {
                        _winnerId = val;
                      });
                    },
                  )
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Salva modifiche'),
            ),
          )
        ],
      ),
    );
  }
}