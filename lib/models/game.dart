import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerScore {
  final String playerId;
  final int score;

  PlayerScore({
    required this.playerId,
    required this.score,
  });

  factory PlayerScore.fromMap(Map<String, dynamic> data) {
    return PlayerScore(
      playerId: data['playerId'],
      score: data['score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'score': score,
    };
  }
}

class Game {
  final String id;
  final DateTime playedAt;
  final List<PlayerScore> scores;
  final String? winnerId;
  final List<String> tournamentIds;

  Game({
    required this.id,
    required this.playedAt,
    required this.scores,
    required this.winnerId,
    required this.tournamentIds,
  });

  factory Game.fromMap(Map<String, dynamic> data, String id) {
    return Game(
      id: id,
      playedAt: (data['playedAt'] as Timestamp).toDate(),
      scores: (data['scores'] as List)
          .map((item) => PlayerScore.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
      winnerId: data['winnerId'] as String?,
      tournamentIds: List<String>.from(data['tournamentIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playedAt': Timestamp.fromDate(playedAt),
      'scores': scores.map((s) => s.toMap()).toList(),
      'winnerId': winnerId,
      'tournamentIds': tournamentIds,
    };
  }

  Game copyWith({
    String? id,
    DateTime? playedAt,
    List<PlayerScore>? scores,
    String? winnerId,
    List<String>? tournamentIds,
  }) {
    return Game(
      id: id ?? this.id,
      playedAt: playedAt ?? this.playedAt,
      scores: scores ?? this.scores,
      winnerId: winnerId ?? this.winnerId,
      tournamentIds: tournamentIds ?? this.tournamentIds,
    );
  }
  
}