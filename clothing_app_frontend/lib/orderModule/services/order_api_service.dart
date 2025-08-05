import '../../api.dart';
import '../../http_helper.dart';

class OrderApiService {
  // Create a new order
  static Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> products,
    required String userId,
    required String addressId,
    required String paymentMethod,
  }) async {
    try {
      print('🛒 Creating order...');
      print('Products: $products');
      print('User ID: $userId');
      print('Address ID: $addressId');
      print('Payment Method: $paymentMethod');

      Map<String, dynamic> requestData = {
        'products': products,
        'user': userId,
        'address': addressId,
        'paymentMethod': paymentMethod,
      };

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: '${webApi['domain']}${endPoint['createOrder']}',
        body: requestData,
      );

      print('✅ Order creation response: $response');
      return response;
    } catch (e) {
      print('❌ Error creating order: $e');
      rethrow;
    }
  }

  // Get order by ID
  static Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      print('📋 Getting order by ID: $orderId');

      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: '${webApi['domain']}${endPoint['getOrderById']}$orderId',
      );

      print('✅ Get order response: $response');
      return response;
    } catch (e) {
      print('❌ Error getting order: $e');
      rethrow;
    }
  }

  // Get user orders
  static Future<Map<String, dynamic>> getUserOrders({
    required String userId,
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      print('📋 Getting user orders for user ID: $userId');

      Map<String, dynamic> requestData = {
        'userId': userId,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null && status.isNotEmpty) {
        requestData['status'] = status;
      }

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: '${webApi['domain']}${endPoint['getUserOrders']}',
        body: requestData,
      );

      print('✅ Get user orders response: $response');
      return response;
    } catch (e) {
      print('❌ Error getting user orders: $e');
      rethrow;
    }
  }

  // Get user orders by ID (REST endpoint)
  static Future<Map<String, dynamic>> getUserOrdersById({
    required String userId,
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      print('📋 Getting user orders by ID (REST): $userId');

      // Build query parameters
      List<String> queryParams = ['page=$page', 'limit=$limit'];

      if (status != null && status.isNotEmpty) {
        queryParams.add('status=$status');
      }

      String queryString = queryParams.isNotEmpty
          ? '?${queryParams.join('&')}'
          : '';

      final finalUrl =
          '${webApi['domain']}${endPoint['getUserOrdersById']}$userId$queryString';
      print('🌐 Final URL: $finalUrl');
      print('🔧 Domain: ${webApi['domain']}');
      print('🔧 Endpoint: ${endPoint['getUserOrdersById']}');
      print('🔧 Query: $queryString');

      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: finalUrl,
      );

      print('✅ Get user orders by ID response: $response');
      return response;
    } catch (e) {
      print('❌ Error getting user orders by ID: $e');
      print('❌ Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  // Update product status in order
  static Future<Map<String, dynamic>> updateProductStatus({
    required String orderId,
    required String variantId,
    required String status,
    String? reason,
  }) async {
    try {
      print('📦 Updating product status...');
      print('Order ID: $orderId');
      print('Variant ID: $variantId');
      print('New Status: $status');

      Map<String, dynamic> requestData = {
        'orderId': orderId,
        'variantId': variantId,
        'status': status,
      };

      if (reason != null && reason.isNotEmpty) {
        requestData['reason'] = reason;
      }

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: '${webApi['domain']}${endPoint['updateProductStatus']}',
        body: requestData,
      );

      print('✅ Update product status response: $response');
      return response;
    } catch (e) {
      print('❌ Error updating product status: $e');
      rethrow;
    }
  }

  // Cancel product in order
  static Future<Map<String, dynamic>> cancelProduct({
    required String orderId,
    required String variantId,
    String? cancelReason,
  }) async {
    try {
      print('❌ Canceling product...');
      print('Order ID: $orderId');
      print('Variant ID: $variantId');
      print('Cancel Reason: $cancelReason');

      Map<String, dynamic> requestData = {
        'orderId': orderId,
        'variantId': variantId,
      };

      if (cancelReason != null && cancelReason.isNotEmpty) {
        requestData['cancelReason'] = cancelReason;
      }

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: '${webApi['domain']}${endPoint['cancelProduct']}',
        body: requestData,
      );

      print('✅ Cancel product response: $response');
      return response;
    } catch (e) {
      print('❌ Error canceling product: $e');
      rethrow;
    }
  }
}
