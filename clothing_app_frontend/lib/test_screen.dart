import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addressModule/provider/address_provider.dart';
import 'checkoutModule/screens/checkout_screen.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'App is working!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
              child: const Text('Test Checkout Screen'),
            ),
            const SizedBox(height: 20),
            Consumer<AddressProvider>(
              builder: (context, addressProvider, child) {
                return Column(
                  children: [
                    Text('Loading: ${addressProvider.isLoading}'),
                    Text('Error: ${addressProvider.errorMessage ?? "None"}'),
                    Text('Addresses count: ${addressProvider.addresses.length}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
