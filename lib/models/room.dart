import 'package:skribby/models/player.dart';

/// Room model representing a game room
class Room {
  final String name;
  final int occupancy;
  final int maxRounds;
  final List<Player> players;
  final bool isJoin;
  final int turnIndex;
  final Player? turn;
  final String word;

  Room({
    required this.name,
    required this.occupancy,
    required this.maxRounds,
    required this.players,
    this.isJoin = true,
    this.turnIndex = 0,
    this.turn,
    this.word = '',
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    List<Player> playersList = [];
    if (json['players'] != null) {
      playersList = (json['players'] as List)
          .map((p) => Player.fromJson(p as Map<String, dynamic>))
          .toList();
    }

    Player? currentTurn;
    if (json['turn'] != null) {
      currentTurn = Player.fromJson(json['turn'] as Map<String, dynamic>);
    }

    return Room(
      name: json['name'] ?? '',
      occupancy: json['occupancy'] ?? 0,
      maxRounds: json['maxRounds'] ?? 0,
      players: playersList,
      isJoin: json['isJoin'] ?? true,
      turnIndex: json['turnIndex'] ?? 0,
      turn: currentTurn,
      word: json['word'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'occupancy': occupancy,
      'maxRounds': maxRounds,
      'players': players.map((p) => p.toJson()).toList(),
      'isJoin': isJoin,
      'turnIndex': turnIndex,
      'turn': turn?.toJson(),
      'word': word,
    };
  }
}
