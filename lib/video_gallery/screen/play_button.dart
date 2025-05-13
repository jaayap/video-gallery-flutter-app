import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
    );
  }
}
