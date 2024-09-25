import 'package:BliU/data/member_info_data.dart';
import 'package:BliU/screen/login/login_screen.dart';
import 'package:BliU/screen/mypage/component/top/component/my_info_edit_check.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class MyInfo extends StatelessWidget {
  final MemberInfoData? memberInfoData;
  const MyInfo({super.key, required this.memberInfoData});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           ClipOval(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFE4DF),
              ),
              child: Image.asset(
                  'assets/images/my/gender_select_boy.png'),
            )
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${memberInfoData?.mtName ?? ""}님 안녕하세요',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      memberInfoData?.mtId ?? "",
                    style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    color: Color(0xFF7B7B7B),
                  ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyInfoEditCheck(),
                ),
              );

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => LoginScreen(),
              //   ),
              // );
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Color(0xFFDDDDDD)),
                ),
                child: Text('내정보수정',style: TextStyle(color: Colors.black, fontSize: Responsive.getFont(context, 12)),)),
          ),
        ],
      );
  }
}
