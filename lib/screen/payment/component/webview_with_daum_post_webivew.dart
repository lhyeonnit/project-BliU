import 'package:BliU/data/daum_post_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewWithDaumPostWebview extends StatefulWidget {
  const WebviewWithDaumPostWebview({super.key});

  @override
  State<WebviewWithDaumPostWebview> createState() => _WebviewWithDaumPostWebviewState();
}

class _WebviewWithDaumPostWebviewState extends State<WebviewWithDaumPostWebview> {
  final InAppLocalhostServer _localhostServer = InAppLocalhostServer();
  late InAppWebViewController _controller;

  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _localhostServer.start();
  }

  @override
  void dispose() {
    _localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("다음 주소 검색")),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
                url: WebUri(
                    "http://localhost:8080/assets/html/daum_postcode.html")),
            onWebViewCreated: (controller) {
              _controller = controller;
              _controller.addJavaScriptHandler(
                  handlerName: 'onSelectAddress',
                  callback: (args) {
                    Map<String, dynamic> fromMap = args.first;
                    DaumPostData data = _dataSetting(fromMap);
                    Navigator.of(context).pop(data);
                  });
            },
            onLoadStop: (controller, url) {
              setState(() {
                if (_localhostServer.isRunning()) {
                  isLoading = false;
                } else {
                  _localhostServer.start().then((value) {
                    _controller.reload();
                  });
                }
              });
            },
          ),
          if (isLoading) ...[
            const SizedBox(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
          if (isError) ...[
            Container(
              color: const Color.fromRGBO(71, 71, 71, 1),
              child: const Center(
                child: Text(
                  "페이지를 찾을 수 없습니다",
                  style: TextStyle( fontFamily: 'Pretendard',fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  DaumPostData _dataSetting(Map<String, dynamic> map) {
    return DaumPostData(
      map["address"],
      map["roadAddress"],
      map["jibunAddress"],
      map["sido"],
      map["sigungu"],
      map["bname"],
      map["roadname"],
      map["buildingName"],
      map["addressEnglish"],
      map["roadAddressEnglish"],
      map["jibunAddressEnglish"],
      map["sidoEnglish"],
      map["sigunguEnglish"],
      map["bnameEnglish"],
      map["roadnameEnglish"],
      map["zonecode"],
      map["sigunguCode"],
      map["bcode"],
      map["buildingCode"],
      map["roadnameCode"],
      map["addressType"],
      map["apartment"],
      map["userLanguageType"],
      map["userSelectedType"],
    );
  }
}