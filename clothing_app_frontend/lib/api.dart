// var webApi = {'domain': 'https://api.iteeha.co'}; //PROD
var webApi = {'domain': 'http://localhost:3001/'}; //DEV PROD

var endPoint = {
  // Authentication
  'login': 'api/user/loginOrRegisterUser',

  //Preference
  'getAllPreferences': 'api/preferences/getAllPreferences',
  'getPrefByUserId': 'api/preferences/getPrefByUserId',
  'updatePreference': 'api/preferences/updatePreference',
  'deletePreference': 'api/preferences/deletePreference',
};
