import 'dart:convert';

import 'package:BliU/data/add_option_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/product_option_data.dart';
import 'package:BliU/data/product_option_type_data.dart';
import 'package:BliU/data/product_option_type_detail_data.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/cart/cart_screen.dart';
import 'package:BliU/screen/join_add_info/join_add_info_screen.dart';
import 'package:BliU/screen/modal_dialog/view_model/product_order_bottom_option_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductOrderBottomOption extends ConsumerStatefulWidget {
  const ProductOrderBottomOption({super.key});

  static void showBottomSheet(BuildContext context, ProductData productData) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      barrierColor: Colors.black.withOpacity(0.3),
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      // set this to true
      useSafeArea: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            snap: true,
            builder: (context, scrollController) {
              return ProductOrderBottomOptionContent(
                productData: productData,
                scrollController: scrollController,
              );
            },
          ),
        );
      }
    );
  }

  @override
  ConsumerState<ProductOrderBottomOption> createState() => ProductOrderBottomOptionState();
}

class ProductOrderBottomOptionState extends ConsumerState<ProductOrderBottomOption> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProductOrderBottomOptionContent extends ConsumerStatefulWidget {
  final ProductData productData;
  final ScrollController scrollController;

  const ProductOrderBottomOptionContent(
      {super.key, required this.productData, required this.scrollController});

  @override
  ConsumerState<ProductOrderBottomOptionContent> createState() => ProductOrderBottomOptionContentState();
}

class ProductOrderBottomOptionContentState extends ConsumerState<ProductOrderBottomOptionContent> {
  late ProductData _productData;
  ProductOptionData? _productOptionData;
  List<ProductOptionTypeData> _ptOption = [];
  List<ProductOptionTypeDetailData> _ptOptionArr = [];
  List<AddOptionData> _ptAddArr = [];

  final List<ProductOptionTypeDetailData> _addPtOptionArr = [];
  final List<AddOptionData> _addPtAddArr = [];
  List<bool> _isExpandedList = [];
  bool _isOptionSelected = false;
  final _addItemController = ExpansionTileController();

  // 선택된 옵션 값을 저장할 Map, 키는 옵션 제목(title)
  final Map<String, String?> _selectedOptions = {};

