import 'package:flutter/foundation.dart';

class CheckoutPayment {
  final String status;
  final String order_id;
  final String txnid;


  CheckoutPayment({
    @required this.status,
    @required this.order_id,
    @required this.txnid,


  });

  factory CheckoutPayment.fromJson(Map<String, dynamic> json) {
    return CheckoutPayment(
      status: json['status'] as String,
      order_id: json['order_id'] as String,
      txnid: json['txnid'] as String,

    );
  }


}