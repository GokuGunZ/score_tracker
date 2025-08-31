import 'package:cloud_firestore/cloud_firestore.dart';

class Tournament {
  final String id;
  final String name;
  final List<String> playerIds;
  final DateTime createdAt;

  Tournament({
    required this.id,
    required this.name,
    required this.playerIds,
    required this.createdAt,
  });

factory Tournament.fromMap(Map<String, dynamic> data, String id) {
  return Tournament(
    id: id,
    name: data['name'] ?? '',
    playerIds: List<String>.from(data['playerIds'] ?? []),
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );
}

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'playerIds': playerIds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Tournament.fromJson(Map<String, dynamic> json, String id) {
    return Tournament(
      id: id,
      name: json['name'] as String,
      playerIds: List<String>.from(json['playerIds'] ?? []),
      createdAt: (json['createdAt'] as DateTime),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'playerIds': playerIds,
      'createdAt': createdAt,
    };
  }

  Tournament copyWith({
    String? id,
    String? name,
    List<String>? playerIds,
    DateTime? createdAt,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      playerIds: playerIds ?? this.playerIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

}