import 'package:flutter/foundation.dart';
import '../services/order_api_service.dart';

class OrderProvider extends ChangeNotifier {
  bool _isCreatingOrder = false;
  bool _isLoadingOrders = false;
  Map<String, dynamic>? _lastCreatedOrder;
  List<dynamic> _userOrders = [];
  int _currentPage = 1;
  bool _hasMoreOrders = true;
  String? _error;

  bool get isCreatingOrder => _isCreatingOrder;
  bool get isLoadingOrders => _isLoadingOrders;
  Map<String, dynamic>? get lastCreatedOrder => _lastCreatedOrder;
  List<dynamic> get userOrders => _userOrders;
  int get currentPage => _currentPage;
  bool get hasMoreOrders => _hasMoreOrders;
  String? get error => _error;

  // Create order
  Future<bool> createOrder({
    required List<Map<String, dynamic>> products,
    required String userId,
    required String addressId,
    required String paymentMethod,
  }) async {
    try {
      _isCreatingOrder = true;
      _error = null;
      notifyListeners();

      print('🛒 OrderProvider: Creating order...');

      final response = await OrderApiService.createOrder(
        products: products,
        userId: userId,
        addressId: addressId,
        paymentMethod: paymentMethod,
      );

      if (response['status'] == 'success' || response['success'] == true) {
        _lastCreatedOrder = response;
        print('✅ OrderProvider: Order created successfully');
        print('Order data: $_lastCreatedOrder');

        _isCreatingOrder = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to create order';
        print('❌ OrderProvider: Order creation failed: $_error');

        _isCreatingOrder = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      print('❌ OrderProvider: Error creating order: $_error');

      _isCreatingOrder = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear last created order
  void clearLastOrder() {
    _lastCreatedOrder = null;
    notifyListeners();
  }

  // Get user orders using REST endpoint
  Future<bool> getUserOrders({
    required String userId,
    int page = 1,
    int limit = 10,
    String? status,
    bool refresh = false,
  }) async {
    try {
      _isLoadingOrders = true;
      _error = null;
      notifyListeners();

      print('📋 OrderProvider: Getting user orders...');

      if (refresh) {
        _userOrders.clear();
        _currentPage = 1;
        _hasMoreOrders = true;
      }

      final response = await OrderApiService.getUserOrdersById(
        userId: userId,
        page: page,
        limit: limit,
        status: status,
      );

      if (response['status'] == 'success' || response['success'] == true) {
        final orders = response['data'] ?? response['orders'] ?? [];

        // Debug: Print the first order structure if available
        if (orders.isNotEmpty) {
          print('📋 Sample order structure: ${orders[0]}');
          if (orders[0]['products'] != null &&
              orders[0]['products'].isNotEmpty) {
            print('📋 Sample product structure: ${orders[0]['products'][0]}');
            print(
              '📋 Sample image structure: ${orders[0]['products'][0]['image']}',
            );
          }
        }

        if (refresh) {
          _userOrders = List.from(orders);
        } else {
          _userOrders.addAll(orders);
        }

        _currentPage = page;
        _hasMoreOrders = orders.length == limit;

        print('✅ OrderProvider: Orders loaded successfully');
        print('Orders count: ${_userOrders.length}');

        _isLoadingOrders = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to load orders';
        print('❌ OrderProvider: Orders loading failed: $_error');

        _isLoadingOrders = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      print('❌ OrderProvider: Error loading orders: $_error');

      _isLoadingOrders = false;
      notifyListeners();
      return false;
    }
  }

  // Load more orders (pagination)
  Future<bool> loadMoreOrders({
    required String userId,
    int limit = 10,
    String? status,
  }) async {
    if (!_hasMoreOrders || _isLoadingOrders) return false;

    return await getUserOrders(
      userId: userId,
      page: _currentPage + 1,
      limit: limit,
      status: status,
      refresh: false,
    );
  }

  // Refresh orders
  Future<bool> refreshOrders({
    required String userId,
    int limit = 10,
    String? status,
  }) async {
    return await getUserOrders(
      userId: userId,
      page: 1,
      limit: limit,
      status: status,
      refresh: true,
    );
  }
}
