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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(
                'assets/images/my/gender_select_boy.png'),
            backgroundColor: Colors.pinkAccent,
          ),
          const SizedBox(width: 10),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                    memberInfoData?.mtId ?? ""
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
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
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text('내정보수정',style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }
}
