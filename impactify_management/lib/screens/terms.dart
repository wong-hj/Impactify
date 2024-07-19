import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/theming/custom_themes.dart';

class Terms extends StatelessWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title:
                Text("Terms and Condition", style: GoogleFonts.merriweather())),
        body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                'Welcome to Impactify! These Terms and Conditions ("Terms") govern your use of the Impactify application ("App"). By accessing or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use the App.',
                style: GoogleFonts.nunito(fontSize: 16),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('1. Use of the App'),
              _buildSubsectionTitle('1.1 Eligibility'),
              _buildSubsectionContent(
                  'You must be at least 18 years old to use this App. By using the App, you represent and warrant that you are at least 18 years old.'),
              _buildSubsectionTitle('1.2 Account Registration'),
              _buildSubsectionContent(
                  'To access certain features of the App, you may need to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information as necessary to keep it accurate, current, and complete.'),
              _buildSubsectionTitle('1.3 Account Security'),
              _buildSubsectionContent(
                  'You are responsible for safeguarding your password and any other credentials used to access your account. You agree to notify us immediately of any unauthorized use of your account.'),
              SizedBox(height: 20),
              _buildSectionTitle('2. User Conduct'),
              _buildSubsectionTitle('2.1 Prohibited Activities'),
              _buildSubsectionContent(
                  'You agree not to engage in any of the following prohibited activities:'),
              _buildBulletPoint(
                  'Violating any applicable laws or regulations.'),
              _buildBulletPoint(
                  'Posting or transmitting content that is illegal, harmful, defamatory, obscene, or otherwise objectionable.'),
              _buildBulletPoint(
                  'Interfering with the operation of the App or any user’s enjoyment of the App.'),
              _buildBulletPoint(
                  'Attempting to gain unauthorized access to any part of the App or other user accounts.'),
              _buildSubsectionTitle('2.2 Content Standards'),
              _buildSubsectionContent(
                  'All content you submit or upload to the App must comply with our content standards, which prohibit illegal, harmful, or offensive material.'),
              SizedBox(height: 20),
              _buildSectionTitle('3. Privacy'),
              _buildSubsectionContent(
                  'Our Privacy Policy describes how we handle the information you provide to us when you use our App. By using the App, you consent to the collection, use, and disclosure of your information as described in our Privacy Policy.'),
              SizedBox(height: 20),
              _buildSectionTitle('4. Intellectual Property'),
              _buildSubsectionTitle('4.1 Ownership'),
              _buildSubsectionContent(
                  'The App and its entire contents, features, and functionality are owned by us, our licensors, or other providers of such material and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.'),
              _buildSubsectionTitle('4.2 License'),
              _buildSubsectionContent(
                  'We grant you a limited, non-exclusive, non-transferable, and revocable license to use the App for your personal, non-commercial use.'),
              SizedBox(height: 20),
              _buildSectionTitle('5. Disclaimers and Limitation of Liability'),
              _buildSubsectionTitle('5.1 Disclaimers'),
              _buildSubsectionContent(
                  'The App is provided on an "as-is" and "as-available" basis. We make no representations or warranties of any kind, express or implied, as to the operation of the App or the information, content, or materials included on the App.'),
              _buildSubsectionTitle('5.2 Limitation of Liability'),
              _buildSubsectionContent(
                  'To the fullest extent permitted by law, we shall not be liable for any damages of any kind arising from the use of the App, including but not limited to direct, indirect, incidental, punitive, and consequential damages.'),
              SizedBox(height: 20),
              _buildSectionTitle('6. Indemnification'),
              _buildSubsectionContent(
                  'You agree to indemnify, defend, and hold harmless us, our affiliates, and our respective officers, directors, employees, and agents from and against any claims, liabilities, damages, judgments, awards, losses, costs, expenses, or fees arising out of or relating to your violation of these Terms or your use of the App.'),
              SizedBox(height: 20),
              _buildSectionTitle('7. Changes to Terms'),
              _buildSubsectionContent(
                  'We reserve the right to modify these Terms at any time. Your continued use of the App following the posting of changes constitutes your acceptance of such changes.'),
            ],
          ),
        ))));
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.merriweather(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        title,
        style: GoogleFonts.merriweather(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubsectionContent(String content) {
    return Text(
      content,
      style: GoogleFonts.poppins(fontSize: 11),
    );
  }

  Widget _buildBulletPoint(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: GoogleFonts.poppins(fontSize: 10)),
          Expanded(
            child: Text(content, style: GoogleFonts.poppins(fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
