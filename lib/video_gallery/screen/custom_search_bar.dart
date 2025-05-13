import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onEditingComplete;

  const CustomSearchBar({super.key, required this.controller, required this.onEditingComplete});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        hintText: 'Rechercher une vidéo...',
        hintStyle: TextStyle(color: Colors.black12),
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    onEditingComplete.call();
                  },
                )
                : null,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32), borderSide: BorderSide.none),
      ),
    );
  }
}
