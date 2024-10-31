import 'package:BliU/screen/_component/smart_lens_photo_crop.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class GridPhoto extends StatefulWidget {
  final List<AssetEntity> images;

  const GridPhoto({required this.images, super.key,});

  @override
  State<GridPhoto> createState() => GridPhotoState();
}

class GridPhotoState extends State<GridPhoto> {
  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      children: widget.images.map((e) {
        return GestureDetector(
          onTap: () {
            // 이미지를 터치했을 때 로딩 화면으로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SmartLensPhotoCrop(
                  imageEntity: e, // 선택한 이미지 데이터를 전달
                ),
              ),
            );
          },
          child: AssetEntityImage(
            e,
            isOriginal: false,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }
}
