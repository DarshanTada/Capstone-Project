import 'package:flutter/material.dart';
import '../../api.dart';
import '../../http_helper.dart';
import '../model/address_model.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Clear error message
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Set error message
  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Add new address
  Future<Map<String, dynamic>> addAddress({
    required BuildContext context,
    required Address address,
  }) async {
    try {
      _setLoading(true);
      clearError();

      final url = '${webApi['domain']}${endPoint['addAddress']}';

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: address.toJson(),
      );

      if (response['success'] == true) {
        // Add the new address to local list
        final newAddress = Address.fromJson(response['data']);
        _addresses.add(newAddress);
        _isLoading = false;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Address added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _setError(response['message'] ?? 'Failed to add address');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      return response;
    } catch (error) {
      _setError('Unexpected error occurred: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return {'success': false, 'message': 'Unexpected error occurred'};
    }
  }

  // Get all addresses by user ID
  Future<Map<String, dynamic>> getAddressesByUserId({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      _setLoading(true);
      clearError();

      final url = '${webApi['domain']}${endPoint['getAddressesByUserId']}';

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {'userId': userId},
      );

      if (response['success'] == true && response['data'] is List) {
        try {
          List<Address> fetchedAddresses = (response['data'] as List)
              .map((addressJson) {
                print('Parsing address JSON: $addressJson');
                return Address.fromJson(Map<String, dynamic>.from(addressJson));
              })
              .toList();

          _addresses = fetchedAddresses;
          _setLoading(false);
        } catch (e) {
          print('Error parsing addresses: $e');
          _setError('Error parsing address data: $e');
        }
      } else {
        print('API response: $response');
        _setError(response['message']?.toString() ?? 'Failed to fetch addresses');
      }

      return response;
    } catch (error) {
      _setError('Unexpected error occurred: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return {'success': false, 'message': 'Unexpected error occurred'};
    }
  }

  // Update existing address
  Future<Map<String, dynamic>> updateAddress({
    required BuildContext context,
    required String addressId,
    required Address updatedAddress,
  }) async {
    try {
      _setLoading(true);
      clearError();

      final url = '${webApi['domain']}${endPoint['updateAddress']}';

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {
          'addressId': addressId,
          ...updatedAddress.toJson(),
        },
      );

      if (response['success'] == true) {
        // Update the address in local list
        final index = _addresses.indexWhere((addr) => addr.id == addressId);
        if (index != -1) {
          _addresses[index] = updatedAddress.copyWith(id: addressId);
        }
        _isLoading = false;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Address updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _setError(response['message'] ?? 'Failed to update address');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      return response;
    } catch (error) {
      _setError('Unexpected error occurred: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return {'success': false, 'message': 'Unexpected error occurred'};
    }
  }

  // Delete address
  Future<Map<String, dynamic>> deleteAddress({
    required BuildContext context,
    required String addressId,
  }) async {
    try {
      _setLoading(true);
      clearError();

      final url = '${webApi['domain']}${endPoint['deleteAddress']}';

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {'addressId': addressId},
      );

      if (response['success'] == true) {
        // Remove the address from local list
        _addresses.removeWhere((addr) => addr.id == addressId);
        _isLoading = false;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Address deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _setError(response['message'] ?? 'Failed to delete address');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      return response;
    } catch (error) {
      _setError('Unexpected error occurred: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return {'success': false, 'message': 'Unexpected error occurred'};
    }
  }

  // Get address by ID
  Address? getAddressById(String id) {
    try {
      return _addresses.firstWhere((addr) => addr.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get addresses by type
  List<Address> getAddressesByType(String type) {
    return _addresses.where((addr) => addr.type.toLowerCase() == type.toLowerCase()).toList();
  }

  // Clear all addresses
  void clearAddresses() {
    _addresses.clear();
    notifyListeners();
  }
}
