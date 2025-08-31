import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:score_tracker/services/game_repository.dart';
import 'package:score_tracker/services/player_repository.dart';
import '../models/game.dart';
import '../services/tournament_repository.dart';
import '../models/tournament.dart';
import 'edit_game_screen.dart';

// ignore: must_be_immutable
class GameDetailScreen extends StatefulWidget {
  Game game;

  GameDetailScreen({super.key, required this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  final TournamentRepository tournamentRepo = TournamentRepository();
  final GameRepository gameRepository = GameRepository();

  final PlayerRepository playerRepo = PlayerRepository();

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy – HH:mm').format(widget.game.playedAt);
    return Scaffold(
      appBar: AppBar(
        title: Text('Partita del $dateStr'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditGameScreen(gameId: widget.game.id),
                ),
              );

              if (updated == true) {
                final newGame = await gameRepository.getGameById(widget.game.id);
                setState(() {
                  widget.game = newGame;
                });
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Giocatori e punteggi", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          FutureBuilder<Map<String,String>>(
            future: playerRepo.getPlayerMapInScores(widget.game.scores),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Errore nel caricamento dei giocatori');
              }

              final playerMap = snapshot.data ?? [];
              return Column(
                children: widget.game.scores.map((score) {
                  final isWinner = score.playerId == widget.game.winnerId;
                  return ListTile(
                    leading: isWinner ? const Icon(Icons.emoji_events, color: Colors.amber) : null,
                    title: Text('Giocatore: ${(playerMap as Map<String, String>)[score.playerId]}'),
                    subtitle: Text('Punti: ${score.score}'),
                    tileColor: isWinner ? Colors.yellow.withAlpha(25) : null,
                  );
                }).toList(),
              );
            },
          ),

          const Divider(height: 32),

          Text("Tornei associati", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          FutureBuilder<List<Tournament>>(
            future: tournamentRepo.getTournamentsByIds(widget.game.tournamentIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Errore nel caricamento dei tornei');
              }

              final tournaments = snapshot.data ?? [];

              return Column(
                children: tournaments.map((t) {
                  return ListTile(
                    title: Text(t.name),
                    subtitle: Text('ID: ${t.id}'),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/tournament_detail',
                        arguments: t,
                      );
                    },
                    trailing: const Icon(Icons.chevron_right),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}