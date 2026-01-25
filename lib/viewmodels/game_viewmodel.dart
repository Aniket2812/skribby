import 'package:flutter/material.dart';
import 'package:skribby/core/services/socket_service.dart';
import 'package:skribby/models/message.dart';
import 'package:skribby/models/touch_points.dart';

/// ViewModel for the Game (Paint) screen
class GameViewModel extends ChangeNotifier {
  final SocketService _socketService = SocketService();
  final Map<String, String> roomData;
  final String screenFrom;

  GameViewModel({
    required this.roomData,
    required this.screenFrom,
  }) {
    _initializeSocket();
  }

  // Drawing state
  List<TouchPoints?> _points = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  double _opacity = 1.0;
  StrokeCap _strokeType = StrokeCap.round;

  // Room state
  Map<String, dynamic> _dataOfRoom = {};
  
  // Chat state
  List<Message> _messages = [];

  // Getters
  List<TouchPoints?> get points => _points;
  Color get selectedColor => _selectedColor;
  double get strokeWidth => _strokeWidth;
  double get opacity => _opacity;
  StrokeCap get strokeType => _strokeType;
  Map<String, dynamic> get dataOfRoom => _dataOfRoom;
  List<Message> get messages => _messages;
  String get nickname => roomData['nickname'] ?? '';
  String get roomName => _dataOfRoom['name'] ?? roomData['name'] ?? '';

  /// Initialize socket connection and listeners
  void _initializeSocket() {
    _socketService.connect();

    // Listen for connection
    _socketService.on('connect', (_) {
      print('GameViewModel: Socket connected');
      if (screenFrom == 'createRoom') {
        _socketService.emit('create-game', roomData);
      } else {
        _socketService.emit('join-game', roomData);
      }
    });

    // Room updates
    _socketService.on('updateRoom', (data) {
      print('GameViewModel: Room updated - ${data['name']}');
      _dataOfRoom = Map<String, dynamic>.from(data);
      notifyListeners();
    });

    // Drawing points from other players
    _socketService.on('points', (point) {
      if (point['details'] == null) {
        _points.add(null);
      } else {
        _points.add(
          TouchPoints(
            points: Offset(
              (point['details']['dx']).toDouble(),
              (point['details']['dy']).toDouble(),
            ),
            paint: Paint()
              ..strokeCap = _strokeType
              ..isAntiAlias = true
              ..color = _selectedColor.withOpacity(_opacity)
              ..strokeWidth = _strokeWidth,
          ),
        );
      }
      notifyListeners();
    });

    // Color change from other players
    _socketService.on('color-change', (colorString) {
      int value = int.parse(colorString, radix: 16);
      _selectedColor = Color(value);
      notifyListeners();
    });

    // Chat messages
    _socketService.on('msg', (data) {
      _messages.add(Message.fromJson(data));
      notifyListeners();
    });

    // Error handling
    _socketService.on('notCorrectGame', (message) {
      print('GameViewModel: Error - $message');
    });
  }

  /// Add a drawing point locally and emit to server
  void addPoint(Offset localPosition) {
    final touchPoint = TouchPoints(
      points: localPosition,
      paint: Paint()
        ..strokeCap = _strokeType
        ..isAntiAlias = true
        ..color = _selectedColor.withOpacity(_opacity)
        ..strokeWidth = _strokeWidth,
    );

    _points.add(touchPoint);
    notifyListeners();

    // Emit to server
    _socketService.emit('paint', {
      'details': {
        'dx': localPosition.dx,
        'dy': localPosition.dy,
      },
      'roomName': roomData['name'],
    });
  }

  /// End the current stroke
  void endStroke() {
    _points.add(null);
    notifyListeners();

    _socketService.emit('paint', {
      'details': null,
      'roomName': roomData['name'],
    });
  }

  /// Change the drawing color
  void changeColor(Color color) {
    _selectedColor = color;
    notifyListeners();

    // Emit color change to server
    if (_dataOfRoom['name'] != null) {
      String colorString = color.value.toRadixString(16);
      _socketService.emit('color-change', {
        'color': colorString,
        'roomName': _dataOfRoom['name'],
      });
    }
  }

  /// Change the stroke width
  void changeStrokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }

  /// Clear the canvas
  void clearCanvas() {
    _points.clear();
    notifyListeners();
  }

  /// Send a chat message
  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    _socketService.emit('msg', {
      'message': message.trim(),
      'roomName': _dataOfRoom['name'] ?? roomData['name'],
      'username': roomData['nickname'],
    });
  }

  @override
  void dispose() {
    _socketService.off('connect');
    _socketService.off('updateRoom');
    _socketService.off('points');
    _socketService.off('color-change');
    _socketService.off('msg');
    _socketService.off('notCorrectGame');
    super.dispose();
  }
}
