import 'package:BliU/screen/terms_detail/view_model/terms_detail_view_model.dart';
import 'package:BliU/utils/my_app_bar.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TermsDetailScreen extends ConsumerStatefulWidget {
  const TermsDetailScreen({super.key});

  @override
  ConsumerState<TermsDetailScreen> createState() => TermsDetailScreenState();
}

class TermsDetailScreenState extends ConsumerState<TermsDetailScreen> {
  String _title = "";
  int _type = 0;// type 0 - 이용약관 1 - 개인정보 처리 방침 2 - 개인정보 수집 이용 동의 3 - 개인정보 제 3자 정보 제공 동의 4 - 결제대행 서비스 이용약관 동의
  String _content = "";
  InAppWebViewController? _controller;

  @override
  void initState() {
    super.initState();
    try {
      _type = int.parse(Get.parameters["type"].toString());
    } catch(e) {
      //
    }

    switch(_type) {
      case 0:
        _title = "이용약관";
        break;
      case 1:
        _title = "개인정보처리방침";
        break;
      case 2:
        _title = "개인정보 수집 이용 동의";
        break;
      case 3:
        _title = "개인정보 제 3자 정보 제공 동의";
        break;
      case 4:
        _title = "결제대행 서비스 이용약관 동의";
        break;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _afterBuild(BuildContext context) {
    _getTermsAndPrivacy();
  }

  void _getTermsAndPrivacy() async {
    final defaultResponseDTO = await ref.read(termsDetailViewModelProvider.notifier).getTermsAndPrivacy(_type);

    if (defaultResponseDTO != null) {
      if (defaultResponseDTO.result == true) {
        _content = defaultResponseDTO.message ?? "";
        _content = _contentAddHtml(_content);
        setState(() {
          _controller?.loadData(data: _content);
        });
      } else {
        Future.delayed(Duration.zero, () {
          if (!mounted) return;
          Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
        });
      }
    }
  }

  String _contentAddHtml(String content) {
    content = content.trim();
    return content = """
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    </head>
    <body>
    <style>
			html { font-size:10px; }
			.ql-align-right {
        text-align: right;
      }
      .ql-align-center {
        text-align: center;
      }
      .ql-align-left {
        text-align: left;
      }
      .ql-size-small {
        font-size: 0.75em;
      }
      .ql-size-large {
        font-size: 1.5em;
      }
      .ql-size-huge {
        font-size: 2.5em;
      }
      img { max-width:100%; display:inline-block; height: auto; }
		</style>
    $content
    </body>
    </html>
    """;
  }

  @override
  Widget build(BuildContext context) {
    _content = _contentAddHtml(_content);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Text(_title),
          titleTextStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 18),
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.2,
          ),
          leading: IconButton(
            icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 동작
            },
          ),
          titleSpacing: -1.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
            child: Container(
              color: const Color(0x0D000000), // 하단 구분선 색상
              height: 1.0, // 구분선의 두께 설정
              child: Container(
                height: 1.0, // 그림자 부분의 높이
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 6.0,
                      spreadRadius: 0.1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Utils.getInstance().isWebView(
          Container(
            padding: const EdgeInsets.all(16.0),
            child: InAppWebView(
              initialData: InAppWebViewInitialData(data: _content),
              initialSettings: InAppWebViewSettings(
                transparentBackground: true,
              ),
              onWebViewCreated: (controller) async {
                _controller = controller;
              },
            ),
          ),
        ),
      ),
    );
  }
}
