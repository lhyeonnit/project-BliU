import 'package:BliU/screen/my_inquiry/child_widget/my_inquiry_one_child_widget.dart';
import 'package:BliU/screen/my_inquiry/child_widget/my_inquiry_product_child_widget.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyInquiryScreen extends StatefulWidget {
  const MyInquiryScreen({super.key});

  @override
  State<MyInquiryScreen> createState() => MyInquiryScreenState();
}

class MyInquiryScreenState extends State<MyInquiryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('문의내역'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60 + 1.0), // TabBar 높이 + 구분선 두께
          child: Column(
            children: [
              // 구분선
              Container(
                color: const Color(0x0D000000), // 하단 구분선 색상
                height: 1.0, // 구분선의 두께 설정
                child: Container(
                  height: 1.0, // 그림자 부분의 높이
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 6.0,
                        spreadRadius: 0.1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              // TabBar
              SizedBox(
                height: 60,
                child: TabBar(
                  controller: _tabController,
                  labelStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: '상품 문의내역'),
                    Tab(text: '1:1 문의내역'),
                  ],
                  overlayColor: WidgetStateColor.transparent,
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // 인디케이터가 각 탭의 길이에 맞게 조정됨
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xFF7B7B7B),
                  dividerColor: const Color(0xFFDDDDDD),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            MyInquiryProductChildWidget(),
            MyInquiryOneChildWidget(),
          ],
        ),
      ),
    );
  }
}
