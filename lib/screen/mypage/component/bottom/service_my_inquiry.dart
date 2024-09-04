import 'package:BliU/screen/mypage/component/bottom/service_inquiry_one.dart';
import 'package:BliU/screen/mypage/component/bottom/service_inquiry_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceMyInquiryScreen extends StatefulWidget {
  const ServiceMyInquiryScreen({super.key});

  @override
  _ServiceMyInquiryScreenState createState() => _ServiceMyInquiryScreenState();
}

class _ServiceMyInquiryScreenState extends State<ServiceMyInquiryScreen> with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '문의내역',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: '상품 문의내역'),
            Tab(text: '1:1 문의내역'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ServiceInquiryProduct(),
          ServiceInquiryOne(),
        ],
      ),
    );
  }
}
