import 'package:flutter/foundation.dart';
import 'package:skribby/core/utils/constants.dart';

/// ViewModel for the Create Room screen
class CreateRoomViewModel extends ChangeNotifier {

  String _nickname = '';
  String _roomName = '';
  String? _maxRounds;
  String? _roomSize;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get nickname => _nickname;
  String get roomName => _roomName;
  String? get maxRounds => _maxRounds;
  String? get roomSize => _roomSize;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get maxRoundsOptions => AppConstants.maxRoundsOptions;
  List<String> get roomSizeOptions => AppConstants.roomSizeOptions;

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

  /// Set max rounds
  void setMaxRounds(String? value) {
    _maxRounds = value;
    _clearError();
    notifyListeners();
  }

  /// Set room size
  void setRoomSize(String? value) {
    _roomSize = value;
    _clearError();
    notifyListeners();
  }

  /// Validate form inputs
  bool validate() {
    if (_nickname.isEmpty) {
      _errorMessage = 'Please enter your name';
      notifyListeners();
      return false;
    }
    if (_roomName.isEmpty) {
      _errorMessage = 'Please enter a room name';
      notifyListeners();
      return false;
    }
    if (_maxRounds == null) {
      _errorMessage = 'Please select max rounds';
      notifyListeners();
      return false;
    }
    if (_roomSize == null) {
      _errorMessage = 'Please select room size';
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
      'occupancy': _roomSize!,
      'maxRounds': _maxRounds!,
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
    _maxRounds = null;
    _roomSize = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
