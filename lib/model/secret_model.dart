class Secret {

  final String appId;
  final String appSec;
  final String comId;


  Secret({this.appId = "", this.appSec = "",this.comId = ""});


  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(
      appId: jsonMap["app_id"],
      appSec: jsonMap["app_secret"],
      comId: jsonMap["copmany_id"]
    );
  }
}