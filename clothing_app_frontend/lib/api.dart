// var webApi = {'domain': 'https://api.iteeha.co'}; //PROD
var webApi = {'domain': 'http://10.0.0.213:3001/'}; //DEV PROD

var endPoint = {
  // Authentication
  'login': 'api/user/loginOrRegisterUser',

  // Home
  'getCategory': 'api/category/getCategory',
  // Product
  'getProducts': 'api/product/getProduct',
  // SubCategory
  'getSubCategories': 'api/subCategory/getAll',

  //Preference
  'getAllPreferences': 'api/preferences/getAllPreferences',
  'getPrefByUserId': 'api/preferences/getPrefByUserId',
  'updatePreference': 'api/preferences/updatePreference',
  'deletePreference': 'api/preferences/deletePreference',
};
