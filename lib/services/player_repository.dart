import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:score_tracker/models/game.dart';
import '../models/player.dart';

class PlayerRepository {
  final CollectionReference _playersCollection =
      FirebaseFirestore.instance.collection('players');

  /// Crea un nuovo giocatore nel DB
  Future<void> addPlayer(Player player) async {
    await _playersCollection.add(player.toMap());
  }

  /// Recupera tutti i giocatori
  Future<List<Player>> getAllPlayers() async {
    final snapshot = await _playersCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Player.fromMap(data, doc.id);
    }).toList();
  }

  Future<List<Player>> getPlayerInScores(List<PlayerScore> scores) async {
      if (scores.isEmpty) return [];
      var ids = [];
      scores.map((score) => ids.add(score.playerId));
      
      final snapshot = await _playersCollection.where(FieldPath.documentId, whereIn: ids).get();

      return snapshot.docs.map((doc) {
        return Player(id: doc.id, name: (doc.data() as Map<String, String>)['data'].toString());
      }).toList();
  }

  Future<List<Player>> getPlayersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final snapshot = await _playersCollection
        .where(FieldPath.documentId, whereIn: ids)
        .get();
    return snapshot.docs.map((doc) => Player.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<Map<String, String>> getPlayerNames(List<String> ids) async {
    final snapshot = await _playersCollection
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return {
      for (var doc in snapshot.docs)
        doc.id: (doc.data() as Map<String, dynamic>)['name'] ?? 'Sconosciuto',
    };
  }

    Future<Map<String,String>> getPlayerMapInScores(List<PlayerScore> scores) async {
      if (scores.isEmpty) return {};
      var ids = scores.map((score) => score.playerId).toList();

      
      final snapshot = await _playersCollection.where(FieldPath.documentId, whereIn: ids).get();
      final Map<String,String> playerMap = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        playerMap[doc.id] = data['name']?.toString() ?? 'Sconosciuto';
      }
      return playerMap;
  }

  Stream<List<Player>> getPlayers() {
    return _playersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Player.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Recupera un singolo giocatore dal suo ID
  Future<Player?> getPlayerById(String id) async {
    final doc = await _playersCollection.doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return Player.fromMap(data, doc.id);
    }
    return null;
  }

  /// (Facoltativo) Aggiorna un giocatore
  Future<void> updatePlayer(Player player) async {
    await _playersCollection.doc(player.id).update(player.toMap());
  }

  /// (Facoltativo) Elimina un giocatore
  Future<void> deletePlayer(String id) async {
    await _playersCollection.doc(id).delete();
  }
}