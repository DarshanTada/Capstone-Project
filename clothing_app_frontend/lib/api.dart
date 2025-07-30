// var webApi = {'domain': 'https://api.iteeha.co'}; //PROD

var webApi = {'domain': 'http://localhost:3001/'}; //DEV PROD
var mlApi = {
  'domain': 'https://naturally-giving-chow.ngrok-free.app/',
}; //ML NGROK

var endPoint = {
  // Authentication
  'login': 'api/user/loginOrRegisterUser',
  'updateUser': 'api/user/updateUser',
  'getUserById': 'api/user/getUserById',

  // Home
  'getCategory': 'api/category/getCategory',
  'getProductsByCategory': 'api/category/getProductsByCategory',
  // Product
  'getProducts': 'api/product/getProduct',
  // SubCategory
  'getSubCategories': 'api/subCategory/getAll',

  //Preference
  'getAllPreferences': 'api/preferences/getAllPreferences',
  'getPrefByUserId': 'api/preferences/getPrefByUserId',
  'updatePreference': 'api/preferences/updatePreference',
  'deletePreference': 'api/preferences/deletePreference',

  // ML Services (use ngrok for ML only)
  'mlAsk': 'ask/',
  'mlAnalyzePreferences': 'ask/',
};
