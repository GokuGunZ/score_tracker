import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:score_tracker/screens/game/game_homepage.dart';
import 'package:score_tracker/screens/games_screen.dart';
import 'firebase_options.dart'; // generato automaticamente da Firebase CLI
import 'screens/players_screen.dart';
import 'screens/tournaments_screen.dart';
import 'screens/create_game_page.dart';
import 'models/tournament.dart';
import 'screens/tournament_detail_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Score Tracker'),
      //home: const GameHomepage(),
      routes: {
        '/create_game': (context) => const CreateGamePage(),
        '/tournament_detail': (context) {
          final Tournament tournament = ModalRoute.of(context)!.settings.arguments as Tournament;
          return TournamentDetailScreen(tournament: tournament);
        },
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    GamesScreen(),
    TournamentsScreen(),
    PlayersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Partite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Tornei',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Giocatori',
          ),
        ],
      ),
    );
  }
}
