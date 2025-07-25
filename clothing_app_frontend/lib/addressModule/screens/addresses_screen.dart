import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../authModule/providers/auth_provider.dart';
import '../../common_functions.dart';
import './add_address_screen.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  String selectedAddressId = 'home'; // Track selected address - default to first one

  fetchData() async {}

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    customTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'My Addresses',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.brown.shade300),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Colors.brown.shade300),
            onPressed: () {
              // Add edit functionality
            },
          ),
        ],
      ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  Widget screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: dH * 0.02),
                  // Add New Address Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddAddressScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: dH * 0.018, 
                        horizontal: dW * 0.04
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFB8956A).withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add, 
                              size: 20, 
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Add New Address", 
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: dH * 0.025),
                  Text(
                    'Saved Addresses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: dH * 0.015),
                  addressCard(
                    id: 'home',
                    icon: Icons.home_outlined,
                    title: 'Home',
                    address: '108, University Ave, Waterloo,\nCanada N2J 2W2',
                    phone: '+1 (902) 564 8888',
                  ),
                  addressCard(
                    id: 'work',
                    icon: Icons.work_outline,
                    title: 'Work',
                    address: '108, University Ave, Waterloo,\nCanada N2J 2W2',
                    phone: '+1 (111) 256 8888',
                  ),
                  addressCard(
                    id: 'andy',
                    icon: Icons.person_pin_circle_outlined,
                    title: 'Andys House',
                    address: '108, University Ave, Waterloo,\nCanada N2J 2W2',
                    phone: '+1 (902) 254 8888',
                  ),
                  addressCard(
                    id: 'mandy',
                    icon: Icons.person_pin_circle_outlined,
                    title: 'Mandys house',
                    address: '108, University Ave, Waterloo,\nCanada N2J 2W2',
                    phone: '+1 (902) 254 8888',
                  ),
                  SizedBox(height: dH * 0.08),
                ],
              ),
            ),
    );
  }

  Widget addressCard({
    required String id,
    required IconData icon,
    required String title,
    required String address,
    required String phone,
  }) {
    final bool isSelected = selectedAddressId == id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddressId = id;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: dH * 0.015),
        padding: EdgeInsets.all(dW * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xFFD2B193) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                ? Color(0xFFD2B193).withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 15 : 8,
              offset: Offset(0, isSelected ? 6 : 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? Color(0xFFD2B193).withOpacity(0.2)
                      : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                        ? Color(0xFFD2B193)
                        : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon, 
                    size: 24,
                    color: isSelected ? Color(0xFFB8956A) : Colors.grey.shade600,
                  ),
                ),
                SizedBox(width: dW * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600, 
                                fontSize: 16,
                                color: isSelected ? Color(0xFFB8956A) : Colors.black87,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Color(0xFFD2B193),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: dH * 0.008),
                      Text(
                        address, 
                        style: TextStyle(
                          color: Colors.grey.shade700, 
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: dH * 0.006),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 6),
                          Text(
                            phone, 
                            style: TextStyle(
                              color: Colors.grey.shade700, 
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: dH * 0.015),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: dH * 0.012),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 16,
                          color: Color(0xFFB8956A),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "View on Map",
                          style: TextStyle(
                            color: Color(0xFFB8956A),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: dW * 0.03),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: dH * 0.012),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
