import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';
import 'add_player_screen.dart';
import 'player_detail_screen.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({Key? key}) : super(key: key);

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final PlayerService _playerService = PlayerService();
  late Future<List<Player>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  void _fetchPlayers() {
    _playersFuture = _playerService.getAllPlayers();
  }

  void _navigateToAddPlayer() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPlayerScreen()),
    );
    // Dopo aver creato un nuovo giocatore, ricarica la lista
    setState(() {
      _fetchPlayers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giocatori')),
      body: FutureBuilder<List<Player>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          }

          final players = snapshot.data ?? [];

          return Column(
            children: [
              Expanded(
                child: players.isEmpty
                    ? const Center(child: Text('Nessun giocatore presente'))
                    : ListView.separated(
                        itemCount: players.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final player = players[index];
                          return ListTile(
                            title: Text(player.name),
                            subtitle: Text('ID: ${player.id}'),
                            leading: const Icon(Icons.person),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlayerDetailScreen(player: player),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Aggiungi Giocatore'),
                  onPressed: _navigateToAddPlayer,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}