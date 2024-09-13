import 'package:BliU/data/add_option_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/product_option_data.dart';
import 'package:BliU/data/product_option_type_data.dart';
import 'package:BliU/data/product_option_type_detail_data.dart';
import 'package:BliU/screen/product/viewmodel/product_order_bottom_option_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductOrderBottomOption extends ConsumerStatefulWidget {

  const ProductOrderBottomOption({super.key});

  static void showBottomSheet(BuildContext context, ProductData productData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return ProductOrderBottomOptionContent(productData: productData);
      },
    );
  }

  @override
  _ProductOrderBottomOptionState createState() => _ProductOrderBottomOptionState();
}

class _ProductOrderBottomOptionState extends ConsumerState<ProductOrderBottomOption> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProductOrderBottomOptionContent extends ConsumerStatefulWidget {
  final ProductData productData;
  const ProductOrderBottomOptionContent({super.key, required this.productData});

  @override
  _ProductOrderBottomOptionContentState createState() => _ProductOrderBottomOptionContentState();
}

class _ProductOrderBottomOptionContentState extends ConsumerState<ProductOrderBottomOptionContent> {
  final ScrollController _scrollController = ScrollController();
  late ProductData _productData;
  ProductOptionData? _productOptionData;
  List<ProductOptionTypeData> _ptOption = [];
  List<ProductOptionTypeDetailData> _ptOptionArr = [];
  List<AddOptionData> _ptAddArr = [];

  @override
  void initState() {
    super.initState();
    _productData = widget.productData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15, bottom: 17),
                width: 40,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              ),
            ),
            // 스크롤 가능한 영역 시작
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _ptOption.length, // 리스트의 길이를 사용
                      itemBuilder: (context, index) {
                        final productOptionTypeData = _ptOption[index];

                        return _buildExpansionTile(
                          title: productOptionTypeData.title ?? "",
                          options: productOptionTypeData.children ?? [],
                          onSelected: (size) {
                            // setState(() {
                            //   selectedSize = size;
                            // });
                          },
                          isEnabled: true, // 사이즈는 색상 선택 후 활성화
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          border: Border.all(color: const Color(0xFFE1E1E1)),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            '추가상품',
                            style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                          ),
                          children: _ptAddArr.map((option) {
                            return ListTile(
                              title: Text(
                                option.option ?? "",
                                style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                              ),
                              onTap: () {
                                // TODO 선택시
                                //onSelected(option);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F9F9),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '베이지/110',
                                      style: TextStyle(
                                        fontSize: Responsive.getFont(context, 14),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset('assets/images/ic_del.svg'),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: Responsive.getWidth(context, 96),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                                      border: Border.all(color: const Color(0xFFE3E3E3)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: const Icon(CupertinoIcons.minus, size: 20),
                                          onTap: () {},
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                              fontSize: Responsive.getFont(context, 14),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: const Icon(Icons.add, size: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '9,900원',
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _buildPriceSummary(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // if (selectedColor != null && selectedSize != null)
        //   Positioned(
        //     bottom: 0,
        //     left: 0,
        //     right: 0,
        //     child: _buildActionButtons(context),
        //   ),
      ],
    );

  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    Map<String, dynamic> requestData = {
      'pt_idx' : _productData.ptIdx,
    };
    final responseDto = await ref.read(productOrderBottomOptionModelProvider.notifier).getList(requestData);
    if (responseDto != null) {
      setState(() {
        _productOptionData = responseDto.data;
        _ptOption = responseDto.data?.ptOption ?? [];
        _ptOptionArr = responseDto.data?.ptOptionArr ?? [];
        _ptAddArr = responseDto.data?.ptAddArr ?? [];
      });
    }
  }

  // 색상, 사이즈, 추가상품 옵션 박스
  Widget _buildExpansionTile({
    required String title,
    required List<String> options,
    required Function(String) onSelected,
    required bool isEnabled,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Color(0xFFE1E1E1)),
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(fontSize: Responsive.getFont(context, 14)),
          ),
          children: options.map((option) {
            return ListTile(
              title: Text(
                option,
                style: TextStyle(fontSize: Responsive.getFont(context, 14)),
              ),
              onTap: isEnabled
                  ? () {
                onSelected(option);
              }
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  // 상품 및 가격 정보 표시
  Widget _buildPriceSummary(BuildContext context) {
    // int totalPrice = productPrice + additionalProductPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceRow('상품금액', '100000원'),
          const SizedBox(height: 15),
          _buildPriceRow('배송비', '3000원'),
        ],
      ),
    );
  }

  // 가격 Row
  Widget _buildPriceRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: Responsive.getFont(context, 14)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.getFont(context, 14),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // 장바구니 및 구매하기 버튼
  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 9, bottom: 8, left: 16, right: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                height: Responsive.getHeight(context, 48),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                ),
                child: Center(
                  child: Text(
                    '장바구니',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 14),
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(left: 4),
                height: Responsive.getHeight(context, 48),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Center(
                  child: Text(
                    '구매하기',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 14),
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}