import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game.dart';
import '../services/game_repository.dart';
import 'game_detail_screen.dart';

class GamesScreen extends StatelessWidget {
  final GameRepository _repo = GameRepository(); // o inietti via costruttore

  GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partite')),
      body: StreamBuilder<List<Game>>(
        stream: _repo.getGames(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final games = snapshot.data!;
          if (games.isEmpty) {
            return const Center(child: Text('Nessuna partita ancora.'));
          }
          final gamesSorted = games
            ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

          return ListView.builder(
            itemCount: gamesSorted.length,
            itemBuilder: (context, index) {
              final game = gamesSorted[index];
              return Dismissible(
                key: Key(game.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Conferma eliminazione"),
                      content: const Text("Vuoi davvero eliminare questa partita?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Annulla"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Elimina", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) async {
                  await _repo.deleteGame(game.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Partita eliminata')),
                  );
                },
                child: ListTile(
                  title: Text("Partita del ${DateFormat('dd MMM yyyy – HH:mm').format(game.playedAt)}"),
                  subtitle: Text("Giocatori: ${game.scores.length}   |  Tornei: ${game.tournamentIds.length}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailScreen(game: game),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Nuova Partita', style: TextStyle(fontSize: 17),),
                  onPressed: () {
                    Navigator.pushNamed(context, '/create_game'); // rotta da definire
                  },
                ),
              ),
    );
  }
}


