import 'dart:async';

import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';




class CommonWebviewScreen extends StatefulWidget {
  String url;
  String page_name;
  

  CommonWebviewScreen({Key key, this.url = "", this.page_name = ""})
      : super(key: key);

  @override
  _CommonWebviewScreenState createState() => _CommonWebviewScreenState();
}

class _CommonWebviewScreenState extends State<CommonWebviewScreen> {
  WebViewController _webViewController;
  bool isLoading=true;
  final Completer< WebViewController> _controller=Completer< WebViewController>();
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WebView.platform=AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return SizedBox.expand(
      child: ModalProgressHUD(
        inAsyncCall:isLoading ,
        child: WebView(
          debuggingEnabled: false,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _webViewController = controller;
            _webViewController.loadUrl(widget.url);
          },
          onWebResourceError: (error) {},
          onPageFinished: (page) {
            //print(page.toString());
            setState(() {
              isLoading=false;
            });
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "${widget.page_name}",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
