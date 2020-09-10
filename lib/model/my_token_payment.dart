import 'package:flutter/foundation.dart';

class TokenPayment {
  final int statut;
  final String message;
  final String pay_token;
  final String payment_url;
  final String notif_token;

  TokenPayment({
    @required this.statut,
    @required this.message,
    @required this.pay_token,
    @required this.payment_url,
    @required this.notif_token,

  });

  factory TokenPayment.fromJson(Map<String, dynamic> json) {
    return TokenPayment(
      statut: json['statut'] as int,
      pay_token: json['pay_token'] as String,
      payment_url: json['payment_url'] as String,
      notif_token: json['notif_token'] as String,
      message: json['message'] as String,
    );
  }


}