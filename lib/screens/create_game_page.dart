import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/game.dart';
import '../models/tournament.dart';
import '../services/player_repository.dart';
import '../services/game_repository.dart';
import '../services/tournament_repository.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  final PlayerRepository _playerRepo = PlayerRepository();
  String? _winnerId;
  final GameRepository _gameRepo = GameRepository();
  final TournamentRepository _tournamentRepo = TournamentRepository();
  List<Tournament> _tournaments = [];
  List<String> _selectedTournamentIds = [];

  Map<String, TextEditingController> _scoreControllers = {};
  Map<String, bool> _selectedPlayers = {};

  @override
  void dispose() {
    for (var controller in _scoreControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _createGame() async {
    final selected = _selectedPlayers.entries
        .where(
          (entry) => int.tryParse(_scoreControllers[entry.key]!.text) != null,
        )
        .map((entry) => entry.key)
        .toList();

    if (selected.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleziona almeno due giocatore')),
      );
      return;
    }

    if (_winnerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleziona il vincitore della mano.')),
      );
      return;
    } else if (!selected.contains(_winnerId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Il vincitore deve aver totalizzato dei punti.'),
        ),
      );
      return;
    }

    List<PlayerScore> scores = [];
    for (var id in selected) {
      final scoreText = _scoreControllers[id]?.text ?? '0';
      int score = int.tryParse(scoreText) ?? 0;
      if (id == _winnerId) {
        score += 20;
      }
      scores.add(PlayerScore(playerId: id, score: score));
    }

    final game = Game(
      id: '', // sarà assegnato da Firestore
      scores: scores,
      winnerId: _winnerId,
      playedAt: DateTime.now(),
      tournamentIds:
          _selectedTournamentIds, // opzionale: per ora lasciamolo null
    );

    await _gameRepo.addGame(game);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    final tournaments = await _tournamentRepo.getTournamentsOnce();
    setState(() {
      _tournaments = tournaments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crea Partita")),
      body: StreamBuilder<List<Player>>(
        stream: _playerRepo.getPlayers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final players = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Giocatori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Text("Vincitore", style: TextStyle(fontSize: 10)),
                title: Text("Nome Giocatore", style: TextStyle(fontSize: 10)),
                trailing: Text(
                  "Punti Ottenuti",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              ...players.map((player) {
                _scoreControllers[player.id] ??= TextEditingController();
                _selectedPlayers[player.id] ??= false;

                return ListTile(
                  title: Row(
                    children: [SizedBox(width: 22), Text(player.name)],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _scoreControllers[player.id],
                      decoration: InputDecoration(labelText: 'Punti'),
                    ),
                  ),
                  leading: Radio<String>(
                    value: player.id,

                    groupValue: _winnerId,
                    onChanged: (value) {
                      setState(() {
                        _winnerId = value;
                      });
                    },
                  ),
                  onTap: () => setState(() {
                    _winnerId = player.id;
                  }),
                );
              }),
              SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Seleziona Tornei'),
                  ..._tournaments.map((t) {
                    return CheckboxListTile(
                      title: Text(t.name),
                      value: _selectedTournamentIds.contains(t.id),
                      onChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedTournamentIds.add(t.id);
                          } else {
                            _selectedTournamentIds.remove(t.id);
                          }
                        });
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createGame,
                child: const Text('Salva Partita'),
              ),
            ],
          );
        },
      ),
    );
  }
}
