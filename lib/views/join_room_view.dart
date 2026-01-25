import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skribby/viewmodels/join_room_viewmodel.dart';
import 'package:skribby/views/game_view.dart';
import 'package:skribby/widgets/common/custom_text_field.dart';

/// Join Room View
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
        MaterialPageRoute(
          builder: (context) => GameView(
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
      body: Consumer<JoinRoomViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Join Room",
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              
              // Error message
              if (viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              
              // Name input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: _nameController,
                  hintText: "Enter your name",
                ),
              ),
              const SizedBox(height: 20),
              
              // Room name input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: _roomNameController,
                  hintText: "Enter room name",
                ),
              ),
              const SizedBox(height: 40),
              
              // Join button
              ElevatedButton(
                onPressed: _joinRoom,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  textStyle: WidgetStateProperty.all(
                    const TextStyle(color: Colors.white),
                  ),
                  minimumSize: WidgetStateProperty.all(
                    Size(MediaQuery.of(context).size.width / 2.5, 50),
                  ),
                ),
                child: const Text(
                  "Join",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
