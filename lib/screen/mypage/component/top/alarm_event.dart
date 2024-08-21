import 'package:BliU/screen/mypage/component/bottom/event_detail.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bottom/notice_detail.dart';

class AlarmEvent extends StatelessWidget {
  const AlarmEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // 전체 컨테이너를 클릭 가능한 위젯으로 만듭니다.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetail(), // 클릭 시 이동할 화면
          ),
        );
      },
      child: Container(
        width: double.infinity,
        child: Container(
          width: Responsive.getWidth(context, 380),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: SizedBox(
                  width: Responsive.getWidth(context, 50),
                  height: Responsive.getWidth(context, 50),
                  child: SvgPicture.asset(
                    'assets/images/home/cate_ic_store.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(
                width: Responsive.getWidth(context, 15),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: Responsive.getWidth(context, 315),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '이벤트',
                            style: TextStyle(
                              color: Color(0xFFFF6192),
                              fontSize: Responsive.getFont(context, 15),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: Responsive.getWidth(context, 5),
                          ),
                          Text(
                            '여름 신상 레인코트 입고 안내',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Responsive.getFont(context, 15),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Responsive.getHeight(context, 8),
                      ),
                      SizedBox(
                        child: Text(
                          '귀엽고 실용적인 레인코트로 우리 아이 비 오는 날도 즐겁게! 다양한 디자인과 컬러로 장마철을 더욱 특별하게 만들어보세요.',
                          style: TextStyle(
                            color: Color(0xFF7B7B7B),
                            fontSize: Responsive.getFont(context, 14),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: Responsive.getHeight(context, 8),
                      ),
                      SizedBox(
                        child: Text(
                          '2023-01-01',
                          style: TextStyle(
                            color: Color(0xFF7B7B7B),
                            fontSize: Responsive.getFont(context, 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: Responsive.getWidth(context, 21),
              ),
              Padding(
                padding: EdgeInsets.only(top: Responsive.getHeight(context, 28)),
                child: SizedBox(
                  child: SvgPicture.asset(
                    'assets/images/ic_link.svg',
                    width: Responsive.getWidth(context, 14),
                    height: Responsive.getHeight(context, 14),
                    fit: BoxFit.contain,
                    color: Color(0xFF7B7B7B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

