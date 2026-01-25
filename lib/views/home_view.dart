import 'package:flutter/material.dart';
import 'package:skribby/views/create_room_view.dart';
import 'package:skribby/views/join_room_view.dart';

/// Home View - Simple minimalistic dark design
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Logo icon
              Icon(
                Icons.brush_rounded,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              
              // App name
              const Text(
                'SKRIBBY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 12,
                ),
              ),
              const SizedBox(height: 16),
              
              // Tagline
              Text(
                'Art skills optional. Fun mandatory.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w300,
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  children: [
                    _MinimalButton(
                      text: 'CREATE',
                      filled: true,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateRoomView(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _MinimalButton(
                      text: 'JOIN',
                      filled: false,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const JoinRoomView(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Made with ❤️ by Aniket.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple minimal button
class _MinimalButton extends StatelessWidget {
  final String text;
  final bool filled;
  final VoidCallback onPressed;

  const _MinimalButton({
    required this.text,
    required this.filled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? Colors.white : Colors.transparent,
          side: BorderSide(
            color: Colors.white,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: filled ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }
}
