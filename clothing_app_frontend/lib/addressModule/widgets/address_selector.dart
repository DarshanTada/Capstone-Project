import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/address_model.dart';
import '../provider/address_provider.dart';
import '../screens/address_list_screen.dart';

class AddressSelector extends StatefulWidget {
  final String? selectedAddressId;
  final Function(Address?)? onAddressSelected;
  final String title;
  final bool isRequired;

  const AddressSelector({
    Key? key,
    this.selectedAddressId,
    this.onAddressSelected,
    this.title = 'Select Address',
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<AddressSelector> createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  Address? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadSelectedAddress();
  }

  void _loadSelectedAddress() {
    if (widget.selectedAddressId != null) {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      _selectedAddress = addressProvider.getAddressById(widget.selectedAddressId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _openAddressSelection,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedAddress != null
                    ? const Color(0xFFB8956A)
                    : const Color(0xFFD2B193).withOpacity(0.5),
                width: _selectedAddress != null ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _selectedAddress != null
                ? _buildSelectedAddressContent()
                : _buildPlaceholderContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedAddressContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTypeColor(_selectedAddress!.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getTypeColor(_selectedAddress!.type),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getTypeIcon(_selectedAddress!.type),
                    size: 14,
                    color: _getTypeColor(_selectedAddress!.type),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _selectedAddress!.typeDisplayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getTypeColor(_selectedAddress!.type),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(
              Icons.edit_outlined,
              size: 16,
              color: Colors.brown.shade300,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _selectedAddress!.fullName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                _selectedAddress!.fullAddress,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholderContent() {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          color: Colors.grey.shade400,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Tap to select an address',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: 16,
        ),
      ],
    );
  }

  void _openAddressSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressListScreen(
          isSelectionMode: true,
          onAddressSelected: (addressId) {
            final addressProvider = Provider.of<AddressProvider>(context, listen: false);
            final selectedAddress = addressProvider.getAddressById(addressId);
            
            setState(() {
              _selectedAddress = selectedAddress;
            });
            
            if (widget.onAddressSelected != null) {
              widget.onAddressSelected!(selectedAddress);
            }
            
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    // Using warm brown/beige theme to match preference screen
    switch (type.toLowerCase()) {
      case 'home':
        return const Color(0xFFB8956A); // Warm brown
      case 'work':
        return const Color(0xFFD2B193); // Light beige
      case 'friend':
        return const Color(0xFFC68642); // Medium brown
      case 'other':
        return const Color(0xFF8D5524); // Darker brown
      default:
        return const Color(0xFFB8956A); // Default warm brown
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'work':
        return Icons.business_rounded;
      case 'friend':
        return Icons.people_rounded;
      case 'other':
        return Icons.place_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }
}
