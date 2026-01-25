import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skribby/core/utils/slide_page_route.dart';
import 'package:skribby/viewmodels/join_room_viewmodel.dart';
import 'package:skribby/views/game_view.dart';

/// Join Room View - Minimalistic dark design
class JoinRoomView extends StatelessWidget {
  const JoinRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JoinRoomViewModel(),
      child: const _JoinRoomViewContent(),
    );
  }
}

class _JoinRoomViewContent extends StatefulWidget {
  const _JoinRoomViewContent();

  @override
  State<_JoinRoomViewContent> createState() => _JoinRoomViewContentState();
}

class _JoinRoomViewContentState extends State<_JoinRoomViewContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roomNameController.dispose();
    super.dispose();
  }

  void _joinRoom() {
    final viewModel = context.read<JoinRoomViewModel>();
    viewModel.setNickname(_nameController.text);
    viewModel.setRoomName(_roomNameController.text);

    if (viewModel.validate()) {
      Navigator.of(context).push(
        SlidePageRoute(
          page: GameView(
            data: viewModel.getRoomData(),
            screenFrom: 'joinRoom',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Consumer<JoinRoomViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  
                  // Title
                  const Text(
                    'JOIN\nROOM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Error message
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  
                  // Name input
                  _MinimalTextField(
                    controller: _nameController,
                    label: 'YOUR NAME',
                  ),
                  const SizedBox(height: 24),
                  
                  // Room name input
                  _MinimalTextField(
                    controller: _roomNameController,
                    label: 'ROOM NAME',
                  ),
                  const SizedBox(height: 48),
                  
                  // Join button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _joinRoom,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Text(
                        'JOIN',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Minimal text field for dark theme
class _MinimalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _MinimalTextField({
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 1,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
