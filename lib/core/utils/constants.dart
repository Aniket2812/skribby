/// App-wide constants
class AppConstants {
  AppConstants._();

  /// Server URL for socket.io connection
  static const String serverUrl = 'http://192.168.0.102:3000';

  /// Maximum rounds options
  static const List<String> maxRoundsOptions = ['2', '5', '10', '15'];

  /// Room size options
  static const List<String> roomSizeOptions = ['2', '3', '4', '5', '6', '7', '8'];
}
