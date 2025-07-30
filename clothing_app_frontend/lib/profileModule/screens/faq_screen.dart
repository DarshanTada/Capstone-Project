import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/profileModule/screens/contact_us_screen.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  final List<Map<String, String>> faqs = const [
    {
      'question': 'How can I track my order?',
      'answer': 'You can track your order under the "Order Status" section once it is placed. You will receive real-time updates about your order status including confirmation, processing, shipped, and delivered.'
    },
    {
      'question': 'What payment methods are accepted?',
      'answer': 'We accept all major credit/debit cards (Visa, MasterCard, American Express), PayPal, Apple Pay, Google Pay, and other secure local payment gateways for your convenience.'
    },
    {
      'question': 'How do I return an item?',
      'answer': 'Go to "Order History" and choose the item you want to return, then follow the step-by-step instructions. Returns are accepted within 30 days of delivery with original packaging.'
    },
    {
      'question': 'How long does shipping take?',
      'answer': 'Standard shipping takes 3-5 business days, while express shipping takes 1-2 business days. Free shipping is available on orders over \$50.'
    },
    {
      'question': 'What sizes are available?',
      'answer': 'We offer a wide range of sizes from XS to XXL. Each product page includes a detailed size chart to help you find the perfect fit.'
    },
    {
      'question': 'Can I change or cancel my order?',
      'answer': 'You can modify or cancel your order within 30 minutes of placing it. After that, please contact our customer support team for assistance.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dW = MediaQuery.of(context).size.width;
    final dH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('FAQs', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
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
                    Icons.help_center,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Find answers to common questions about our clothing app',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // FAQ List
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
              itemCount: faqs.length,
              separatorBuilder: (_, __) => SizedBox(height: dH * 0.02),
              itemBuilder: (context, index) {
                final item = faqs[index];
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
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: dW * 0.04, vertical: 4),
                      childrenPadding: EdgeInsets.only(
                        left: dW * 0.04,
                        right: dW * 0.04,
                        bottom: dW * 0.04,
                      ),
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(0xFFD2B193).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.help_outline,
                          color: Color(0xFFB8956A),
                          size: 18,
                        ),
                      ),
                      title: Text(
                        item['question']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      iconColor: Color(0xFFB8956A),
                      collapsedIconColor: Color(0xFFB8956A),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(dW * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['answer']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
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
            // Contact Support Section
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: dW * 0.05),
              padding: EdgeInsets.all(dW * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFD2B193).withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    color: Color(0xFFB8956A),
                    size: 28,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Still Need Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Can\'t find what you\'re looking for? Our support team is here to help you 24/7.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactUsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD2B193),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Contact Support',
                      style: TextStyle(fontWeight: FontWeight.w600),
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
