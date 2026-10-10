import 'package:flutter/material.dart';
import '../app/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onFilterTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const CustomSearchBar({
    Key? key,
    required this.isOpen,
    required this.onFilterTap,
    this.controller,
    this.onChanged,
    this.hintText = 'Search organizations, users...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), // Pill shape
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.black54, size: 24),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.tune, color: Colors.black54, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
