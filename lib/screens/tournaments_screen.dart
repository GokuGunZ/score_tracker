import 'package:flutter/material.dart';
import 'package:score_tracker/models/tournament.dart';
import 'package:score_tracker/services/tournament_repository.dart';
import 'package:score_tracker/screens/create_tournament_page.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({Key? key}) : super(key: key);

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  final TournamentRepository _tournamentRepo = TournamentRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tornei"),
      ),
      body: StreamBuilder<List<Tournament>>(
        stream: _tournamentRepo.listenToTournaments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tournaments = snapshot.data ?? [];

          if (tournaments.isEmpty) {
            return const Center(child: Text("Nessun torneo disponibile."));
          }

          return ListView.builder(
            itemCount: tournaments.length,
            itemBuilder: (context, index) {
              final tournament = tournaments[index];

              return ListTile(
                title: Text(tournament.name),
                subtitle: Text("Giocatori: ${tournament.playerIds.length}"),
                onTap: () {
                Navigator.pushNamed(
                  context,
                  '/tournament_detail',
                  arguments: tournament,
                );
              }
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Nuovo Torneo', style: TextStyle(fontSize: 17),),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateTournamentPage(),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}