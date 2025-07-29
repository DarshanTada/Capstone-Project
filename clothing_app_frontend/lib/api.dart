// var webApi = {'domain': 'https://api.iteeha.co'}; //PROD
// var webApi = {'domain': 'http://10.0.0.213:3001/'}; //Darshan Home wifi 
var webApi = {'domain': 'http://10.144.120.64:3001/'}; //Darshan College wifi

var endPoint = {
  // Authentication
  'login': 'api/user/loginOrRegisterUser',

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

  // ML Services
  'mlAsk': 'api/ml/ask',
  'mlAnalyzePreferences': 'api/ml/analyze-preferences',
};
