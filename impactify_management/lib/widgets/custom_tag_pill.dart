import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/theming/custom_themes.dart';

class TagPills extends StatelessWidget {
  final List<User1>? tags;
  final Function(User1) onRemove;

  TagPills({required this.tags, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: tags!.map((tag) {
        return Chip(
          side: BorderSide(width: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          label: Text(
            tag.name!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          backgroundColor: AppColors.secondary,
          deleteIcon: Icon(Icons.close, size: 18, color: Colors.red),
          onDeleted: () => onRemove(tag),
        );
      }).toList(),
    );
  }
}
