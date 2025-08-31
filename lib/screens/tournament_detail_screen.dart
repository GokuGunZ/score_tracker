import 'package:flutter/material.dart';
import '../models/tournament.dart';
import '../models/player_stats.dart';
import '../models/player.dart';
import '../services/game_repository.dart';
import '../services/player_repository.dart';
import 'player_detail_screen.dart';

class TournamentDetailScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentDetailScreen({super.key, required this.tournament});

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {
  final GameRepository _gameRepo = GameRepository();
  final PlayerRepository _playerRepo = PlayerRepository();

  late Future<Map<String, PlayerStats>> _playerStatsFuture;

  @override
  void initState() {
    super.initState();
    _playerStatsFuture = _computePlayerStats();
  }

  Future<Map<String, PlayerStats>> _computePlayerStats() async {
    final games = await _gameRepo.getGamesOnce();
    final gamesInTournament = games.where((g) => g.tournamentIds.contains(widget.tournament.id)).toList();

    final Map<String, PlayerStats> stats = {};
    for (var game in gamesInTournament) {
      for (var score in game.scores) {
        if (!widget.tournament.playerIds.contains(score.playerId)) continue;

        stats[score.playerId] = stats[score.playerId]?.copyWith(
              totalPoints: stats[score.playerId]!.totalPoints + score.score,
              gamesPlayed: stats[score.playerId]!.gamesPlayed + 1,
            ) ??
            PlayerStats(totalPoints: score.score, gamesPlayed: 1);
      }
    }

    final nameMap = await _playerRepo.getPlayerNames(stats.keys.toList());
    stats.updateAll((id, stat) => stat.copyWith(name: nameMap[id] ?? 'Sconosciuto'));

    return stats;
  }

  @override
  Widget build(BuildContext context) {
    final tournament = widget.tournament;

    return Scaffold(
      appBar: AppBar(title: Text(tournament.name)),
      body: FutureBuilder<Map<String, PlayerStats>>(
        future: _playerStatsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final stats = snapshot.data!;
          final sortedStats = stats.entries.toList()
            ..sort((a, b) => b.value.totalPoints.compareTo(a.value.totalPoints));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Data creazione: ${tournament.createdAt.toLocal()}'),
              const SizedBox(height: 8),
              Text('Giocatori iscritti: ${tournament.playerIds.length}'),
              const Divider(height: 32),
              const Text('Classifica', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              ...sortedStats.map((entry) {
                final player = entry.value;
                return ListTile(
                  title: Text(player.name ?? 'Sconosciuto'),
                  subtitle: Text('${player.gamesPlayed} partite giocate'),
                  trailing: Text('${player.totalPoints} | ${player.averagePoints.toStringAsFixed(1)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerDetailScreen(player: Player(id: entry.key, name: entry.value.name ?? 'Sconosciuto')),
                      ),
                    );
                  },  
                );
              }),
            ],
          );
        },
      ),
    );
  }
}