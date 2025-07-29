// var webApi = {'domain': 'https://api.iteeha.co'}; //PROD
// var webApi = {'domain': 'http://localhost:3001/'}; //DEV LOCAL
var webApi = {'domain': 'https://naturally-giving-chow.ngrok-free.app/'}; //DEV NGROK

var endPoint = {
  // Authentication
  'login': 'api/user/loginOrRegisterUser',

  // Home
  'getCategory': 'api/category/getCategory',

  //Preference
  'getAllPreferences': 'api/preferences/getAllPreferences',
  'getPrefByUserId': 'api/preferences/getPrefByUserId',
  'updatePreference': 'api/preferences/updatePreference',
  'deletePreference': 'api/preferences/deletePreference',

  // ML Services (direct ngrok routes)
  'mlAsk': 'ask/',
  'mlAnalyzePreferences': 'ask/',
};
