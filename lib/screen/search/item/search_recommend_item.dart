import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/main/page_screen/home/view_model/home_body_ai_view_model.dart';
import 'package:BliU/screen/product_list/item/product_list_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchRecommendItem extends ConsumerStatefulWidget {
  const SearchRecommendItem({super.key});

  @override
  ConsumerState<SearchRecommendItem> createState() => SearchRecommendItemState();
}

class SearchRecommendItemState extends ConsumerState<SearchRecommendItem> {
  List<bool> isFavoriteList = List<bool>.generate(10, (index) => false);
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40, left: 16),
            child: Text(
              '이런 아이템은 어떠세요?',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 18),
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _productList.length, // 리스트의 길이를 사용
                itemBuilder: (context, index) {
                  final productData = _productList[index];
                  return Container(
                    margin: EdgeInsets.only(left: index == 0 ? 16 : 0),
                    padding: const EdgeInsets.only(right: 12),
                    width: 160,
                    child: ProductListItem(productData: productData, bottomVisible: false),
                  );
                },
              ),
            ),
          ),
        ],
      );
  }
  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
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
