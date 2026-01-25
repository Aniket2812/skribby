import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:skribby/viewmodels/game_viewmodel.dart';
import 'package:skribby/widgets/canvas/drawing_canvas.dart';
import 'package:skribby/widgets/chat/chat_widget.dart';

/// Game View - Main game screen with canvas and chat (Dark minimalistic theme)
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
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'CHOOSE COLOR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.w300,
          ),
        ),
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
            child: Text(
              'CLOSE',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                letterSpacing: 2,
              ),
            ),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Consumer<GameViewModel>(
          builder: (context, viewModel, _) => Text(
            viewModel.roomName.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              letterSpacing: 4,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Consumer<GameViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  // Canvas area
                  Container(
                    width: width,
                    height: height * 0.42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: DrawingCanvas(
                        points: viewModel.points,
                        onPanStart: (details) => viewModel.addPoint(details.localPosition),
                        onPanUpdate: (details) => viewModel.addPoint(details.localPosition),
                        onPanEnd: (_) => viewModel.endStroke(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Drawing controls
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        // Color picker
                        GestureDetector(
                          onTap: () => _selectColor(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: viewModel.selectedColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.palette_outlined,
                              color: viewModel.selectedColor.computeLuminance() > 0.5
                                  ? Colors.black.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.7),
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Stroke width slider
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                              thumbColor: Colors.white,
                              overlayColor: Colors.white.withValues(alpha: 0.1),
                              trackHeight: 2,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                            ),
                            child: Slider(
                              min: 1.0,
                              max: 10.0,
                              value: viewModel.strokeWidth,
                              onChanged: viewModel.changeStrokeWidth,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Clear button
                        GestureDetector(
                          onTap: viewModel.clearCanvas,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
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
