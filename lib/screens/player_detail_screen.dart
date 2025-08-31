import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/game.dart';
import '../models/player_stats.dart';
import '../models/tournament.dart';
import '../services/game_repository.dart';
import '../services/tournament_repository.dart';

class PlayerDetailScreen extends StatefulWidget {
  final Player player;

  const PlayerDetailScreen({Key? key, required this.player}) : super(key: key);

  @override
  State<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  final GameRepository _gameRepo = GameRepository();
  final TournamentRepository _tournamentRepo = TournamentRepository();

  late Future<PlayerStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _computeStats();
  }

  Future<PlayerStats> _computeStats() async {
    final games = await _gameRepo.getGamesOnce();
    int totalPoints = 0;
    int gamesPlayed = 0;
    Map<String, PlayerStats> tournamentStats = {};

    // Calcola punti totali
    for (var game in games) {
      final found = game.scores.firstWhere(
        (s) => s.playerId == widget.player.id,
        orElse: () => PlayerScore(playerId: '', score: 0),
      );
      if (found.playerId.isEmpty) continue;

      gamesPlayed++;
      totalPoints += found.score;

      // Statistiche per torneo
      for (var tId in game.tournamentIds) {
        tournamentStats[tId] = tournamentStats[tId]?.copyWith(
              totalPoints: tournamentStats[tId]!.totalPoints + found.score,
              gamesPlayed: tournamentStats[tId]!.gamesPlayed + 1,
            ) ??
            PlayerStats(totalPoints: found.score, gamesPlayed: 1);
      }
    }

    final tournamentNames = await _tournamentRepo.getTournamentNames(tournamentStats.keys.toList());
    tournamentStats.updateAll((tId, stat) => stat.copyWith(name: tournamentNames[tId]));

    return PlayerStats(
      name: widget.player.name,
      totalPoints: totalPoints,
      gamesPlayed: gamesPlayed,
      tournamentStats: tournamentStats,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.player.name)),
      body: FutureBuilder<PlayerStats>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final stats = snapshot.data!;

          final sortedTournaments = stats.tournamentStats.entries.toList()
            ..sort((a, b) => b.value.totalPoints.compareTo(a.value.totalPoints));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Partite giocate: ${stats.gamesPlayed}'),
              Text('Punti totali: ${stats.totalPoints}'),
              Text('Media punti: ${stats.averagePoints.toStringAsFixed(2)}'),
              const Divider(height: 32),
              const Text('Tornei disputati', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              ...sortedTournaments.map((entry) {
                final tId = entry.key;
                final stat = entry.value;
                return ListTile(
                  title: Text(stat.name ?? 'Torneo sconosciuto'),
                  subtitle: Text('${stat.gamesPlayed} partite'),
                  trailing: Text('${stat.totalPoints} p.'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/tournament_detail',
                      arguments: Tournament(id: tId, name: stat.name ?? '', playerIds: [], createdAt: DateTime.now()),
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