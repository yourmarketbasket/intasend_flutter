import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IntasendWebView extends StatefulWidget {
  final String url;

  const IntasendWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<IntasendWebView> createState() => _IntasendWebViewState();
}

class _IntasendWebViewState extends State<IntasendWebView> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Checkout',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading ?   Center(child: CircularProgressIndicator(strokeWidth: 1, valueColor: AlwaysStoppedAnimation<Color>(Colors.black), backgroundColor: Colors.grey,)) : Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WebViewWidget(controller: controller),
              ],
            ),
        
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.black87,
        size: 24,
      ),
      onPressed: onPressed,
      splashRadius: 24,
      tooltip: icon == Icons.arrow_back_ios
          ? 'Back'
          : icon == Icons.arrow_forward_ios
              ? 'Forward'
              : 'Reload',
    );
  }
}