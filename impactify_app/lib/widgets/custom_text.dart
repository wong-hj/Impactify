import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholderText;
  final IconData? icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.placeholderText,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          labelText: placeholderText,
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.placeholder, width: 2.0))),
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
    );
  }
}

class CustomSmallIconText extends StatelessWidget {
  final String text;
  final IconData icon;

  const CustomSmallIconText({
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: AppColors.secondary,
        ),
        SizedBox(width: 3),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.placeholder,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class CustomLargeIconText extends StatelessWidget {
  final String text;
  final IconData icon;

  const CustomLargeIconText({
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),
        SizedBox(width: 3),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

