import 'dart:io';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/_component/smart_lens_result.dart';
import 'package:BliU/screen/_component/smart_lens_screen.dart';
import 'package:BliU/screen/_component/viewmodel/smart_lens_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';

class SmartLensPhotoCrop extends ConsumerStatefulWidget {
  final AssetEntity imageEntity;
  const SmartLensPhotoCrop({super.key, required this.imageEntity});

  @override
  ConsumerState<SmartLensPhotoCrop> createState() => _SmartLensPhotoCropState();
}

class _SmartLensPhotoCropState extends ConsumerState<SmartLensPhotoCrop> {
  bool _isLoading = true;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImageFile();
  }

  Future<void> _loadImageFile() async {
    final file = await widget.imageEntity.file;
    if (file != null) {
      setState(() {
        _imageFile = file;
        _simulateLoading();  // 이미지가 준비된 후 로딩 시뮬레이션 시작
      });
    }
  }

  Future<void> _simulateLoading() async {
    // 로딩을 3초간 시뮬레이션
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
    // 3초 로딩 후 크롭 화면으로 전환
    _showImageCropper();
  }

  Future<void> _showImageCropper() async {
    if (_imageFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '선택사진 크롭',
            toolbarColor: Colors.black,
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
            title: '선택사진 크롭',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
        ],
      );

      if (croppedFile == null) {
        // 원하는 동작을 여기에 정의 (예: 특정 페이지로 이동)
        Navigator.pop(context);
      } else {
        File croppedImageFile = File(croppedFile.path);
        // 크롭이 완료된 경우 다음 화면으로 이동
        _uploadFile(croppedImageFile);

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
          // 이미지 파일이 있을 때만 표시
          Visibility(
            visible: _imageFile != null, // 이미지 파일이 있으면 표시
            child: Positioned.fill(
              child: _imageFile != null
                  ? Image.file(
                _imageFile!,
                fit: BoxFit.cover,
              )
                  : const SizedBox(), // _imageFile이 없을 때 빈 공간을 사용
            ),
          ),

          // 로딩 중일 때만 GIF 표시
          Visibility(
            visible: _isLoading, // 로딩 중일 때만 표시
            child: Center(
              child: Image.asset(
                'assets/images/스마트렌즈-로딩.gif',
                height: 100,
                width: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _uploadFile(File croppedImageFile) async {
    SharedPreferencesManager.getInstance().then((pref) {
      final mtIdx = pref.getMtIdx();

      final MultipartFile file = MultipartFile.fromFileSync(
        croppedImageFile.path,
        contentType: DioMediaType("image", "jpg"),
      );
      final formData = FormData.fromMap({
        'mt_idx': mtIdx,
        'search_img': file,
      });

      ref.read(smartLensModelProvider.notifier).photoUpload(formData).then((resultData) {
        if (resultData != null) {
          if (resultData.result == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SmartLensResult(imagePath: croppedImageFile),
              ),
            );
          }
        } else {
          Utils.getInstance().showSnackBar(context, "Network Or Data Error");
        }
      });
    });
  }
}
