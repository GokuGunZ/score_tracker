import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:score_tracker/utils/constants.dart';
import 'package:score_tracker/ui_components/expandable_tile_list_styled.dart';
import 'package:score_tracker/models/game.dart';
import 'dart:math';
import '../../ui_components/game_tracker_appbar.dart';

class GameHomepage extends StatefulWidget {
  const GameHomepage({super.key});

  @override
  State<GameHomepage> createState() => _GameHomepageState();
}

List<T> randomListOf<T>(int length, T Function(Random, int) generator) {
  final random = Random();
  return List.generate(length, (index) => generator(random, index));
}

class _GameHomepageState extends State<GameHomepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Game> _matchesList = randomListOf<Game>(10, (rand, i) {
    return Game(
      id: rand.nextInt(10000).toString(),
      playedAt: DateTime.now(),
      scores: [
        PlayerScore(playerId: rand.nextInt(10000).toString(), score: 150),
        PlayerScore(playerId: rand.nextInt(10000).toString(), score: 200),
      ],
      winnerId: "10",
      tournamentIds: ["1", "2", "3"],
    );
  });

  @override
  Widget build(BuildContext context) {
    const String gameName = "Burraco";
    Map<String, Object> gameVariations = {
      'name': "Varianti",
      'list': ['regolamentare'],
    };
    Map<String, Object> gameModes = {
      'name': "Modalità",
      'list': ['singolo', 'doppio'],
    };
    String gameInfo = "Il gioco del burraco è un bel gioco";
    double expandedHeight = 280;
    double toolBarHeight = 70;
    return Scaffold(
      key: _scaffoldKey,

      ///       -----  Drawer  -----       ///
      endDrawer: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 700,
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 500,
                child: Drawer(
                  shadowColor: gtAppbarColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(110),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        height: 120,
                        child: const DrawerHeader(
                          decoration: BoxDecoration(color: gtAppbarColor),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  'Game Tracker',
                                  style: TextStyle(
                                    color: Color.fromARGB(165, 234, 255, 114),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Divider(indent: 36, endIndent: 36),
                              Center(
                                child: Text(
                                  gameName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Item 1'),
                        onTap: () {
                          //TODO: implement It
                        },
                      ),
                      ListTile(title: const Text('Item 2'), onTap: () {}),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 21.6,
                    backgroundColor: gtAppbarColor,
                    child: IconButton(
                      tooltip: "Teams",
                      onPressed: () => null,
                      icon: Icon(Icons.groups_3_outlined),
                    ),
                  ),
                  CircleAvatar(
                    radius: 21.6,
                    backgroundColor: gtAppbarColor,
                    child: IconButton(
                      tooltip: "Homepage",
                      onPressed: () => null,
                      icon: Icon(Icons.home),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      ///       -----  AppBar  -----       ///
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: false,
                expandedHeight: expandedHeight,
                toolbarHeight: toolBarHeight,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final top = constraints.biggest.height;
                    final collapsed = toolBarHeight;
                    final maxBgOpacity = 0.7;
                    final bgOpacity =
                        (1 - (top - collapsed) / (280 - collapsed)).clamp(
                          0.0,
                          maxBgOpacity,
                        );
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: 1 - (bgOpacity / maxBgOpacity),
                          child: Image.asset(
                            'assets/img/$gameName.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          color: const Color.fromARGB(
                            255,
                            52,
                            195,
                            128,
                          ).withValues(alpha: bgOpacity),
                        ),

                        Positioned(
                          left: 43,
                          bottom: 11,
                          child: Opacity(
                            opacity: bgOpacity / maxBgOpacity,
                            child: Text(
                              gameName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing: 1.86,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              ///       -----  Content  -----       ///
              ///       -----  info  -----       ///
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CliccableClip(infoMap: gameVariations),
                    CliccableClip(infoMap: gameModes),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        backgroundColor: const Color.fromARGB(
                          255,
                          149,
                          221,
                          159,
                        ),
                      ),
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true, // 🔹 tap fuori per chiudere
                          barrierLabel: "Chiudi",
                          transitionDuration: Duration(milliseconds: 200),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                                return Center(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.85, // 85% larghezza
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.7, // 70% altezza
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(gameInfo),
                                    ),
                                  ),
                                );
                              },
                        );
                      },
                      child: Icon(Icons.info, color: Colors.white, size: 50),
                    ),
                  ],
                ),
              ),

              ///       -----  intro  -----       ///
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'In questa pagina potrai vedere le tue partite di $gameName e i gruppi correlati.',
                  ),
                ),
              ),

              ///       -----  liste  -----       ///
              SliverToBoxAdapter(
                child: ExpandableTileListStyled(
                  title: "Set Aperti",
                  listContent: _matchesList,
                ),
              ),
              SliverToBoxAdapter(
                child: ExpandableTileListStyled(
                  title: "Gruppi",
                  listContent: _matchesList,
                ),
              ),
              SliverToBoxAdapter(
                child: ExpandableTileListStyled(
                  title: "Partite terminate",
                  listContent: _matchesList,
                ),
              ),
            ],
          ),
          GameTrackerAppbar(),
        ],
      ),

      ///       -----  FloatingActionButton  -----       ///
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(25),
                ),
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                child: Icon(CupertinoIcons.game_controller),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(25),
                ),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: "Dismiss",
                    barrierColor: const Color.fromARGB(85, 146, 201, 212),
                    transitionDuration: const Duration(
                      milliseconds: 600,
                    ), // durata animazione
                    pageBuilder: (context, anim1, anim2) {
                      // il contenuto vero e proprio del tuo "drawer/dialog"
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 80.0,
                            bottom: 30,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.5,
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: CircleAvatar(
                                          radius: 21.6,
                                          backgroundColor: gtAppbarColor,
                                          child: IconButton(
                                            tooltip: "Create Match",
                                            onPressed: () => null,
                                            icon: Icon(Icons.plus_one),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: CircleAvatar(
                                          radius: 21.6,
                                          backgroundColor: gtAppbarColor,
                                          child: IconButton(
                                            tooltip: "Create Team",
                                            onPressed: () => null,
                                            icon: Icon(Icons.plus_one),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: CircleAvatar(
                                          radius: 21.6,
                                          backgroundColor: gtAppbarColor,
                                          child: IconButton(
                                            tooltip: "Create Set",
                                            onPressed: () => null,
                                            icon: Icon(Icons.plus_one),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.5,
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: CircleAvatar(
                                          radius: 21.6,
                                          backgroundColor: gtAppbarColor,
                                          child: IconButton(
                                            tooltip: "Matches",
                                            onPressed: () => null,
                                            icon: Icon(Icons.attractions),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: CircleAvatar(
                                          radius: 21.6,
                                          backgroundColor: gtAppbarColor,
                                          child: IconButton(
                                            tooltip: "Teams",
                                            onPressed: () => null,
                                            icon: Icon(Icons.groups_3_outlined),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: CircleAvatar(
                                          radius: 21.6,
                                          backgroundColor: gtAppbarColor,
                                          child: IconButton(
                                            tooltip: "Sets",
                                            onPressed: () => null,
                                            icon: Icon(
                                              Icons.batch_prediction_outlined,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    transitionBuilder: (context, anim1, anim2, child) {
                      // animazioni combinate: translate da destra + fade
                      final offsetAnimation =
                          Tween<Offset>(
                            begin: const Offset(1, 0), // parte da destra
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: anim1,
                              curve: Curves.easeOutCubic,
                            ),
                          );

                      final opacityAnimation = CurvedAnimation(
                        parent: anim1,
                        curve: Curves.easeIn,
                      );

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: opacityAnimation,
                          child: child,
                        ),
                      );
                    },
                  );
                },
                child: Icon(Icons.swipe_left_alt_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CliccableClip extends StatelessWidget {
  final Map<String, Object> infoMap;

  const CliccableClip({super.key, required this.infoMap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true, // 🔹 tap fuori per chiudere
              barrierLabel: "Chiudi",
              transitionDuration: Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) {
                return Center(
                  // 🔹 centrata nello schermo
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width:
                          MediaQuery.of(context).size.width *
                          0.85, // 85% larghezza
                      height:
                          MediaQuery.of(context).size.height *
                          0.7, // 70% altezza
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.builder(
                        itemCount: (infoMap['list'] as List).length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            title: Text((infoMap['list'] as List)[index]),
                            children: [
                              ListTile(
                                title: Text(
                                  "Dettaglio A di ${(infoMap['list'] as List)[index]}",
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            width: 73,
            height: 73,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(180, 88, 176, 91),
                  Color.fromARGB(155, 117, 205, 120),
                ],
              ),
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${(infoMap['list'] as List).length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(infoMap['name'] as String),
      ],
    );
  }
}
