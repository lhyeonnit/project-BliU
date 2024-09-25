//스마트 렌즈
import 'dart:typed_data';

import 'package:BliU/screen/_component/grid_photo.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';

class SmartLensScreen extends StatefulWidget {
  const SmartLensScreen({Key? key}) : super(key: key);

  @override
  State<SmartLensScreen> createState() => _SmartLensScreenState();
}

class Album {
  String id;
  String name;

  Album({
    required this.id,
    required this.name,
  });
}

class _SmartLensScreenState extends State<SmartLensScreen> {
  List<AssetPathEntity>? _paths; // 모든 파일 정보
  List<Album> _albums = []; // 드롭다운 앨범 목록
  late List<AssetEntity> _images = []; // 앨범의 이미지 목록
  int _currentPage = 0; // 현재 페이지
  late Album _currentAlbum; // 드롭다운 선택된 앨범

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<void> checkPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth) {
      // 권한 수락
      await getAlbum();
    } else {
      // 권한 거절
      await PhotoManager.openSetting();
    }
  }

  Future<void> getAlbum() async {
    _paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    _albums = _paths!.map((e) {
      return Album(
        id: e.id,
        name: e.isAll ? '모든 사진' : e.name,
      );
    }).toList();

    await getPhotos(_albums[0], albumChange: true);
  }

  Future<void> getPhotos(
    Album album, {
    bool albumChange = false,
  }) async {
    _currentAlbum = album;
    albumChange ? _currentPage = 0 : _currentPage++;

    final loadImages = await _paths!
        .singleWhere((AssetPathEntity e) => e.id == album.id)
        .getAssetListPaged(
          page: _currentPage,
          size: 20,
        );

    setState(() {
      if (albumChange) {
        _images = loadImages;
      } else {
        _images.addAll(loadImages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text("스마트렌즈"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin: EdgeInsets.only(right: 16),
                child: SvgPicture.asset('assets/images/product/ic_close.svg')),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 40),
            padding: EdgeInsets.only(left: 16,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: _buildSmartLensInfo(0x24000000, '이미지 검색 기능',
                      '사용자가 사진을 찍거나 이미지를 업로드하면, 해당 이미지와 유사한 패션 아이템을 찾아줍니다.'),
                ),
                _buildSmartLensInfo(0xFFF5F9F9, '인공지능 기반 추천',
                    '인공지능(AI)을 활용해 사용자의 취향을 분석하고, 관련된 패션 아이템을 추천')
              ],
            ),
          ),
          Container(
              child: _albums.isNotEmpty
                  ? DropdownButton(
                      value: _currentAlbum,
                      items: _albums
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (Album? value) =>
                          getPhotos(value!, albumChange: true),
                    )
                  : const SizedBox()),
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scroll) {
              final scrollPixels =
                  scroll.metrics.pixels / scroll.metrics.maxScrollExtent;

              print('scrollPixels = $scrollPixels');
              if (scrollPixels > 0.7) getPhotos(_currentAlbum);

              return false;
            },
            child: SafeArea(
              child: _paths == null
                  ? const Center(child: CircularProgressIndicator())
                  : GridPhoto(images: _images),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartLensInfo(
    int color,
    String title,
    String content,
  ) {
    return Row(
      children: [
        Container(
          width: 84,
          height: 84,
          margin: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: Color(color),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: Responsive.getFont(context, 16),
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                width: 276,
                child: Text(
                  content,
                  style: TextStyle(
                      color: Color(0xFF7B7B7B),
                      fontSize: Responsive.getFont(context, 12)),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
