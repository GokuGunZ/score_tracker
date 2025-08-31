class PlayerStats {
  final String? name;
  final int totalPoints;
  final int gamesPlayed;
  final Map<String, PlayerStats> tournamentStats;

  PlayerStats({
    this.name,
    required this.totalPoints,
    required this.gamesPlayed,
    this.tournamentStats = const {},
  });

  double get averagePoints => gamesPlayed == 0 ? 0 : totalPoints / gamesPlayed;

  PlayerStats copyWith({
    String? name,
    int? totalPoints,
    int? gamesPlayed,
    Map<String, PlayerStats>? tournamentStats,
  }) {
    return PlayerStats(
      name: name ?? this.name,
      totalPoints: totalPoints ?? this.totalPoints,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      tournamentStats: tournamentStats ?? this.tournamentStats,
    );
  }
}