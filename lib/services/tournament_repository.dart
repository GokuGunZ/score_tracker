import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tournament.dart';

class TournamentRepository {
  final _tournamentsRef = FirebaseFirestore.instance.collection('tournaments');

  Future<void> addTournament(Tournament tournament) async {
    await _tournamentsRef.add(tournament.toMap());
  }

  Future<List<Tournament>> getTournaments() async {
    final querySnapshot = await _tournamentsRef.orderBy('createdAt', descending: true).get();
    return querySnapshot.docs
        .map((doc) => Tournament.fromMap(doc.data(), doc.id))
        .toList();
  }

  Stream<List<Tournament>> listenTournaments() {
    return FirebaseFirestore.instance
      .collection('tournaments')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) =>
          Tournament.fromMap(doc.data(), doc.id)).toList());
  }

  Future<List<Tournament>> getTournamentsOnce() async {
    final snapshot = await _tournamentsRef.get();
    return snapshot.docs.map((doc) => Tournament.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<Tournament>> getTournamentsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final snapshot = await _tournamentsRef.where(FieldPath.documentId, whereIn: ids).get();

    return snapshot.docs.map((doc) {
      return Tournament.fromMap(doc.data(), doc.id);
    }).toList();
}
  Future<void> updateTournament(Tournament tournament) async {
    await _tournamentsRef.doc(tournament.id).update(tournament.toMap());
  }

  Future<void> deleteTournament(String id) async {
    await _tournamentsRef.doc(id).delete();
  }

  Stream<List<Tournament>> listenToTournaments() {
    return _tournamentsRef.orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Tournament.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  Future<Map<String, String>> getTournamentNames(List<String> ids) async {
    final snapshot = await _tournamentsRef.where(FieldPath.documentId, whereIn: ids).get();
    return { for (var doc in snapshot.docs) doc.id: (doc.data())['name'] ?? 'Sconosciuto' };
  }
}