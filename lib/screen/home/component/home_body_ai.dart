import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/home/viewmodel/home_body_ai_view_model.dart';
import 'package:BliU/screen/product/component/list/product_list_card.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBodyAi extends ConsumerStatefulWidget {
  const HomeBodyAi({super.key});

  @override
  ConsumerState<HomeBodyAi> createState() => _HomeBodyAiState();
}

class _HomeBodyAiState extends ConsumerState<HomeBodyAi> {
  // 각 아이템의 좋아요 상태를 저장하는 리스트
  List<ProductData> _productList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI 추천 상품',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          Container(
            height: 310,
            margin: const EdgeInsets.only(top: 20),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _productList.length, // 리스트의 길이를 사용
              itemBuilder: (context, index) {
                final productData = _productList[index];
                return Container(
                  width: 160,
                  padding: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ProductListCard(productData: productData),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    // TODO 회원 비회원 처리 필요
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
    };

    final productListResponseDTO = await ref.read(homeBodyAiViewModelProvider.notifier).getList(requestData);
    if (productListResponseDTO != null) {
      if (productListResponseDTO.result == true) {
        setState(() {
          _productList = productListResponseDTO.list;
        });
      }
    }
  }
}
