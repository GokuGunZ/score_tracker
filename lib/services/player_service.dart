import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class PlayerService {
  final CollectionReference playersRef =
      FirebaseFirestore.instance.collection('players');

  // 🔹 Crea un nuovo Player
  Future<void> createPlayer(Player player) async {
    await playersRef.doc(player.id).set(player.toJson());
  }

  // 🔹 Leggi tutti i giocatori
  Future<List<Player>> getAllPlayers() async {
    final snapshot = await playersRef.get();
    return snapshot.docs
        .map((doc) => Player.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // 🔹 Leggi un singolo giocatore per ID
  Future<Player?> getPlayerById(String id) async {
    final doc = await playersRef.doc(id).get();
    if (doc.exists) {
      return Player.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // 🔹 Aggiorna un giocatore esistente
  Future<void> updatePlayer(Player player) async {
    await playersRef.doc(player.id).update(player.toJson());
  }

  // 🔹 Cancella un giocatore (opzionale)
  Future<void> deletePlayer(String id) async {
    await playersRef.doc(id).delete();
  }
}