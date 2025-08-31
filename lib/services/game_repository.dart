import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game.dart';

class GameRepository {
  final CollectionReference _gamesRef =
      FirebaseFirestore.instance.collection('games');

  Stream<List<Game>> getGames() {
    return _gamesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Game.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addGame(Game game) async {
    await _gamesRef.add(game.toMap());
  }

  Future<void> updateGame(String id, Game updatedGame) async {
    await _gamesRef.doc(id).update(updatedGame.toMap());
  }

  Future<Game> getGameById(String id) async {
    final doc = await _gamesRef.doc(id).get();
    return Game.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<void> deleteGame(String id) async {
    await _gamesRef.doc(id).delete();
  }

  Future<List<Game>> getGamesOnce() async {
    final snapshot = await _gamesRef.get();
    return snapshot.docs.map((doc) => Game.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}