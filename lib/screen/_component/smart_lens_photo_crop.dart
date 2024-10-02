import 'dart:io';
import 'package:BliU/screen/_component/smart_lens_result.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';

class SmartLensPhotoCrop extends StatefulWidget {
  final AssetEntity imageEntity;

  const SmartLensPhotoCrop({required this.imageEntity, Key? key})
      : super(key: key);

  @override
  _SmartLensPhotoCropState createState() => _SmartLensPhotoCropState();
}

class _SmartLensPhotoCropState extends State<SmartLensPhotoCrop> {
  bool _isLoading = true;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    // 로딩을 3초간 시뮬레이션
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
    // 로딩이 끝나면 파일을 불러오고 크롭 화면으로 전환
    _loadImageFile();
  }

  Future<void> _loadImageFile() async {
    final file = await widget.imageEntity.file;
    if (file != null) {
      setState(() {
        _imageFile = file;
      });
      _showImageCropper();
    }
  }

  Future<void> _showImageCropper() async {
    if (_imageFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        // 크롭된 이미지로 다음 화면으로 이동하거나 처리 로직을 넣을 수 있음
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SmartLensResult(imagePath: croppedFile.path),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg",
              color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
        title: const Text('스마트렌즈'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.2,
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _imageFile != null
                ? Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Image.asset('assets/images/스마트렌즈-로딩.gif'),
                  ),
          ),
        ],
      ),
    );
  }
}
