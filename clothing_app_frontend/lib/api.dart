// var webApi = {'domain': 'http://localhost:3001/'}; // LOCALHOST
var webApi = {'domain': 'http://10.0.0.213:3001/'}; //PC IP ADDRESS
var mlApi = {
  'domain': 'https://naturally-giving-chow.ngrok-free.app/',
}; //ML NGROK

var endPoint = {
  // Authentication
  'login': 'api/user/loginOrRegisterUser',
  'updateUser': 'api/user/updateUser',
  'getUserById': 'api/user/getUserById',
  'deleteUser': 'api/user/deleteUser',
  'logout': 'api/user/logout',

  // Home
  'getHomeData': 'api/home/home',
  'getCategory': 'api/category/getCategory',
  'getProductsByCategory': 'api/category/getProductsByCategory',
  // Product
  'getProducts': 'api/product/getProduct',
  'getProductDetail':
      'api/product/getProductDetail', // REST endpoint for GET /getProductDetail/:productId
  // SubCategory
  'getAllSubCategories': 'api/subCategory/getAll',

  // Cart
  'getCart': 'api/cart/getCart',
  'addToCart': 'api/cart/addToCart',
  'updateCartQuantity': 'api/cart/updateQuantity',
  'removeFromCart': 'api/cart/removeFromCart',
  'clearCart': 'api/cart/clearCart',

  //Preference (handled by user module)
  'getAllPreferences': 'api/user/users',
  'getPrefByUserId': 'api/user/getUserById',
  'updatePreference': 'api/user/updateUser',
  'deletePreference':
      'api/user/updateUser', // Use updateUser to clear preference data
  // Address
  'addAddress': 'api/address/addAddress',
  'getAddressesByUserId': 'api/address/getAddressesByUserId',
  'updateAddress': 'api/address/updateAddress',
  'deleteAddress': 'api/address/deleteAddress',

  // Order
  'createOrder': 'api/order/createOrder',
  'getOrderById': 'api/order/getOrder/',
  'getAllOrders': 'api/order/getAllOrders',
  'getUserOrders': 'api/order/getUserOrders',
  'getUserOrdersById':
      'api/order/getUserOrders/', // REST endpoint for GET /getUserOrders/:userId
  'updateProductStatus': 'api/order/updateProductStatus',
  'cancelProduct': 'api/order/cancelProduct',

  // ML Services (use ngrok for ML only)
  'mlAsk': 'ask/',
  'mlAnalyzePreferences': 'ask/',
};
