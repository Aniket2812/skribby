import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skribby/viewmodels/create_room_viewmodel.dart';
import 'package:skribby/views/game_view.dart';

/// Create Room View - Minimalistic dark design
class CreateRoomView extends StatelessWidget {
  const CreateRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateRoomViewModel(),
      child: const _CreateRoomViewContent(),
    );
  }
}

class _CreateRoomViewContent extends StatefulWidget {
  const _CreateRoomViewContent();

  @override
  State<_CreateRoomViewContent> createState() => _CreateRoomViewContentState();
}

class _CreateRoomViewContentState extends State<_CreateRoomViewContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roomNameController.dispose();
    super.dispose();
  }

  void _createRoom() {
    final viewModel = context.read<CreateRoomViewModel>();
    viewModel.setNickname(_nameController.text);
    viewModel.setRoomName(_roomNameController.text);

    if (viewModel.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GameView(
            data: viewModel.getRoomData(),
            screenFrom: 'createRoom',
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
        child: Consumer<CreateRoomViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  
                  // Title
                  const Text(
                    'CREATE\nROOM',
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
                  const SizedBox(height: 32),
                  
                  // Dropdowns row
                  Row(
                    children: [
                      Expanded(
                        child: _MinimalDropdown(
                          label: 'ROUNDS',
                          value: viewModel.maxRounds,
                          items: viewModel.maxRoundsOptions,
                          onChanged: viewModel.setMaxRounds,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _MinimalDropdown(
                          label: 'PLAYERS',
                          value: viewModel.roomSize,
                          items: viewModel.roomSizeOptions,
                          onChanged: viewModel.setRoomSize,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  
                  // Create button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _createRoom,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Text(
                        'CREATE',
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

/// Minimal dropdown for dark theme
class _MinimalDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const _MinimalDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
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
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: const Color(0xFF1A1A1A),
            underline: const SizedBox(),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            hint: Text(
              'Select',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 16,
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 1,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
