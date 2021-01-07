///
/// THIS IS NOT THE WAY TO DO IT !!!!!!!!!!!!!!!!
/// JUST NEEDED A PLACE TO PUT THEM 
///


class RealSecret{

  final String appId;
  final String appSec;
  final String comId;

  RealSecret({
    this.appId = "--- INSERT APP ID -----", 
    this.appSec = "--- INSERT APP SECRET -----",
    this.comId = "--- INSERT COMPANY ID -----"}
    );

}

// SERVER CONFIG

class ServerUrls{
  final String authUrl;
  final String tokenUrl;
  final String baseUrl;
  final String redirectUrl;

  ServerUrls({
    this.authUrl = "--- DOMAIN -----/connect/authorize", 
    this.tokenUrl = "--- DOMAIN -----/connect/token",
    this.baseUrl = "--- DOMAIN -----",
    this.redirectUrl = "--- DOMAIN -----"
    }
  );

}