import 'package:flutter/foundation.dart';

/// ViewModel for the Join Room screen
class JoinRoomViewModel extends ChangeNotifier {

  String _nickname = '';
  String _roomName = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get nickname => _nickname;
  String get roomName => _roomName;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Set nickname
  void setNickname(String value) {
    _nickname = value;
    _clearError();
  }

  /// Set room name
  void setRoomName(String value) {
    _roomName = value;
    _clearError();
  }

  /// Validate form inputs
  bool validate() {
    if (_nickname.isEmpty) {
      _errorMessage = 'Please enter your name';
      notifyListeners();
      return false;
    }
    if (_roomName.isEmpty) {
      _errorMessage = 'Please enter the room name';
      notifyListeners();
      return false;
    }
    return true;
  }

  /// Get room data for navigation
  Map<String, String> getRoomData() {
    return {
      'nickname': _nickname,
      'name': _roomName,
    };
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Reset the form
  void reset() {
    _nickname = '';
    _roomName = '';
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
