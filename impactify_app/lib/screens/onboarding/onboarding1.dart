import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -200.0, // Top left corner
          left: -200.0,
          child: ClipPath(  // Crop the circle // Custom clipper
            child: Container(  // The actual circle
              width: 400.0,  // Adjust size as needed
              height: 400.0,  // Adjust size as needed
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,  // Adjust color as needed
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/onboard1.png"),
            const SizedBox(height: 20),
            Text("Connecting People",
                style: GoogleFonts.nunito(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Create a platform to foster effective engagement between people with same interest.",
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
