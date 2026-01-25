import 'package:flutter/material.dart';

/// Custom elevated button with consistent styling
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ?? Colors.blue,
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(color: Colors.white),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(width ?? MediaQuery.of(context).size.width / 2.5, height),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
