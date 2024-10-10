import 'package:BliU/screen/home/viewmodel/home_footer_view_model.dart';
import 'package:BliU/screen/mypage/component/bottom/component/terms_detail.dart';
import 'package:BliU/screen/mypage/component/bottom/notice_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeFooter extends ConsumerStatefulWidget {
  const HomeFooter({ super.key });

  @override
  HomeFooterState createState() => HomeFooterState();
}

class HomeFooterState extends ConsumerState<HomeFooter> with TickerProviderStateMixin {
  bool isExpand = true;
  String footInfo = '회사명 : #####  |  대표 : ###\n'
      '사업자등록번호 ############\n'
      '제 통신판매업신고번호 : ###############\n'
      '주소 : ####################';

  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(footerViewModelProvider.notifier).getFoot().then((model) {
        if (model?.footResponseDTO != null) {
          if (model?.footResponseDTO?.result == true) {
            var data = model?.footResponseDTO?.data;
            if (data != null) {
              setState(() {
                footInfo =
                '회사명 : ${data.stCompanyName}  |  대표 : ${data.stCompanyBoss}\n'
                    '사업자등록번호 ${data.stCompanyNum1}\n'
                    '제 통신판매업신고번호 : ${data.stCompanyNum2}\n'
                    '주소 : ${data.stCompanyAdd}';
              });
            }
          } else {
            Future.delayed(Duration.zero, () {
              Utils.getInstance().showSnackBar(context, model?.footResponseDTO?.message ?? "");
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: const Color(0xFFF5F9F9), // 배경 색상
      padding: const EdgeInsets.only(top: 40, bottom: 37),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NoticeScreen()),
                  );
                },
                child: Text(
                  '공지사항',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    color: const Color(0xFF7B7B7B),
                    fontSize: Responsive.getFont(context, 13),
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    vertical: BorderSide(color: Color(0xFFDDDDDD))
                  )
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsDetail(type: 0),
                      ),
                    );
                  },
                  child: Text(
                    '이용약관',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: const Color(0xFF7B7B7B),
                      fontSize: Responsive.getFont(context, 13),
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsDetail(type: 1),
                    ),
                  );
                },
                child: Text(
                  '개인정보처리방침',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    color: const Color(0xFF7B7B7B),
                    fontSize: Responsive.getFont(context, 13),
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpand = !isExpand;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '사업자 정보',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: const Color(0xFF7B7B7B),
                      fontSize: Responsive.getFont(context, 13),
                      height: 1.2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: SvgPicture.asset(
                        isExpand ? 'assets/images/home/ft_collapse.svg' : 'assets/images/home/filter_select.svg',
                        color: const Color(0xFF7B7B7B)
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn,
            child: Container(
              child: !isExpand
                  ? null
                  :
              Text(
                footInfo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: const Color(0xFF7B7B7B),
                  fontSize: Responsive.getFont(context, 12),
                  height: 1.2,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              'Copyright © 2024 블리유. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: const Color(0xFF7B7B7B),
                fontSize: Responsive.getFont(context, 12),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
