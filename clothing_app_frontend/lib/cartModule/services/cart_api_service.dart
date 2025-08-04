import '../../http_helper.dart';
import '../../api.dart';

class CartApiService {
  // Get user's cart
  Future<Map<String, dynamic>> getCart(String userId) async {
    final String url = '${webApi['domain']}${endPoint['getCart']}';

    try {
      print('Making getCart request to: $url');
      print('Request body: {"userId": "$userId"}');

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {'userId': userId},
      );

      print('GetCart Response: $response');
      return response;
    } catch (error) {
      print('Error in getCart API call: $error');
      throw Exception('Failed to get cart: $error');
    }
  }

  // Add product to cart
  Future<Map<String, dynamic>> addToCart(
    String userId,
    String variantId,
    int quantity,
  ) async {
    final String url = '${webApi['domain']}${endPoint['addToCart']}';

    try {
      print('Making addToCart request to: $url');
      print(
        'Request body: {"userId": "$userId", "variantId": "$variantId", "quantity": "$quantity"}',
      );

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {
          'userId': userId,
          'variantId': variantId,
          'quantity': quantity.toString(),
        },
      );

      print('AddToCart Response: $response');
      return response;
    } catch (error) {
      print('Error in addToCart API call: $error');
      throw Exception('Failed to add to cart: $error');
    }
  }

  // Update cart item quantity
  Future<Map<String, dynamic>> updateQuantity(
    String userId,
    String variantId,
    int quantity,
  ) async {
    final String url = '${webApi['domain']}${endPoint['updateCartQuantity']}';

    try {
      print('Making updateQuantity request to: $url');
      print(
        'Request body: {"userId": "$userId", "variantId": "$variantId", "quantity": "$quantity"}',
      );

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {
          'userId': userId,
          'variantId': variantId,
          'quantity': quantity.toString(),
        },
      );

      print('UpdateQuantity Response: $response');
      return response;
    } catch (error) {
      print('Error in updateQuantity API call: $error');
      throw Exception('Failed to update quantity: $error');
    }
  }

  // Remove item from cart
  Future<Map<String, dynamic>> removeFromCart(
    String userId,
    String variantId,
  ) async {
    final String url = '${webApi['domain']}${endPoint['removeFromCart']}';

    try {
      print('Making removeFromCart request to: $url');
      print('Request body: {"userId": "$userId", "variantId": "$variantId"}');

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {'userId': userId, 'variantId': variantId},
      );

      print('RemoveFromCart Response: $response');
      return response;
    } catch (error) {
      print('Error in removeFromCart API call: $error');
      throw Exception('Failed to remove from cart: $error');
    }
  }

  // Clear entire cart
  Future<Map<String, dynamic>> clearCart(String userId) async {
    final String url = '${webApi['domain']}${endPoint['clearCart']}';

    try {
      print('Making clearCart request to: $url');
      print('Request body: {"userId": "$userId"}');

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {'userId': userId},
      );

      print('ClearCart Response: $response');
      return response;
    } catch (error) {
      print('Error in clearCart API call: $error');
      throw Exception('Failed to clear cart: $error');
    }
  }
}
