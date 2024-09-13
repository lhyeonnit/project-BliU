import 'package:BliU/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductOrderBottomOption extends StatefulWidget {
  const ProductOrderBottomOption({super.key});

  static void showBottomSheet(BuildContext context) {
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
        return const ProductOrderBottomOptionContent();
      },
    );
  }

  @override
  State<ProductOrderBottomOption> createState() =>
      _ProductOrderBottomOptionState();
}

class _ProductOrderBottomOptionState extends State<ProductOrderBottomOption> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProductOrderBottomOptionContent extends StatefulWidget {
  const ProductOrderBottomOptionContent({super.key});

  @override
  _ProductOrderBottomOptionContentState createState() =>
      _ProductOrderBottomOptionContentState();
}

class _ProductOrderBottomOptionContentState extends State<ProductOrderBottomOptionContent> {
  final ScrollController _scrollController = ScrollController();

  // 상태 변수
  bool isColorSelected = false;
  bool isSizeSelected = false;
  bool isOtherSelected = false;
  String? selectedColor;
  String? selectedSize;
  String? selectedOther;
  List<String> colors = ['베이지', '그레이'];
  List<String> sizes = ['90', '110', '120'];
  List<String> others = ['목걸이', '팔찌'];
  int productPrice = 9900;
  int additionalProductPrice = 0;
  int shippingCost = 2500;

  // 옵션 선택 로직
  void selectColor(String color) {
    setState(() {
      selectedColor = color;
      isColorSelected = true;
    });
  }

  void selectSize(String size) {
    setState(() {
      selectedSize = size;
      isSizeSelected = true;
    });
  }

  void selectOther(String other) {
    setState(() {
      selectedOther = other;
      isOtherSelected = true;
    });
  }

  void toggleAdditionalItem() {
    setState(() {
      isOtherSelected = !isOtherSelected;
      additionalProductPrice = isOtherSelected ? 5000 : 0;
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
                  decoration: BoxDecoration(
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
                          child: Column(
                            children: [
                              // 색상 선택
                              _buildExpansionTile(
                                title: selectedColor != null ? '색상 / $selectedColor' : '색상',
                                options: colors,
                                onSelected: (color) {
                                  setState(() {
                                    selectedColor = color;
                                  });
                                },
                                isEnabled: true, // 색상은 항상 활성화
                              ),

                              // 색상이 선택된 경우에만 사이즈 선택 가능
                              if (selectedColor != null)
                                _buildExpansionTile(
                                  title: selectedSize != null ? '사이즈 / $selectedSize' : '사이즈',
                                  options: sizes,
                                  onSelected: (size) {
                                    setState(() {
                                      selectedSize = size;
                                    });
                                  },
                                  isEnabled: true, // 사이즈는 색상 선택 후 활성화
                                ),

                              // 색상이 선택된 경우에만 추가상품 선택 가능
                              if (selectedColor != null)
                                _buildExpansionTile(
                                  title: selectedOther != null ? '추가상품 / $selectedOther' : '추가상품',
                                  options: others,
                                  onSelected: (other) {
                                    setState(() {
                                      selectedOther = other;
                                    });
                                  },
                                  isEnabled: true, // 추가상품은 색상 선택 후 활성화
                                ),
                              if (selectedColor != null && selectedSize != null)
                                Container(
                                  margin: EdgeInsets.only(bottom: 50),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 15),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF5F9F9),
                                          borderRadius: BorderRadius.all(Radius.circular(6)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 12),
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
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 6,
                                                    horizontal: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(22)),
                                                    border: Border.all(color: Color(0xFFE3E3E3)),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        child: Icon(CupertinoIcons.minus, size: 20),
                                                        onTap: () {},
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                                        child: Text(
                                                          '1',
                                                          style: TextStyle(
                                                            fontSize: Responsive.getFont(context, 14),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: Icon(Icons.add, size: 20),
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
                  ),
            ],
          ),
        if (selectedColor != null && selectedSize != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildActionButtons(context),
          ),
      ],
    );

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
    int totalPrice = productPrice + additionalProductPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceRow('상품금액', '$totalPrice원'),
          const SizedBox(height: 15),
          _buildPriceRow('배송비', '$shippingCost원'),
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
