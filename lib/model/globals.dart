
class Globals {
  static String token; //oauth token
  static String scheme = 'http';
  static String apiHost = '18.200.168.124';

  static String authorization = 'Bearer ' + Globals.token;

  static String questionPath = '/api/questiongroup/';
  static String assessmentGroupPath = '/api/assessmentgroup/';
  static String requestresidentialunitPath = '/api/requestresidentialunit/';
  static String documentPath = '/api/document/';
}

class HttpUrl {
  static String subsector = '/api/subsector';
  static String dashboard = '/api/dashboard';
  static String accountForgotPath = '/api/accountmanager/forgotpassword';
  static String userUrl = '/api/accountmanager';
  static String taskgrade = '/api/taskgrade/';
  static String projectPath = '/api/project/';
  static String residentialUnitPath = '/api/residentialunit/';
  static String beneficiaryPath = '/api/beneficiary/';
  static String projectDetailPath = '/api/projectdetail/';
}

