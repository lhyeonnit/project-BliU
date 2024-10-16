//스마트 렌즈
import 'package:BliU/screen/_component/grid_photo.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';

class SmartLensScreen extends StatefulWidget {
  const SmartLensScreen({super.key});

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
    final permissionState = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(type: RequestType.image, mediaLocation: true),
      ),
    );
    final hasPhotoPermission = permissionState.isAuth;

    if (hasPhotoPermission) {
      await getAlbum();
    } else {
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
        name: e.isAll ? '최근항목' : e.name,
      );
    }).toList();

    await getPhotos(_albums[0], albumChange: true);
  }

  Future<void> getPhotos(Album album, {bool albumChange = false}) async {
    _currentAlbum = album;

    // 앨범 내 사진 총 개수 가져오기
    final totalAssets = await _paths!
        .singleWhere((AssetPathEntity e) => e.id == album.id)
        .assetCountAsync;

    final loadImages = await _paths!
        .singleWhere((AssetPathEntity e) => e.id == album.id)
        .getAssetListRange(start: 0, end: totalAssets);

    setState(() {
      _images = loadImages;
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
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
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
                margin: const EdgeInsets.only(right: 16),
                child: SvgPicture.asset('assets/images/product/ic_close.svg')),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 40),
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: _buildSmartLensInfo(
                      "assets/images/home/그룹 37779.png",
                      '이미지 검색 기능',
                      '사용자가 사진을 찍거나 이미지를 업로드하면, \n해당 이미지와 유사한 패션 아이템을 찾아줍니다.'),
                ),
                _buildSmartLensInfo(
                    "assets/images/home/그룹 37234.png",
                    '인공지능 기반 추천',
                    '인공지능(AI)을 활용해 사용자의 취향을 분석하고, \n관련된 패션 아이템을 추천')
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(left: 16),
            child: _albums.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,

                        builder: (BuildContext context) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: _albums.map((album) {
                                return ListTile(
                                  title: Text(
                                    album.name,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onTap: () {
                                    getPhotos(album, albumChange: true);
                                    Navigator.pop(context);
                                  },
                                );
                              }).toList(),
                            );
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentAlbum.name,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              fontWeight: FontWeight.w600,
                              color: Colors.black, // 텍스트 색상
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: SvgPicture.asset(
                              'assets/images/product/ic_select.svg',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scroll) {
                final scrollPixels =
                    scroll.metrics.pixels / scroll.metrics.maxScrollExtent;
                if (scrollPixels > 0.7) getPhotos(_currentAlbum);
                return false;
              },
              child: SafeArea(
                child: _paths == null
                    ? const Center(child: CircularProgressIndicator())
                    : GridPhoto(images: _images),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartLensInfo(
    String image,
    String title,
    String content,
  ) {
    return Row(
      children: [
        Container(
          width: 84,
          height: 84,
          margin: const EdgeInsets.only(right: 15),
          child: Image.asset(image),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 16),
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  )),
              Text(
                content,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: const Color(0xFF7B7B7B),
                  fontSize: Responsive.getFont(context, 12),
                  height: 1.2,
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
