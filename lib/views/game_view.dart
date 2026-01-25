import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:skribby/viewmodels/game_viewmodel.dart';
import 'package:skribby/widgets/canvas/drawing_canvas.dart';
import 'package:skribby/widgets/chat/chat_widget.dart';

/// Game View - Main game screen with canvas and chat
class GameView extends StatelessWidget {
  final Map<String, String> data;
  final String screenFrom;

  const GameView({
    super.key,
    required this.data,
    required this.screenFrom,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameViewModel(
        roomData: data,
        screenFrom: screenFrom,
      ),
      child: const _GameViewContent(),
    );
  }
}

class _GameViewContent extends StatefulWidget {
  const _GameViewContent();

  @override
  State<_GameViewContent> createState() => _GameViewContentState();
}

class _GameViewContentState extends State<_GameViewContent> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _selectColor(BuildContext context) {
    final viewModel = context.read<GameViewModel>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: viewModel.selectedColor,
            onColorChanged: (color) {
              viewModel.changeColor(color);
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final viewModel = context.read<GameViewModel>();
    viewModel.sendMessage(_messageController.text);
    _messageController.clear();
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<GameViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  // Canvas area
                  Container(
                    width: width,
                    height: height * 0.44,
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
                    child: DrawingCanvas(
                      points: viewModel.points,
                      onPanStart: (details) => viewModel.addPoint(details.localPosition),
                      onPanUpdate: (details) => viewModel.addPoint(details.localPosition),
                      onPanEnd: (_) => viewModel.endStroke(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Drawing controls
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.color_lens, color: viewModel.selectedColor),
                        onPressed: () => _selectColor(context),
                      ),
                      Expanded(
                        child: Slider(
                          min: 1.0,
                          max: 10.0,
                          label: "Stroke Width ${viewModel.strokeWidth}",
                          activeColor: viewModel.selectedColor,
                          value: viewModel.strokeWidth,
                          onChanged: viewModel.changeStrokeWidth,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.layers_clear, color: viewModel.selectedColor),
                        onPressed: viewModel.clearCanvas,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Chat area
                  Expanded(
                    child: ChatWidget(
                      messages: viewModel.messages,
                      messageController: _messageController,
                      onSendMessage: _sendMessage,
                      scrollController: _chatScrollController,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
