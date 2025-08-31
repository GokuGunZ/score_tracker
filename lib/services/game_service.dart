import '../models/game.dart';
import 'game_repository.dart';

class GameService {
  final GameRepository _repo;

  GameService(this._repo);

  Stream<List<Game>> getSortedGames() {
    return _repo.getGames().map((games) {
      games.sort((a, b) => b.playedAt.compareTo(a.playedAt));
      return games;
    });
  }

  Future<void> createGame(Game game) async {
    // potresti aggiungere validazioni o controlli prima
    await _repo.addGame(game);
  }
}