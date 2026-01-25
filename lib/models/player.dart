/// Player model representing a user in a game room
class Player {
  final String socketId;
  final String nickname;
  final bool isPartyLeader;
  final int points;

  Player({
    required this.socketId,
    required this.nickname,
    this.isPartyLeader = false,
    this.points = 0,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      socketId: json['socketID'] ?? '',
      nickname: json['nickname'] ?? '',
      isPartyLeader: json['isPartyLeader'] ?? false,
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'socketID': socketId,
      'nickname': nickname,
      'isPartyLeader': isPartyLeader,
      'points': points,
    };
  }
}
