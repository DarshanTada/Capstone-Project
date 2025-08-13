import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/address_model.dart';
import '../provider/address_provider.dart';
import '../../authModule/providers/auth_provider.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address; // Null for add, populated for edit

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();

  String _selectedType = 'home';
  String _selectedProvince = 'Ontario';
  String? _selectedCity;
  bool _isLoading = false;

  bool get isEditMode => widget.address != null;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (isEditMode) {
      final address = widget.address!;
      _fullNameController.text = address.fullName;
      _houseNumberController.text = address.houseNumber;
      _addressController.text = address.address;
      _selectedCity = address.city;
      _zipController.text = address.zip;
      _selectedType = address.type;
      _selectedProvince = address.province;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _houseNumberController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Address' : 'Add New Address',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.brown.shade300),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Type Selection
              _buildSectionTitle('Address Type'),
              _buildTypeSelector(),

              const SizedBox(height: 24),

              // Personal Information
              _buildSectionTitle('Personal Information'),
              _buildTextField(
                controller: _fullNameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Address Information
              _buildSectionTitle('Address Information'),
              _buildTextField(
                controller: _houseNumberController,
                label: 'House/Unit Number',
                hint: 'e.g., 123, Apt 4B',
                icon: Icons.home_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter house/unit number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _addressController,
                label: 'Street Address',
                hint: 'Enter street address',
                icon: Icons.location_on_outlined,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter street address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildCitySelector(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _zipController,
                      label: 'Postal Code',
                      hint: 'K1A 0A6',
                      icon: Icons.pin_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        // Basic Canadian postal code validation
                        final postalRegex = RegExp(
                          r'^[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d$',
                        );
                        if (!postalRegex.hasMatch(value.trim())) {
                          return 'Invalid format';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildProvinceSelector(),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade300,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          isEditMode ? 'Update Address' : 'Save Address',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: AddressConstants.addressTypes.map((type) {
          final isSelected = _selectedType == type;
          return InkWell(
            onTap: () => setState(() => _selectedType = type),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: type != AddressConstants.addressTypes.last
                      ? BorderSide(color: Colors.grey.shade200)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getTypeIcon(type),
                    color: isSelected ? Colors.brown.shade300 : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AddressConstants.getTypeDisplayName(type),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.brown.shade700
                            : Colors.black87,
                      ),
                    ),
                  ),
                  Radio<String>(
                    value: type,
                    groupValue: _selectedType,
                    onChanged: (value) =>
                        setState(() => _selectedType = value!),
                    activeColor: Colors.brown.shade300,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.brown.shade300),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.brown.shade300, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildCitySelector() {
    final cities = AddressConstants.getCitiesForProvince(_selectedProvince);
    
    return DropdownButtonFormField<String>(
      value: _selectedCity != null && cities.contains(_selectedCity) ? _selectedCity : null,
      decoration: InputDecoration(
        labelText: 'City',
        prefixIcon: Icon(Icons.location_city_outlined, color: Colors.brown.shade300),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.brown.shade300, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: cities.map((city) {
        return DropdownMenuItem(value: city, child: Text(city));
      }).toList(),
      onChanged: (value) => setState(() => _selectedCity = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a city';
        }
        return null;
      },
    );
  }

  Widget _buildProvinceSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedProvince,
      decoration: InputDecoration(
        labelText: 'Province/Territory',
        prefixIcon: Icon(Icons.map_outlined, color: Colors.brown.shade300),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.brown.shade300, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: AddressConstants.provinces.map((province) {
        return DropdownMenuItem(value: province, child: Text(province));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedProvince = value!;
          // Reset city when province changes to prevent misalignment
          _selectedCity = null;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a province';
        }
        return null;
      },
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.work_outline;
      case 'friend':
        return Icons.people_outline;
      case 'other':
        return Icons.location_on_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Get user ID from AuthProvider
      final user = authProvider.user;
      if (user.id == null || user.id!.isEmpty) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please login to save address'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final userId = user.id!;
      print('👤 Saving address for user ID: $userId');

      final address = Address(
        id: isEditMode ? widget.address!.id : null,
        type: _selectedType,
        fullName: _fullNameController.text.trim(),
        houseNumber: _houseNumberController.text.trim(),
        address: _addressController.text.trim(),
        city: _selectedCity ?? '',
        zip: _zipController.text.trim().toUpperCase(),
        province: _selectedProvince,
        userId: userId,
      );

      Map<String, dynamic> result;

      if (isEditMode) {
        result = await addressProvider.updateAddress(
          context: context,
          addressId: widget.address!.id!,
          updatedAddress: address,
        );
      } else {
        result = await addressProvider.addAddress(
          context: context,
          address: address,
        );
      }

      if (result['success'] == true && mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
