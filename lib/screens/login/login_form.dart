import 'package:SoftrigFlutter/config/config.dart';
import 'package:SoftrigFlutter/model/token_model.dart';
import 'package:SoftrigFlutter/screens/product/products.dart';
import 'package:SoftrigFlutter/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';


Token token;
String code = "";
String strToken = "";
TokenService ts;
RealSecret rs;
ServerUrls su;



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  InAppWebViewController webView;
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  // CookieManager _cookieManager = CookieManager.instance();
  String theCode = "";
  bool gotcode = false;

  String theToken = "";
  String svarAPI = "_";

  @override
  void initState() {
    super.initState();
    ts = new TokenService();
    rs = new RealSecret();
    su = new ServerUrls();
    
    
  }



  @override
  void dispose() {
    super.dispose();
  }

  void getToken(String code) async {

    Token _tok = await ts.getToken(rs.appId, rs.appSec, code);

    setState(() {
      token = _tok;
      strToken = _tok.access;
    });
  }

  
 

  Future<Token> getRefreshToken() async {
    Token _tok =
        await ts.getRefreshToken(rs.appId, rs.appSec, token.refreshToken);
    return _tok;
  }

  @override
  Widget build(BuildContext context) {
      if (code.length < 1) {
        return Scaffold(
            appBar: AppBar(title: Text("Login SoftRig")),
            // drawer: myDrawer(context: context),
            body: SafeArea(
                child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container()),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                  child: InAppWebView(
                    // contextMenu: contextMenu,
                    // TODO: FIX URL ENCODING OF REDIRECT URL
                    
                    initialUrl:
                        "${su.authUrl}?response_type=code&state=&client_id=${rs.appId}&scope=openid%20profile%20offline_access%20AppFramework&state=partyai&redirect_uri=http%3A%2F%2Flocalhost%3A8080",
                    // initialFile: "assets/index.html",
                    initialHeaders: {},
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                          useShouldOverrideUrlLoading: true,
                        ),
                        android: AndroidInAppWebViewOptions(
                            useHybridComposition: true)),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                      print("onWebViewCreated");
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {
                      print("onLoadStart $url");
                      setState(() {
                        this.url = url;
                      });
                    },
                    shouldOverrideUrlLoading:
                        (controller, shouldOverrideUrlLoadingRequest) async {
                      var url = shouldOverrideUrlLoadingRequest.url;
                      var uri = Uri.parse(url);

                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        if (await canLaunch(url)) {
                          // Launch the App
                          await launch(
                            url,
                          );
                          // and cancel the request
                          return ShouldOverrideUrlLoadingAction.CANCEL;
                        }
                      }

                      return ShouldOverrideUrlLoadingAction.ALLOW;
                    },
                    onLoadStop:
                        (InAppWebViewController controller, String url) async {
                      var uri = Uri.dataFromString(url);

                      String tmpCode = "";
                      try {
                        tmpCode = uri.queryParameters['code'];
                      } catch (e) {
                        tmpCode = "";
                      }

                      setState(() {
                        this.url = url;
                        if (tmpCode.length > 1) {
                          code = tmpCode;
                          getToken(tmpCode);
                        }
                      });
                    },
                  ),
                ),
              ),
            ])));
      } else {
        if (strToken.length < 1) {
          return Scaffold(
              appBar: AppBar(title: Text("Login SoftRig")),
              backgroundColor: Color(0xFF18DDFF),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Image(image: AssetImage('assets/softrig.png')),
                          // Text('Code: $code'),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        } else {
           return ProductsPage(softrigToken: token, title: "Produkter");
        
        }
      }
    }
  
}
