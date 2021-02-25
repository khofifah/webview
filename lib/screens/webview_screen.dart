import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  String link = 'https://www.instagram.com/kelasmobilemalang/?hl=id';
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  JavascriptChannel toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (message) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(message.message),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview'),
      ),
      body: WebView(
        initialUrl: link,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (ctrl) {
          controller.complete(ctrl);
        },
        javascriptChannels: <JavascriptChannel>[
          toasterJavascriptChannel(context),
        ].toSet(),
        navigationDelegate: (navigation) {
          if (navigation.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
        },
      ),
    );
  }
}
