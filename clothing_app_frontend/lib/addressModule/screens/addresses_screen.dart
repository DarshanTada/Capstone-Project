import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
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
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Addresses', dW: dW),
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
              padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: dW * 0.05),
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
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.add, size: 22),
                          SizedBox(width: 10),
                          Text("Add New Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: dW * 0.05),
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
                  SizedBox(height: dW * 0.08),
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
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFD2BA9F) : Colors.black12,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFD2BA9F).withOpacity(0.1) : Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon, 
              size: 22,
              color: isSelected ? const Color(0xFFD2BA9F) : Colors.black54,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 15,
                              color: isSelected ? const Color(0xFFD2BA9F) : Colors.black,
                            )),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFFD2BA9F),
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(address, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(phone, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text("View on map",
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFD2BA9F) : const Color(0xFFB08C6E), 
                        fontSize: 13
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
