import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  bool nearMe = false;

  void _toggle() {
    setState(() {
      nearMe = !nearMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Start your ',
                      style: GoogleFonts.nunito(fontSize: 24),
                    ),
                    TextSpan(
                      text: 'Impactful ',
                      style: GoogleFonts.nunito(
                          fontSize: 24,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text: 'Journey By...',
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                        )),
                  ],
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: _toggle,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: nearMe ? AppColors.tertiary : Colors.white,
                        border: Border.all(
                            color: nearMe ? AppColors.tertiary : Colors.black),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            nearMe ? Icons.location_on_outlined : Icons.location_off_outlined,
                            size: 18,
                            color: nearMe ? Colors.black : AppColors.primary,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Near Me',
                            style: TextStyle(
                              fontSize: 14,
                              color: nearMe ? Colors.black : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              // Search Bar
              TextField(
                onChanged: (text) {
                  // Perform action when text changes
                  print('Text changed to: $text');
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: AppColors.tertiary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Filtering Pills
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterChip(
                    label: Text('All',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    onSelected: (bool value) {},
                    selected: true,
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primary,
                  ),
                  FilterChip(
                    label: Text('Projects'),
                    onSelected: (bool value) {},
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.green,
                  ),
                  FilterChip(
                    label: Text('Speech'),
                    onSelected: (bool value) {},
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