  void _onOptionSelected(String option, String title) {
    setState(() {
      _selectedOptions[title] = option; // 선택된 옵션을 저장
      int index = _ptOption.indexWhere((element) => element.title == title);
      if (index != -1) {
        _isExpandedList[index] = false; // 해당 타일 닫기
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _productData = widget.productData;
    _isExpandedList = List.generate(_ptOption.length, (index) => false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15, bottom: 17),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10.5),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: _ptOption.length,
                        // 리스트의 길이를 사용
                        itemBuilder: (context, index) {
                          final optionData = _ptOption[index];
                          final title = optionData.title ?? '';
                          final options = optionData.children ?? [];
                          // 선택된 값이 있으면 표시하고 없으면 기본 타이틀 표시
                          String displayTitle = _selectedOptions[title] == null ? title : "${_selectedOptions[title]}";

                          return _buildExpansionTile(
                            title: displayTitle,
                            options: options,
                            index: index,
                            onSelected: (selectedOption) {
                              setState(() {
                                if (_productOptionData?.ptOptionType == "1" || _productOptionData?.ptOptionChk != "Y") {
                                  // 단독
                                  optionData.selectedValue = selectedOption;

                                  _isOptionSelected = true;

                                  // 모든 옵션의 타이틀 초기화
                                  for (var option in _ptOption) {
                                    _selectedOptions[option.title ?? ''] = null;  // 타이틀 초기화
                                    selectedOption = title;
                                  }
                                } else {
                                  // 조합
                                  // 선택된 옵션 값을 저장
                                  optionData.selectedValue = selectedOption;
                                  _selectedOptions[title] = selectedOption;

                                  // 모든 옵션이 선택되었는지 확인
                                  bool allOptionsSelected = true;
                                  for (var option in _ptOption) {
                                    if (option.selectedValue.isEmpty) {
                                      allOptionsSelected = false;
                                      break;
                                    }
                                  }

                                  // 모든 항목이 선택되면 타이틀을 초기화
                                  if (allOptionsSelected) {
                                    _isOptionSelected = true;

                                    // 모든 옵션의 타이틀 초기화
                                    for (var option in _ptOption) {
                                      _selectedOptions[option.title ?? ''] = null;  // 타이틀 초기화
                                      selectedOption = title;
                                    }
                                  } else {
                                    _isOptionSelected = false;  // 모든 옵션이 선택되지 않으면 false
                                  }
                                }

                                // 옵션 선택 후 처리
                                _selectOptionCheck();
                                _onOptionSelected(selectedOption, title);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: _ptAddArr.isNotEmpty,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            disabledColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            listTileTheme: ListTileTheme.of(context).copyWith(
                              dense: true,
                              minVerticalPadding: 14,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(color: const Color(0xFFE1E1E1)),
                            ),
                            child: ExpansionTile(
                              controller: _addItemController,
                              title: Text(
                                '추가상품',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  height: 1.2,
                                ),
                              ),

                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              children: _ptAddArr.map((ptAdd) {
                                return ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        ptAdd.option ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                      Visibility(
                                        visible: ptAdd.patPrice != null,
                                        child: Text(
                                          " +${ptAdd.patPrice ?? 0}",
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    if (_addPtAddArr.isEmpty) {
                                      setState(() {
                                        _addItemController.collapse();
                                        _addPtAddArr.add(ptAdd);
                                      });
                                    } else {
                                      bool isAdd = true;
                                      for (int i = 0; i < _addPtAddArr.length; i++) {
                                        if (_addPtAddArr[i].idx == ptAdd.idx) {
                                          isAdd = false;
                                        }
                                      }

                                      if (isAdd) {
                                        setState(() {
                                          _addItemController.collapse();
                                          _addPtAddArr.add(ptAdd);
                                        });
                                      } else {
                                        Utils.getInstance().showSnackBar(context, '이미 추가한 상품 입니다.');
                                      }
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //옵션
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _addPtOptionArr.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5F9F9),
                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  _addPtOptionArr[index].option ?? "",
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: Responsive.getFont(context, 14),
                                                    height: 1.2,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _addPtOptionArr[index].potPrice != 0,
                                                  child: Text(
                                                    ' +${_addPtOptionArr[index].potPrice ?? 0}',
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: Responsive.getFont(context, 14),
                                                      fontWeight: FontWeight.w600,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _addPtOptionArr.removeAt(index);
                                              });
                                            },
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
                                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8,),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: const BorderRadius.all(Radius.circular(22)),
                                            border: Border.all(
                                                color: const Color(0xFFE3E3E3)
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                child: const Icon(CupertinoIcons.minus, size: 20),
                                                onTap: () {
                                                  if (_addPtOptionArr[index].count > 1) {
                                                    setState(() {
                                                      _addPtOptionArr[index].count -= 1;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                                child: Text(
                                                  '${_addPtOptionArr[index].count}',
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: Responsive.getFont(context, 14),
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if ((_addPtOptionArr[index].potJaego ?? 0) > _addPtOptionArr[index].count) {
                                                    setState(() {
                                                      _addPtOptionArr[index].count += 1;
                                                    });
                                                  } else {
                                                    Utils.getInstance().showSnackBar(context, "재고가 부족합니다.");
                                                  }
                                                },
                                                child: const Icon(Icons.add, size: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${Utils.getInstance().priceString(_addPtOptionArr[index].count * ((_addPtOptionArr[index].potPrice ?? 0) + (_productData.ptPrice ?? 0)))}원',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // 추가상품
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _addPtAddArr.length,
                        // 리스트의 길이를 사용
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.only(bottom: 15),
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
                                            _addPtAddArr[index].option ?? "",
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              height: 1.2,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _addPtAddArr.removeAt(index);
                                              });
                                            },
                                            child: SvgPicture.asset('assets/images/ic_del.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width:
                                          Responsive.getWidth(context, 96),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(22)),
                                            border: Border.all(
                                                color: const Color(0xFFE3E3E3)),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                child: const Icon(
                                                    CupertinoIcons.minus, size: 20),
                                                onTap: () {
                                                  if (_addPtAddArr[index].count > 1) {
                                                    setState(() {
                                                      _addPtAddArr[index].count -= 1;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                margin:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  '${_addPtAddArr[index].count}',
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: Responsive.getFont(context, 14),
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _addPtAddArr[index].count += 1;
                                                  });
                                                },
                                                child: const Icon(Icons.add, size: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${Utils.getInstance().priceString(_addPtAddArr[index].count * (_addPtAddArr[index].patPrice ?? 0))}원',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                      Visibility(
                        visible: _isOptionSelected,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          margin: const EdgeInsets.only(bottom: 80),
                          child: _buildPriceSummary(context),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _isOptionSelected,
          child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildActionButtons(context),
          ),
        ),
      ],
    );
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    Map<String, dynamic> requestData = {
      'pt_idx': _productData.ptIdx,
    };
    final responseDto = await ref.read(productOrderBottomOptionViewModelProvider.notifier).getList(requestData);
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
    required int index,
    required Function(String) onSelected,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        disabledColor: Colors.transparent,
        dividerColor: Colors.transparent,
        listTileTheme: ListTileTheme.of(context).copyWith(
          dense: true,
          minVerticalPadding: 14,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: const Color(0xFFE1E1E1)),
        ),
        child: ExpansionTile(
          key: UniqueKey(),
          // 각각의 타일이 고유한 상태를 갖도록 함
          initiallyExpanded: index < _isExpandedList.length ? _isExpandedList[index] : false,

          // 타일의 초기 상태 설정
          iconColor: Colors.black,
          collapsedIconColor: Colors.black,
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              height: 1.2,
            ),
          ),
          onExpansionChanged: (bool expanded) {
            setState(() {
              if (index >= _isExpandedList.length) {
                _isExpandedList.addAll(List.generate(index - _isExpandedList.length + 1, (_) => false));
              }
              _isExpandedList[index] = expanded;
            });
          },
          children: options.map((option) {
            return ListTile(
              title: Text(
                option,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
              onTap: () {
                onSelected(option); // 항목이 선택되면 콜백 실행
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // 상품 및 가격 정보 표시
  Widget _buildPriceSummary(BuildContext context) {
    final productPrice = (_productData.ptPrice ?? 0);
    int optionProductPrice = 0;
    int additionalProductPrice = 0;
    for (int i = 0; i < _addPtOptionArr.length; i++) {
      optionProductPrice += (_addPtOptionArr[i].potPrice ?? 0 * _addPtOptionArr[i].count) + (productPrice * _addPtOptionArr[i].count);
    }
    for (int i = 0; i < _addPtAddArr.length; i++) {
      additionalProductPrice += (_addPtAddArr[i].patPrice ?? 0);
    }
    int totalPrice = optionProductPrice + additionalProductPrice;
    String deliveryPriceStr = "";
    if (totalPrice < (_productData.deliveryInfo?.deliveryDetail?.deliveryMinPrice ?? 0)) {
      deliveryPriceStr = "${Utils.getInstance().priceString((_productData.deliveryInfo?.deliveryDetail?.deliveryBasicPrice ?? 0))}원";
    } else {
      if ((_productData.deliveryInfo?.deliveryPrice ?? 0) == 0) {
        deliveryPriceStr = "무료";
      } else {
        deliveryPriceStr = "${Utils.getInstance().priceString((_productData.deliveryInfo?.deliveryPrice ?? 0))}원";
      }
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '상품금액',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
              Text(
                '${Utils.getInstance().priceString(totalPrice)}원',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '배송비',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
              Text(
                deliveryPriceStr,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
            ],
          )
        ],
      ),
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
                _buyAndCartProduct(0);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                height: 48,
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
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _buyAndCartProduct(1);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 4),
                height: 48,
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
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      height: 1.2,
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

  // 옵션 확인
  void _selectOptionCheck() {
    if (_productOptionData?.ptOptionType == "1" && _productOptionData?.ptOptionChk != "Y") {
      // 단독
      var titleValue = "";
      var optionValue = "";
      for (int i = 0; i < _ptOption.length; i++) {
        if (_ptOption[i].selectedValue.isNotEmpty) {
          titleValue = _ptOption[i].title ?? "";
          optionValue = _ptOption[i].selectedValue;

          _ptOption[i].selectedValue = "";
        }
      }

      for (int i = 0; i < _ptOptionArr.length; i++) {
        if (_ptOptionArr[i].title == titleValue && _ptOptionArr[i].option == optionValue) {
          if (_addPtOptionArr.isEmpty) {
            setState(() {
              _addPtOptionArr.add(_ptOptionArr[i]);
            });
          } else {
            bool isAdd = true;
            for (int j = 0; j < _addPtOptionArr.length; j++) {
              if (_addPtOptionArr[j].idx == _ptOptionArr[i].idx) {
                isAdd = false;
              }
            }
            if (isAdd) {
              setState(() {
                _addPtOptionArr.add(_ptOptionArr[i]);
              });
            } else {
              Utils.getInstance().showSnackBar(context, '이미 추가한 옵션 입니다.');
            }
            break;
          }
        }
      }
    } else {
      // 조합
      bool isAllChecked = true;
      String optionStr = "";
      for (int i = 0; i < _ptOption.length; i++) {
        if (_ptOption[i].selectedValue.isEmpty) {
          isAllChecked = false;
        }
        if (optionStr.isEmpty) {
          optionStr = _ptOption[i].selectedValue;
        } else {
          optionStr += " | ${_ptOption[i].selectedValue}";
        }
      }

      if (isAllChecked) {
        bool optionExists = false;
        for (int i = 0; i < _ptOption.length; i++) {
          _ptOption[i].selectedValue = "";
        }
        for (int i = 0; i < _ptOptionArr.length; i++) {
          if (_ptOptionArr[i].option == optionStr) {
            optionExists = true;
            if (_addPtOptionArr.isEmpty) {
              setState(() {
                _addPtOptionArr.add(_ptOptionArr[i]);
              });
            } else {
              bool isAdd = true;
              for (int j = 0; j < _addPtOptionArr.length; j++) {
                if (_addPtOptionArr[j].idx == _ptOptionArr[i].idx) {
                  isAdd = false;
                }
              }
              if (isAdd) {
                setState(() {
                  _addPtOptionArr.add(_ptOptionArr[i]);
                });
              } else {
                Utils.getInstance().showSnackBar(context, '이미 추가한 옵션 입니다.');
              }
              break;
            }
          }
        }
        if (!optionExists) {
          Utils.getInstance().showSnackBar(context, '해당 옵션의 상품은 판매가 불가합니다.');
        }
      }
    }
  }

  void _buyAndCartProduct(int addType) async {
    final pref = await SharedPreferencesManager.getInstance();
    String? mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    List<Map<String, dynamic>> products = [];
    List<Map<String, dynamic>> addProducts = [];
    for (int i = 0; i < _addPtOptionArr.length; i++) {
      Map<String, dynamic> product = {
        'ot_idx': _addPtOptionArr[i].idx,
        'count': _addPtOptionArr[i].count,
      };

      products.add(product);
    }

    for (int i = 0; i < _addPtAddArr.length; i++) {
      Map<String, dynamic> addProduct = {
        'at_idx': _addPtAddArr[i].idx,
        'count': _addPtAddArr[i].count,
      };

      addProducts.add(addProduct);
    }

    if (addType == 0) {
      // 장바구니 담기
      Map<String, dynamic> requestData1 = {
        'type': memberType, //회원 1 비회원2
        'add_type': addType, //장바구니 0  구매하기 1
        'mt_idx': mtIdx,
        'temp_mt_id': appToken, //비회원아이디 [앱 토큰]
        'pt_idx': _productData.ptIdx,
        'products': json.encode(products),
        'addProducts': json.encode(addProducts),
      };

      final responseData = await ref.read(productOrderBottomOptionViewModelProvider.notifier).addCart(requestData1);
      if(!mounted) return;
      if (responseData != null) {
        if (responseData['result'] == true) {
          Utils.getInstance().showSnackBar(context, responseData['data']['message'] ?? "");
          ref.read(cartProvider.notifier).cartRefresh(true);
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 350,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/product/complete_img.svg',
                        width: 90,
                        height: 90,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          '장바구니에 상품을 담았습니다.',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '담은 상품 보러 가기',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            border: Border.all(color: const Color(0xFFDDDDDD)),
                          ),
                          child: Center(
                            child: Text(
                              '계속 쇼핑하기',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          Utils.getInstance().showSnackBar(context, responseData['data']['message'] ?? "");
        }
      } else {
        Utils.getInstance().showSnackBar(context, "Network Error");
      }
    } else {
      if(memberType == 2) {
        if(!mounted) return;
        final result = await Navigator.pushNamed(context, '/login/Y');
        if (result != null && result == 'member') {
          mtIdx = pref.getMtIdx();
          memberType = 1;
        }
      }

      Map<String, dynamic> requestData1 = {
        'type': memberType, //회원 1 비회원2
        'add_type': addType, //장바구니 0  구매하기 1
        'mt_idx': mtIdx,
        'temp_mt_id': appToken, //비회원아이디 [앱 토큰]
        'pt_idx': _productData.ptIdx,
        'products': json.encode(products),
        'addProducts': json.encode(addProducts),
      };
      final responseData = await ref.read(productOrderBottomOptionViewModelProvider.notifier).addCart(requestData1);
      if(!mounted) return;
      if (responseData != null) {
        if (responseData['result'] == true) {
          Map<String, dynamic> requestData2 = {
            'type': memberType,
            'ot_idx': '',
            'mt_idx': mtIdx,
            'temp_mt_id': appToken,
            'cart_arr': responseData['data']['cart_arr'],
          };
          final payOrderDetailDTO = await ref.read(productOrderBottomOptionViewModelProvider.notifier).orderDetail(requestData2);
          if(!mounted) return;
          if (payOrderDetailDTO != null) {
            final payOrderDetailData = payOrderDetailDTO.data;
            final userInfoCheck = payOrderDetailDTO.data?.userInfoCheck;
            if (payOrderDetailData != null) {
              if (userInfoCheck == "Y" || memberType == 2) {
                final map = {
                  'payOrderDetailData': payOrderDetailData,
                  'memberType': memberType,
                };
                Navigator.pushReplacementNamed(context, '/payment', arguments: map);
              } else {
                // TODO 추가 정보 입력
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JoinAddInfoScreen(payOrderDetailData: payOrderDetailData, memberType: memberType,),
                  ),
                );
              }
              return;
            } else {
              Utils.getInstance().showSnackBar(context, payOrderDetailDTO.message ?? "");
            }
          } else {
            Utils.getInstance().showSnackBar(context, "Network Error");
          }
        } else {
          Utils.getInstance().showSnackBar(context, responseData['data']['message'] ?? "");
        }
      } else {
        Utils.getInstance().showSnackBar(context, "Network Error");
      }
    }
  }
}
