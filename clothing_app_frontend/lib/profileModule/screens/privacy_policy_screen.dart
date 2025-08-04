import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  final List<Map<String, dynamic>> privacySections = const [
    {
      'icon': Icons.security,
      'title': 'Data Protection',
      'content': 'We value your privacy and are committed to protecting your personal information. All user data is encrypted using industry-standard security protocols and stored securely on our servers.',
    },
    {
      'icon': Icons.info_outline,
      'title': 'Information We Collect',
      'content': '• Personal identification information (Name, Email, Phone)\n• Device and usage information\n• Purchase history and preferences\n• Location data (with your permission)\n• App usage analytics',
    },
    {
      'icon': Icons.settings,
      'title': 'How We Use Your Data',
      'content': '• Improve user experience and app functionality\n• Process transactions and deliver orders\n• Send important updates and notifications\n• Provide customer support\n• Analyze usage patterns to enhance our services',
    },
    {
      'icon': Icons.share,
      'title': 'Data Sharing',
      'content': 'We do not sell, trade, or share your personal information with third parties without your explicit consent, except when required by law or to provide essential services.',
    },
    {
      'icon': Icons.vpn_key,
      'title': 'Your Rights',
      'content': '• Access your personal data\n• Correct inaccurate information\n• Request data deletion\n• Opt-out of marketing communications\n• Export your data',
    },
    {
      'icon': Icons.contact_support,
      'title': 'Contact Us',
      'content': 'If you have questions about this privacy policy or your data, please contact our privacy team at privacy@yolochic.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dW = MediaQuery.of(context).size.width;
    final dH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.brown.shade300),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(dW * 0.05),
              padding: EdgeInsets.all(dW * 0.06),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.shade200,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your privacy matters to us. Learn how we protect and use your information.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Last Updated Info
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: dW * 0.05),
              padding: EdgeInsets.all(dW * 0.04),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: Colors.blue.shade600, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Last updated: January 2025',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: dH * 0.02),
            // Privacy Policy Sections
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
              itemCount: privacySections.length,
              separatorBuilder: (_, __) => SizedBox(height: dH * 0.02),
              itemBuilder: (context, index) {
                final section = privacySections[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(dW * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xFFD2B193).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                section['icon'],
                                color: Color(0xFFB8956A),
                                size: 22,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                section['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(dW * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            section['content'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: dH * 0.03),
            // Agreement Section
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: dW * 0.05),
              padding: EdgeInsets.all(dW * 0.05),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD2B193).withOpacity(0.1), Color(0xFFB8956A).withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFD2B193).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFFB8956A),
                    size: 28,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Agreement',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'By using YOLO Chic app, you acknowledge that you have read, understood, and agree to be bound by this Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: dH * 0.03),
          ],
        ),
      ),
    );
  }
}
