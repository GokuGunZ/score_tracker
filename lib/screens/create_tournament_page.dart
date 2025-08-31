import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/tournament.dart';
import '../services/player_repository.dart';
import '../services/tournament_repository.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({Key? key}) : super(key: key);

  @override
  State<CreateTournamentPage> createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _nameController = TextEditingController();
  final Set<String> _selectedPlayerIds = {};
  bool _isLoading = false;

  List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final players = await PlayerRepository().getAllPlayers();
    setState(() {
      _players = players;
    });
  }

  Future<void> _createTournament() async {
    if (_nameController.text.trim().isEmpty || _selectedPlayerIds.isEmpty) return;

    setState(() => _isLoading = true);

    final newTournament = Tournament(
      id: '', // sarà settato da Firestore
      name: _nameController.text.trim(),
      playerIds: _selectedPlayerIds.toList(),
      createdAt: DateTime.now(),
    );

    await TournamentRepository().addTournament(newTournament);

    setState(() => _isLoading = false);

    Navigator.pop(context); // Torna indietro dopo la creazione
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crea Torneo")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nome del torneo", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: "Es. Torneo Estivo"),
                  ),
                  const SizedBox(height: 20),
                  const Text("Seleziona i giocatori", style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _players.length,
                      itemBuilder: (context, index) {
                        final player = _players[index];
                        final isSelected = _selectedPlayerIds.contains(player.id);
                        return CheckboxListTile(
                          title: Text(player.name),
                          value: isSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedPlayerIds.add(player.id);
                              } else {
                                _selectedPlayerIds.remove(player.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createTournament,
                      child: const Text("Crea Torneo"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}