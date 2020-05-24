import 'dart:async';
import 'package:cardigo/utils/globalappbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Alerts extends StatelessWidget {
  final Completer <WebViewController> _controller =
      Completer<WebViewController>();

  final appBar = new GlobalAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: WebView(
        initialUrl: "https://www2.deloitte.com/in/en.html",
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      floatingActionButton: FutureBuilder<WebViewController>(
          future: _controller.future,
          builder: (BuildContext context,
              AsyncSnapshot<WebViewController> controller) {
            if (controller.hasData) {
              return FloatingActionButton(
                backgroundColor: Color(0xFF86BC24),

                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    controller.data.goBack();
                  });
            }
            return Container();
          }
      ),
    );
  }
}
