import 'package:flutter/foundation.dart';

class Token {
  final String token_type;
  final String access_token;
  final String expires;

  Token({
    @required this.token_type,
    @required this.access_token,
    @required this.expires,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token_type: json['token_type'] as String,
      access_token: json['access_token'] as String,
      expires: json['expires_in'] as String,
    );
  }


}