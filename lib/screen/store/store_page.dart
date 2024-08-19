import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/screen/store/component/store_favorie_page.dart';
import 'package:BliU/screen/store/component/store_raking_page.dart';
import 'package:BliU/screen/store/component/store_style_group_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dummy/store_ranking.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}
class _StorePageState extends State<StorePage> with SingleTickerProviderStateMixin {
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
        backgroundColor: Colors.white,
        title: const Text('스토어'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '랭킹'),
            Tab(text: '즐겨찾기'),
          ],
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,

        ),
      ),
      body:TabBarView(
        controller: _tabController,
        children: [
          StoreRakingPage(),
          StoreFavoriePage(),
        ],
      ),
    );
  }
}
