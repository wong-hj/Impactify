import 'package:flutter/material.dart';
import 'package:impactify_app/widgets/custom_text.dart';

class Login extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Login({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0.0,
        title: const Text('Custom TextField Example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _controller,
                placeholderText: 'Email Address',
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  // Handle text field changes
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Example action on button press
                  print(_controller.text);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}