import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:skribby/models/message.dart';
import 'package:skribby/models/my_custom_painter.dart';
import 'package:skribby/models/touch_points.dart';
import 'package:skribby/widgets/chat_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintScreen extends StatefulWidget {
  final Map<String, String> data;
  final String screenFrom;
  PaintScreen({required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late IO.Socket _socket;
  Map dataOfRoom = {};
  List<TouchPoints?> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;
  
  // Chat related
  List<Message> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    connect();
  }

  //socket.io client connection
  void connect() {
    _socket = IO.io('http://192.168.0.102:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket.connect();

    // Listen for connection event
    _socket.onConnect((data) {
      print('Socket connected!');
      // Emit create/join game after connection is established
      if (widget.screenFrom == 'createRoom') {
        _socket.emit('create-game', widget.data);
      } else {
        _socket.emit('join-game', widget.data);
      }
    });

    // Register event listeners at the top level (not nested in onConnect)
    _socket.on('updateRoom', (roomData) {
      print('Room updated: ${roomData['name']}');
      setState(() {
        dataOfRoom = roomData;
      });
      if (roomData['isJoin'] != true) {
        //start the timer
      }
    });

    _socket.on('points', (point) {
      // Points from other players
      if (point['details'] == null) {
        setState(() {
          points.add(null);
        });
        return;
      }

      setState(() {
        points.add(
          TouchPoints(
            points: Offset(
              (point['details']['dx']).toDouble(),
              (point['details']['dy']).toDouble(),
            ),
            paint: Paint()
              ..strokeCap = strokeType
              ..isAntiAlias = true
              ..color = selectedColor.withOpacity(opacity)
              ..strokeWidth = strokeWidth,
          ),
        );
      });
    });

    _socket.on('color-change', (colorString) {
      int value = int.parse(colorString, radix: 16);
      Color otherColor = Color(value);
      setState(() {
        selectedColor = otherColor;
      });
    });

    // Chat message listener
    _socket.on('msg', (data) {
      setState(() {
        messages.add(Message.fromJson(data));
      });
      // Scroll to bottom after new message
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    });

    _socket.onDisconnect((data) {
      print('Socket disconnected');
    });

    _socket.onError((error) {
      print('Socket error: $error');
    });
  }

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    _socket.emit('msg', {
      'message': _messageController.text.trim(),
      'roomName': dataOfRoom['name'] ?? widget.data['name'],
      'username': widget.data['nickname'],
    });
    
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatScrollController.dispose();
    _socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Choose Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                // Immediately update local state
                setState(() {
                  selectedColor = color;
                });
                
                // Also emit to socket if in a room
                if (dataOfRoom['name'] != null) {
                  String colorString = color.value.toRadixString(16);
                  print('Selected color: $colorString');
                  Map map = {
                    'color': colorString,
                    'roomName': dataOfRoom['name'],
                  };
                  _socket.emit('color-change', map);
                }
                
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Canvas area
              Container(
                width: width,
                height: height * 0.40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    // Immediately add point locally for instant feedback
                    setState(() {
                      points.add(
                        TouchPoints(
                          points: details.localPosition,
                          paint: Paint()
                            ..strokeCap = strokeType
                            ..isAntiAlias = true
                            ..color = selectedColor.withOpacity(opacity)
                            ..strokeWidth = strokeWidth,
                        ),
                      );
                    });
                    // Also emit to socket for other players
                    _socket.emit('paint', {
                      'details': {
                        'dx': details.localPosition.dx,
                        'dy': details.localPosition.dy,
                      },
                      'roomName': widget.data['name'],
                    });
                  },
                  onPanStart: (details) {
                    // Immediately add point locally for instant feedback
                    setState(() {
                      points.add(
                        TouchPoints(
                          points: details.localPosition,
                          paint: Paint()
                            ..strokeCap = strokeType
                            ..isAntiAlias = true
                            ..color = selectedColor.withOpacity(opacity)
                            ..strokeWidth = strokeWidth,
                        ),
                      );
                    });
                    // Also emit to socket for other players
                    _socket.emit('paint', {
                      'details': {
                        'dx': details.localPosition.dx,
                        'dy': details.localPosition.dy,
                      },
                      'roomName': widget.data['name'],
                    });
                  },
                  onPanEnd: (details) {
                    // Add null to break the line
                    setState(() {
                      points.add(null);
                    });
                    _socket.emit('paint', {
                      'details': null,
                      'roomName': widget.data['name'],
                    });
                  },
                  child: SizedBox.expand(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: RepaintBoundary(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: MyCustomPainter(pointslist: points),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Drawing controls
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.color_lens, color: selectedColor),
                    onPressed: selectColor,
                  ),
                  Expanded(
                    child: Slider(
                      min: 1.0,
                      max: 10.0,
                      label: "Stroke Width $strokeWidth",
                      activeColor: selectedColor,
                      value: strokeWidth,
                      onChanged: (double value) {
                        setState(() {
                          strokeWidth = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.layers_clear, color: selectedColor),
                    onPressed: () {
                      setState(() {
                        points.clear();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Chat area
              Expanded(
                child: ChatWidget(
                  messages: messages,
                  messageController: _messageController,
                  onSendMessage: sendMessage,
                  scrollController: _chatScrollController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

