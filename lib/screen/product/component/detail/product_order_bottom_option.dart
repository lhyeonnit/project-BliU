import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/payment/payment_screen.dart';
import 'package:BliU/screen/product/component/detail/product_bottom_option_addition.dart';
import 'package:BliU/screen/product/component/detail/product_bottom_option_detail.dart';
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
  bool _isExpanded = false;

  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> selectedOptions = [];

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
  // 선택한 색상, 사이즈 값을 저장한 후 초기화
  void saveSelection() {
    if (selectedColor != null && selectedSize != null) {
      setState(() {
        selectedOptions.add({
          'color': selectedColor!,
          'size': selectedSize!,
        });

        // 선택한 값 리셋
        selectedColor = null;
        selectedSize = null;
        isColorSelected = false;
        isSizeSelected = false;
      });
    }
  }
  // 선택한 옵션 삭제 로직
  void removeOption(int index) {
    setState(() {
      selectedOptions.removeAt(index);
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
             Container(
               height: 378.5,
               child: SingleChildScrollView(
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
                                  title: selectedColor != null ? '$selectedColor' : '색상',
                                  options: colors,
                                  onSelected: (color) {
                                    setState(() {
                                      selectedColor = color;
                                      saveSelection;
                                    });
                                  },
                                  isEnabled: true, // 색상은 항상 활성화
                                ),

                                // 색상이 선택된 경우에만 사이즈 선택 가능
                                if (selectedColor != null)
                                  _buildExpansionTile(
                                    title: selectedSize != null ? '$selectedSize' : '사이즈',
                                    options: sizes,
                                    onSelected: (size) {
                                      setState(() {
                                        selectedSize = size;
                                        saveSelection;
                                      });
                                    },
                                    isEnabled: true, // 사이즈는 색상 선택 후 활성화
                                  ),

                                // 색상이 선택된 경우에만 추가상품 선택 가능
                                if (selectedColor != null)
                                  _buildExpansionTile(
                                    title: selectedOther != null ? '$selectedOther' : '추가상품',
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
                                        ProductBottomOptionDetail(onRemove: () => removeOption),
                                        if (selectedOther != null)
                                          Container(
                                            child: Column(
                                              children: [
                                                ProductBottomOptionAddition(),
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
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: options.map((option) {
            return ListTile(
              title: Text(
                option,
                style: TextStyle(fontSize: Responsive.getFont(context, 14)),
              ),
              onTap: isEnabled
                  ? () {
                onSelected(option);
                setState(() {
                  _isExpanded = false; // 선택하면 닫힘
                });
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
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
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const PaymentScreen(cartDetails: cartDetails),
                //   ),
                // );
              },
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
