import 'package:flutter/material.dart';
import '../services/cart_api_service.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final CartApiService _cartApiService = CartApiService();

  CartModel? _cart;
  bool _isLoading = false;
  String? _error;

  CartModel? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<CartItem> get cartItems => _cart?.items ?? [];
  double get subTotalAmount => _cart?.subTotalAmount ?? 0.0;
  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> getCart(String userId) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _cartApiService.getCart(userId);

      if (result['success'] == true) {
        if (result['data'] != null) {
          _cart = CartModel.fromJson(result['data']);
        } else {
          // Empty cart
          _cart = CartModel(user: userId, items: [], subTotalAmount: 0.0);
        }
      } else {
        throw Exception(result['message'] ?? 'Failed to get cart');
      }
    } catch (e) {
      print('Error getting cart: $e');
      _setError(e.toString());
      // Create empty cart on error
      _cart = CartModel(user: userId, items: [], subTotalAmount: 0.0);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addToCart(String userId, String variantId, int quantity) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _cartApiService.addToCart(
        userId,
        variantId,
        quantity,
      );

      if (result['success'] == true) {
        _cart = CartModel.fromJson(result['data']);
        return true;
      } else {
        throw Exception(result['message'] ?? 'Failed to add to cart');
      }
    } catch (e) {
      print('Error adding to cart: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateQuantity(
    String userId,
    String variantId,
    int quantity,
  ) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _cartApiService.updateQuantity(
        userId,
        variantId,
        quantity,
      );

      if (result['success'] == true) {
        _cart = CartModel.fromJson(result['data']);
        return true;
      } else {
        throw Exception(result['message'] ?? 'Failed to update quantity');
      }
    } catch (e) {
      print('Error updating quantity: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> removeFromCart(String userId, String variantId) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _cartApiService.removeFromCart(userId, variantId);

      if (result['success'] == true) {
        // Refresh cart after removal
        await getCart(userId);
        return true;
      } else {
        throw Exception(result['message'] ?? 'Failed to remove from cart');
      }
    } catch (e) {
      print('Error removing from cart: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> clearCart(String userId) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _cartApiService.clearCart(userId);

      if (result['success'] == true) {
        _cart = CartModel(user: userId, items: [], subTotalAmount: 0.0);
        return true;
      } else {
        throw Exception(result['message'] ?? 'Failed to clear cart');
      }
    } catch (e) {
      print('Error clearing cart: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }
}
