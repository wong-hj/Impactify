import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/theming/custom_themes.dart';

class CustomLoading extends StatelessWidget {
  final String text;

  const CustomLoading({
    required this.text,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitWanderingCubes(
          color: AppColors.primary,
          size: 60.0,
        ),
        SizedBox(height: 20),
        Text(text,
            style: GoogleFonts.merriweather(color: AppColors.primary, fontSize: 20))
      ],
    );
  }
}