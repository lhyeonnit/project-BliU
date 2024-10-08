import 'package:BliU/data/member_info_data.dart';
import 'package:BliU/screen/mypage/component/top/component/my_info_edit_check.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyInfo extends ConsumerStatefulWidget {
  final MemberInfoData? memberInfoData;

  const MyInfo({super.key, required this.memberInfoData});

  @override
  ConsumerState<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends ConsumerState<MyInfo> {
  MemberInfoData? memberInfoData;
  @override
  void initState() {
    super.initState();
    memberInfoData = widget.memberInfoData;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
            child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFE4DF),
          ),
          child: Image.asset('assets/images/my/gender_select_boy.png'),
        )),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${memberInfoData?.mtName ?? ""}님 안녕하세요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 18),
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                Text(
                  memberInfoData?.mtId ?? "",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: const Color(0xFF7B7B7B),
                    height: 1.2,
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
                builder: (context) => MyInfoEditCheck(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            child: Text(
              '내정보수정',
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: Colors.black,
                fontSize: Responsive.getFont(context, 12),
                height: 1.2,
              ),
            )
          ),
        ),
      ],
    );
  }
}
