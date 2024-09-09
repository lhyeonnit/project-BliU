import 'dart:io';
import 'package:BliU/screen/mypage/viewmodel/inquiry_write_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class InquiryService extends ConsumerStatefulWidget {
  const InquiryService({super.key});

  @override
  _InquiryServiceState createState() => _InquiryServiceState();
}
// TODO 상품IDX 받아서 처리 작업 필요
// TODO 일반 고객 센터 인지분기 처리 필요
class _InquiryServiceState extends ConsumerState<InquiryService> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  int _imageCnt = 0;
  List<Widget> _addImagesWidget = [];
  List<XFile> _fileList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '문의하기',
          style: TextStyle(
              color: Colors.black,
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 문의 제목 입력
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '문의 제목 입력',
              ),
            ),
            const SizedBox(height: 16.0),

            // 문의 내용 입력
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '문의 내용을 최소 10자 이상 입력해 주세요.',
              ),
            ),
            const SizedBox(height: 16.0),

            // 이미지 선택 영역
            Row(
              children: [
                Text(
                  '이미지',
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                  ),
                ),
                const Spacer(),
                Text(
                  '$_imageCnt/4',
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    color: Colors.grey
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // 이미지 선택 버튼
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // 이미지 선택 동작 추가
                      _addImage();
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(top: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 40, color: Colors.grey),
                          Text('사진선택', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),

                  //추가함 이미지들
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: _addImagesWidget,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // 등록 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 등록 동작 추가
                  _qnaWrite(ref);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  '등록',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.getFont(context, 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addImageCheck() {
    setState(() {
      _addImagesWidget.clear();
      for (int i = 0; i < _fileList.length; i++) {
        _addImagesWidget.add(_addImageWidget(_fileList[i], i));
      }
      _imageCnt = _fileList.length;
    });
  }

  Widget _addImageWidget(XFile file, int index) {
    return Container(
      width: 85,
      height: 85,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: Image.file(
              File(file.path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _addImagesWidget.removeAt(index);
                  _fileList.removeAt(index);
                  _addImageCheck();
                });
              },
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: Colors.red
                ),
                child: Image.asset(
                  'assets/images/remove.png',
                  width: 10,
                  height: 10,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _addImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      _fileList = await picker.pickMultiImage(limit: 4);
      _addImageCheck();
    } catch(e) {
      print("Image Failed $e");
    }
  }

  void _qnaWrite(WidgetRef ref) async {
    final title = _titleController.text;
    final content = _contentController.text;
    if (title.isEmpty) {
      Utils.getInstance().showSnackBar(context, "문의 제목을 입력해 주세요.");
      return;
    }

    if (content.isEmpty) {
      Utils.getInstance().showSnackBar(context, "문의 내용을 입력해 주세요.");
      return;
    }

    if (content.length < 10) {
      Utils.getInstance().showSnackBar(context, "문의 내용은 10자 이상 입력해 주세요.");
      return;
    }
    // TODO 비회원 처리 필요
    final List<MultipartFile> files = _fileList.map((img) => MultipartFile.fromFileSync(img.path, contentType: DioMediaType("image", "jpg"))).toList();

    SharedPreferencesManager.getInstance().then((pref) {
      final mtIdx = pref.getMtIdx();

      final formData = FormData.fromMap({
        'qna_type' : '1',
        'mt_idx' : mtIdx,
        'pt_idx' : 1,// TODO 상품 IDX 처리 필요
        'qt_title' : title,
        'qt_content' : content,
        'seller_imgs' : files,
      });

      ref.read(inquiryWriteModelProvider.notifier).qnaWrite(formData).then((resultData) {
        if (resultData != null) {
          Utils.getInstance().showSnackBar(context, resultData.message.toString());
          if (resultData.result == true) {
            Navigator.pop(context);
          }
        } else {
          Utils.getInstance().showSnackBar(context, "Network Or Data Error");
        }
      });
    });
  }
}
