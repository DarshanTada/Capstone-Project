// var webApi = {'domain': 'http://localhost:3001/'}; // LOCALHOST
var webApi = {'domain': 'http://localhost:3001/'}; //PC IP ADDRESS
var mlApi = {'domain': 'https://naturally-giving-chow.ngrok-free.app/'}; //ML NGROK

var endPoint = {
  // Authentication
  'login': 'api/user/loginOrRegisterUser',
  'updateUser': 'api/user/updateUser',
  'getUserById': 'api/user/getUserById',
  'logout': 'api/user/logout',

  // Home
  'getHomeData': 'api/home/home',
  'getCategory': 'api/category/getCategory',
  'getProductsByCategory': 'api/category/getProductsByCategory',
  // Product
  'getProducts': 'api/product/getProduct',
  // SubCategory
  'getSubCategories': 'api/subCategory/getAll',

  //Preference (handled by user module)
  'getAllPreferences': 'api/user/users',
  'getPrefByUserId': 'api/user/getUserById',
  'updatePreference': 'api/user/updateUser',
  'deletePreference': 'api/user/updateUser', // Use updateUser to clear preference data

  // Address
  'addAddress': 'api/address/addAddress',
  'getAddressesByUserId': 'api/address/getAddressesByUserId',
  'updateAddress': 'api/address/updateAddress',
  'deleteAddress': 'api/address/deleteAddress',

  // ML Services (use ngrok for ML only)
  'mlAsk': 'ask/',
  'mlAnalyzePreferences': 'ask/',
};
