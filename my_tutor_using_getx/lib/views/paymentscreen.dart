import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_tutor/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/reg.dart';

class PaymentScreen extends StatefulWidget {
  final Registration reg;
  final double totalpayable;

  const PaymentScreen({Key? key, required this.reg, required this.totalpayable})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: CONSTANTS.server +
                    '/mytutor_mp_server/mobile/php/payment.php?email=' +
                    widget.reg.email.toString() +
                    '&mobile=' +
                    widget.reg.phone.toString() +
                    '&name=' +
                    widget.reg.name.toString() +
                    '&amount=' +
                    widget.totalpayable.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
