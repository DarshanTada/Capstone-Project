import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/address_provider.dart';
import '../widgets/address_card.dart';
import 'add_edit_address_screen.dart';
import '../../authModule/providers/auth_provider.dart';

class AddressListScreen extends StatefulWidget {
  final bool isSelectionMode;
  final Function(String)? onAddressSelected;

  const AddressListScreen({
    super.key,
    this.isSelectionMode = false,
    this.onAddressSelected,
  });

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  String? selectedAddressId;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Get user ID from AuthProvider
    final user = authProvider.user;
    if (user.id == null || user.id!.isEmpty) {
      print('❌ No user ID found in AuthProvider');
      return;
    }

    final userId = user.id!;
    print('👤 Loading addresses for user ID: $userId');

    await addressProvider.getAddressesByUserId(
      context: context,
      userId: userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.isSelectionMode ? 'Select Address' : 'My Addresses',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB8956A),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _navigateToAddAddress(),
            tooltip: 'Add New Address',
          ),
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (addressProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      addressProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      addressProvider.clearError();
                      _loadAddresses();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8956A),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (addressProvider.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Addresses Found',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first address to get started',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToAddAddress(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8956A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Address'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadAddresses,
            child: Column(
              children: [
                // Add instruction text when in selection mode
                if (widget.isSelectionMode) ...[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFD2B193).withOpacity(0.1),
                          const Color(0xFFB8956A).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD2B193).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8956A).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Color(0xFFB8956A),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Select an address or add a new one. You can also edit existing addresses.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8D5524),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Address list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: addressProvider.addresses.length,
                    itemBuilder: (context, index) {
                      final address = addressProvider.addresses[index];
                      final isSelected = selectedAddressId == address.id;

                      return AddressCard(
                        address: address,
                        isSelected: isSelected,
                        showActions: true, // Always show edit/delete actions
                        isSelectionMode: widget.isSelectionMode,
                        onSelect: widget.isSelectionMode
                            ? () {
                                setState(() {
                                  selectedAddressId = address.id;
                                });
                                if (widget.onAddressSelected != null &&
                                    address.id != null) {
                                  widget.onAddressSelected!(address.id!);
                                }
                              }
                            : null,
                        onEdit: () => _navigateToEditAddress(address),
                        onDelete: () => _showDeleteConfirmation(address),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddAddress(),
        backgroundColor: const Color(0xFFB8956A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToAddAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditAddressScreen()),
    ).then((_) => _loadAddresses());
  }

  void _navigateToEditAddress(address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(address: address),
      ),
    ).then((_) => _loadAddresses());
  }

  void _showDeleteConfirmation(address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete this address?\n\n${address.fullName}\n${address.fullAddress}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteAddress(address.id!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAddress(String addressId) async {
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    await addressProvider.deleteAddress(context: context, addressId: addressId);
  }
}
