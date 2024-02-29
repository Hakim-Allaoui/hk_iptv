import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mbark_iptv/second/utils/tools.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final String url;

  const HomePage({super.key, required this.url});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey webViewKey = GlobalKey();

  int clickCounter = 0;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions settings = InAppWebViewGroupOptions(
      android: AndroidInAppWebViewOptions(),
      crossPlatform: InAppWebViewOptions(
        mediaPlaybackRequiresUserGesture: false,
        contentBlockers: [],
      ));

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  init() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  @override
  void initState() {
    super.initState();

    init();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var canGoBakc = await webViewController!.canGoBack();
        if (canGoBakc) {
          await webViewController!.goBack();
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0.0,
          leading: const SizedBox(),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                      initialOptions: settings,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onEnterFullscreen: (controller) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeRight,
                          DeviceOrientation.landscapeLeft,
                        ]);
                      },
                      onLoadStart: (controller, url) {
                      },
                      androidOnPermissionRequest: (controller, request, li) async {
                        return PermissionRequestResponse(
                            resources: li, action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about",
                        ].contains(uri.scheme)) {
                          if (await canLaunchUrl(uri)) {
                            // Launch the App
                            await launchUrl(
                              uri,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController?.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        // pullToRefreshController?.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        // webViewController!.injectJavascriptFileFromUrl(
                        //     urlFile: Uri.parse(
                        //         "https://easylist.to/easylist/easylist.txt"));

                        webViewController!.evaluateJavascript(source: """javascript:(function() {
  var head = document.getElementsByTagName('header')[0];
  head.parentNode.removeChild(head);
  })()""");

                        if (progress == 100) {
                          pullToRefreshController?.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = url;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                      onDownloadStartRequest: (controller, url) async {
                        print("onDownloadStart $url");

                        final String _url_files = "$url";

                        void _launchURL_files() async =>
                            await Tools.launchURL(_url_files, inAppWebView: false);

                        _launchURL_files();
                      },
                    ),
                    progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyWebView extends StatefulWidget {
  final String url;
  final MyInAppBrowser browser = MyInAppBrowser();

  final ChromeSafariBrowser browser2 = MyChromeSafariBrowser();

  MyWebView({super.key, required this.url});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb ||
        ![TargetPlatform.iOS, TargetPlatform.android].contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          widget.browser.webViewController?.reload();
        } else if (Platform.isIOS) {
          widget.browser.webViewController?.loadUrl(
              urlRequest: URLRequest(url: await widget.browser.webViewController?.getUrl()));
        }
      },
    );

    // widget.browser.pullToRefreshController = pullToRefreshController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "InAppBrowser",
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  // await widget.browser2.open(
                  //   url: WebUri(widget.url),
                  //   options: ChromeSafariBrowserClassOptions(
                  //     android: AndroidChromeCustomTabsOptions(
                  //       shareState: CustomTabsShareState.SHARE_STATE_OFF,
                  //       isSingleInstance: false,
                  //       isTrustedWebActivity: false,
                  //       keepAliveEnabled: true,
                  //       showTitle: true,
                  //       toolbarBackgroundColor: Color(0XFF5367ff),
                  //     ),
                  //   ),
                  // );

                  // return;
                  await widget.browser.openUrlRequest(
                    urlRequest: URLRequest(url: WebUri(widget.url)),
                    options: InAppBrowserClassOptions(
                      android: AndroidInAppBrowserOptions(
                        toolbarTopFixedTitle: "MyCima",
                      ),
                      crossPlatform: InAppBrowserOptions(
                        hideToolbarTop: true,
                      ),
                      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
                        android: AndroidInAppWebViewOptions(),
                        crossPlatform: InAppWebViewOptions(),
                      ),
                    ),
                  );
                },
                child: const Text("Open In-App Browser")),
            Container(height: 40),
            ElevatedButton(
                onPressed: () async {
                  await InAppBrowser.openWithSystemBrowser(url: WebUri(widget.url));
                },
                child: const Text("Open System Browser")),
          ],
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser({int? windowId, UnmodifiableListView<UserScript>? initialUserScripts})
      : super(windowId: windowId, initialUserScripts: initialUserScripts);

  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {}

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    print("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }
}

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

class ChromeSafariBrowserExampleScreen extends StatefulWidget {
  final ChromeSafariBrowser browser = MyChromeSafariBrowser();

  @override
  _ChromeSafariBrowserExampleScreenState createState() => _ChromeSafariBrowserExampleScreenState();
}

class _ChromeSafariBrowserExampleScreenState extends State<ChromeSafariBrowserExampleScreen> {
  @override
  void initState() {
    rootBundle.load('assets/images/flutter-logo.png').then((actionButtonIcon) {
      widget.browser.setActionButton(ChromeSafariBrowserActionButton(
        id: 1,
        description: 'Action Button description',
        icon: actionButtonIcon.buffer.asUint8List(),
        action: (String url, String title) {},
      ));
    });

    widget.browser.addMenuItem(ChromeSafariBrowserMenuItem(
        id: 2,
        label: 'Custom item menu 1',
        action: (url, title) {
          print('Custom item menu 1 clicked!');
          print(url);
          print(title);
        }));
    widget.browser.addMenuItem(ChromeSafariBrowserMenuItem(
        id: 3,
        label: 'Custom item menu 2',
        action: (url, title) {
          print('Custom item menu 2 clicked!');
          print(url);
          print(title);
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
