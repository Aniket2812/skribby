import 'package:flutter/material.dart';
import 'package:skribby/paint_screen.dart';
import 'package:skribby/widgets/custom_text_field.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  late String? _maxRoundsValue;
  late String? _roomSizeValue;

  void createRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty &&
        _maxRoundsValue != null &&
        _roomSizeValue != null) {
          Map<String, String> data = {
            "nickname": _nameController.text,
            "name": _roomNameController.text,
            "occupancy": _roomSizeValue!,
            "maxRounds": _maxRoundsValue!,
          };
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaintScreen(data: data, screenFrom: 'createRoom')));
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Create Room",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: _nameController,
              hintText: "Enter your name",
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: _roomNameController,
              hintText: "Enter room name",
            ),
          ),
          SizedBox(height: 20),
          DropdownButton<String>(
            focusColor: Color(0xffF5F6FA),
            items: <String>["2", "5", "10", "15"]
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem(
                    value: value,
                    child: new Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            hint: Text(
              "Select Max Rounds",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                _maxRoundsValue = value;
              });
            },
          ),
          SizedBox(height: 20),
          DropdownButton<String>(
            focusColor: Color(0xffF5F6FA),
            items: <String>["2", "3", "4", "5", "6", "7", "8"]
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem(
                    value: value,
                    child: new Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            hint: Text(
              "Select Room Size",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                _roomSizeValue = value;
              });
            },
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: createRoom,
            child: const Text(
              "Create",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              textStyle: MaterialStateProperty.all(
                TextStyle(color: Colors.white),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
