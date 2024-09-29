import 'package:BliU/data/store_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreInfoPage extends ConsumerStatefulWidget {
  final StoreData? storeData;

  StoreInfoPage({super.key, required this.storeData});

  @override
  _StoreInfoPageState createState() => _StoreInfoPageState();
}

class _StoreInfoPageState extends ConsumerState<StoreInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stack으로 이미지와 로고를 겹치기
          Stack(
            clipBehavior: Clip.none, // 클리핑을 하지 않도록 설정
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.storeData?.stBackground ?? "",
                  width: double.infinity,
                  height: 500,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -30, // 이미지 하단에 겹치도록 설정
                left: 15,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x29000000),
                        blurRadius: 3.0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.storeData?.stProfile ?? "",
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 45),
          // 상점 정보 부분
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상점명 및 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.storeData?.stName ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 18),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            widget.storeData?.stStyleTxt?.split(',').first ?? "",
                            // 쉼표로 분리 후 첫 번째 값만 가져옴
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 13),
                              color: const Color(0xFF7B7B7B),
                              height: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            ', ',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 13),
                              color: const Color(0xFF7B7B7B),
                              height: 1.2,
                            ),
                          ),
                          Text(
                            widget.storeData?.stAgeTxt ?? "",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 13),
                              color: const Color(0xFF7B7B7B),
                              height: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 즐겨찾기 및 아이콘
                GestureDetector(
                  onTap: () {
                    // TODO 즐겨찾기 버튼 활성화
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFDDDDDD)),
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '즐겨찾기 ${widget.storeData?.stLike}',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(width: 8), // 텍스트와 아이콘 사이의 간격
                            Container(
                              child: SvgPicture.asset(
                                'assets/images/store/book_mark.svg',
                                color: isSelected == true
                                    ? const Color(0xFFFF6192)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 설명 텍스트
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              '저희 키즈 의류 쇼핑몰은 다양한 스타일과 고품질의 어린이 의류 브랜드들을 자랑합니다. 각 브랜드는 아이들의 편안함과 안전을 최우선으로 생각하며, 트렌디하면서도 실용적인 디자인을 제공합니다. 모든 의류는 친환경 소재로 제작되어 아이들의 민감한 피부에도 심하고 착용할 수 있습니다.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
                color: const Color(0xFF7B7B7B),
                height: 1.2,
              ),
            ),
          ),

          // 쿠폰 다운로드 버튼
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            margin: EdgeInsets.only(bottom: 15),
            child: GestureDetector(
              onTap: () {
                // TODO coupon download
              },
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xFFDDDDDD)),
                ),
                child: Center(
                  child: Text(
                    '쿠폰 다운로드',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
