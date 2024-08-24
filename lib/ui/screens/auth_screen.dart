import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class AuthScreen extends StatefulWidget {
  final String authUrl;

  AuthScreen({required this.authUrl});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final WebViewController _controller;
  late final String _userAgent;
  final mobileTabletRegex = RegExp(
    r'(android|ipad|iphone|ipod|mobile|tablet|silk|kindle|blackberry|opera mini|windows phone|palm|samsung|nexus|galaxy|lg|htc|motorola|nokia|webos|playbook|playstation|nintendo)',
    caseSensitive: false,
  );

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
// ···
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    
    controller
      ..setUserAgent('Elswhere')
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (UrlChange change) {
            final url = change.url ?? '';
            print(url);

            if (url.startsWith("elswhere://")) {
              final uri = Uri.parse(url);
              final authResult = uri.queryParameters;
              final accessToken = authResult['access_token'] ?? '';
              final refreshToken = authResult['refresh_token'] ?? '';

              print('완료');

              Navigator.pop(context, <String, String>{
                'accessToken': accessToken,
                'refreshToken': refreshToken,
              });
            }
          }
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));

    _controller = controller;
  }

  Future<void> _getUserAgent() async {
    try {
      final userAgent = await _controller.runJavaScriptReturningResult('navigator.userAgent;');
      _userAgent = userAgent.toString();
      print(_userAgent);
    } catch (e) {
      _userAgent = "Failed to get User Agent";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _getUserAgent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              Navigator.pop(context);
              return const Center(child: Text('An error occurred!'));
            } else {
              // print(mobileTabletRegex.hasMatch(_userAgent));
              // if (mobileTabletRegex.hasMatch(_userAgent)) {
              //   _controller.setUserAgent('userAgent');
                return WebViewWidget(controller: _controller,);
              // } else {
              //   Navigator.pop(context);
              //   return const Center(child: Text('모바일 기기가 아닙니다.'));
              // }
            }
          },
        ),
      ),
    );
  }
}