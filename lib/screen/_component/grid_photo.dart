import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class GridPhoto extends StatefulWidget {
  List<AssetEntity> images;

  GridPhoto({
    required this.images,
    Key? key,
  }) : super(key: key);

  @override
  State<GridPhoto> createState() => _GridPhotoState();
}

class _GridPhotoState extends State<GridPhoto> {
  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const BouncingScrollPhysics(),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      children: widget.images.map((e) {
        return AssetEntityImage(
          e,
          isOriginal: false,
          fit: BoxFit.cover,
        );
      }).toList(),
    );
  }
}