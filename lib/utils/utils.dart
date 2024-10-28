import 'dart:io';
import 'dart:math';

import 'package:BliU/utils/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static Utils? _instance;

  static Utils getInstance() {
    return _instance ??= Utils._();
  }
  Utils._();

  // void showToast(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.black,
  //     fontSize: 20,
  //     textColor: Colors.white,
  //     toastLength: Toast.LENGTH_SHORT,
  //   );
  // }

  void showSnackBar(BuildContext context, String message) {
    _showTopMessage(context, message);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //     duration: const Duration(seconds: 3),
    //   ),
    // );
  }

  String priceString(int price) {
    var formatter = NumberFormat('###,###,###,###');
    return formatter.format(price);
  }

  Future<XFile> urlToXFile(String url) async {
    var now = DateTime.now().millisecond;
    final http.Response responseData = await http.get(Uri.parse(url));
    var uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/img${Random().nextInt(100000000)}$now.jpg').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    XFile files = XFile(file.path);
    return files;
  }

  void _showTopMessage(BuildContext context, String message) {
    BuildContext? dialogContext;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      // 다른 영역을 클릭해도 닫힘
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      // 배경을 어둡게
      transitionDuration: const Duration(milliseconds: 100),
      // 애니메이션 시간
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        dialogContext = buildContext;
        return Align(
          alignment: Alignment.topCenter, // 화면 상단 중앙에 배치
          child: Material(
            color: Colors.transparent, // 배경을 투명하게
            child: Container(
              margin: const EdgeInsets.only(top: 50), // 상단에서의 간격
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xCC000000), // 알림창 배경색
                borderRadius: BorderRadius.circular(22), // 둥근 모서리
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 가로로 배치
                mainAxisSize: MainAxisSize.min, // 알림창 크기를 내용에 맞춤
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (dialogContext != null) {
        if (dialogContext!.mounted) {
          Navigator.pop(dialogContext!);
        }
      }
    });
  }
}