import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bottom/notice_detail.dart';

class AlarmNotice extends StatefulWidget {
  const AlarmNotice({super.key});

  @override
  _AlarmNoticeState createState() => _AlarmNoticeState();
}

class _AlarmNoticeState extends State<AlarmNotice> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPressed = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeDetail(),
          ),
        );
      },
      child: Container(
        color: _isPressed ? Colors.white : Color(0xFFF5F9F9), // 눌린 상태에 따라 색상 변경
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
                            '공지',
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
                          '여러분 안녕하세요! 장마철을 대비해 새롭게 입고된 여름 신상 레인코트를 소개합니다. 다양한 디자인과 컬러로 구성되어 있어 아이들이 더욱 즐겁게 장마철',
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
