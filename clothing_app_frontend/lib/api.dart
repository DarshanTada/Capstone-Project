
// var webApi = {'domain': 'http://10.144.121.67:3001/'}; //PC IP ADDRESS

// var webApi = {'domain': 'https://api.iteeha.co'}; //PROD

// var webApi = {'domain': 'http://10.144.121.158:3001/'}; //DEV PROD

var webApi = {'domain': 'http://10.0.0.213:3001/'}; //DEV PROD


var mlApi = {'domain': 'https://naturally-giving-chow.ngrok-free.app/'}; //ML NGROK

var endPoint = {
  // Authentication
  'login': 'api/user/loginOrRegisterUser',
  'updateUser': 'api/user/updateUser',
  'getUserById': 'api/user/getUserById',

  // Home
  'getHomeData': 'api/home/home',
  'getCategory': 'api/category/getCategory',
  'getProductsByCategory': 'api/category/getProductsByCategory',
  // Product
  'getProducts': 'api/product/getProduct',
  // SubCategory
  'getSubCategories': 'api/subCategory/getAll',

  //Preference
  'getAllPreferences': 'api/preferences/getPreferences',
  'getPrefByUserId': 'api/preferences/user',
  'updatePreference': 'api/preferences/updatePreference',
  'deletePreference': 'api/preferences/deletePreference',

  // Address
  'addAddress': 'api/address/addAddress',
  'getAddressesByUserId': 'api/address/getAddressesByUserId',
  'updateAddress': 'api/address/updateAddress',
  'deleteAddress': 'api/address/deleteAddress',

  // ML Services (use ngrok for ML only)
  'mlAsk': 'ask/',
  'mlAnalyzePreferences': 'ask/',
};
