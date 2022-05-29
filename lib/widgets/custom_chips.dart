import 'package:flutter/material.dart';

import '../configs/constants.dart';

/// Custom chip for the note label
class CustomChips extends StatelessWidget {
  const CustomChips({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      labelStyle: TextStyle(
        fontWeight:TextFontWeight.bold,
      ),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}