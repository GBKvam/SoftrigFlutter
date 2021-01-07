class Token {
  final String idtoken;
  final String access;
  final String type;
  final num expiresIn;
  final String refreshToken;


  Token(this.idtoken, this.access, this.type, this.expiresIn, this.refreshToken);

  Token.fromMap(Map<String, dynamic> json)
    : idtoken = json['id_token'],
      access = json['access_token'],
      type = json['token_token'],
      expiresIn = json['expires_in'],
      refreshToken = json['refresh_token'];

}