import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned(
        //   top: -240.0,
        //   child: ClipPath(
        //     // Crop the circle // Custom clipper
        //     child: Container(
        //       // The actual circle
        //       width: 410.0, // Adjust size as needed
        //       height: 410.0, // Adjust size as needed
        //       decoration: const BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: AppColors.tertiary, // Adjust color as needed
        //       ),
        //     ),
        //   ),
        // ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/onboard2.png"),
            const SizedBox(height: 20),
            Text("Managing Sustainability",
                style: GoogleFonts.merriweather(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Listing projects to tackle Sustainable Development Goals (SDGs).",
                style: GoogleFonts.poppins(
                    color: AppColors.primary, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
