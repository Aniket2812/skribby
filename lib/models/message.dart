class Message {
  final String username;
  final String message;
  final DateTime timestamp;
  final bool isSystemMessage;

  Message({
    required this.username,
    required this.message,
    DateTime? timestamp,
    this.isSystemMessage = false,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      username: json['username'] ?? '',
      message: json['message'] ?? '',
      isSystemMessage: json['isSystemMessage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'message': message,
      'isSystemMessage': isSystemMessage,
    };
  }
}
