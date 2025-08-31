class Player {
  final String id;
  final String name;

  Player({
    required this.id,
    required this.name,
  });

  factory Player.fromMap(Map<String, dynamic> data, String id) {
    return Player(
      id: id,
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json, String id) {
    return Player(
      id: id,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  Player copyWith({String? id, String? name}) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}