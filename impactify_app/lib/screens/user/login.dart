import 'package:flutter/material.dart';
import 'package:impactify_app/screens/user/home_screen.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';

class Login extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _passController = TextEditingController();


  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background,),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: 
            
            Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Glad to see you again, stay impactful!", style: AppTextStyles.authHead),
                const SizedBox(height: 50),
        
                CustomTextField(
                  controller: _controller,
                  placeholderText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passController,
                  placeholderText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                const SizedBox(height: 40),
                CustomAuthButton(onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                }, text: "Login"),
                const SizedBox(height: 50),
                const Text("or", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(onPressed: () {}, imagePath: "assets/google.png"),
                    const SizedBox(width: 20),
                    CustomIconButton(onPressed: () {}, imagePath: "assets/facebook.png"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
