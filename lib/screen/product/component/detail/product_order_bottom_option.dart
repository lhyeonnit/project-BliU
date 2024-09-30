import 'dart:convert';

import 'package:BliU/data/add_option_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/product_option_data.dart';
import 'package:BliU/data/product_option_type_data.dart';
import 'package:BliU/data/product_option_type_detail_data.dart';
import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/product/viewmodel/product_order_bottom_option_view_model.dart';
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
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        // set this to true
        useSafeArea: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            expand: false,
            snap: true,
            builder: (context, scrollController) {
              return ProductOrderBottomOptionContent(
                productData: productData,
                scrollController: scrollController,
              );
            },
          );
        });
  }

  @override
  _ProductOrderBottomOptionState createState() =>
      _ProductOrderBottomOptionState();
}

class _ProductOrderBottomOptionState
    extends ConsumerState<ProductOrderBottomOption> {
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
  _ProductOrderBottomOptionContentState createState() => _ProductOrderBottomOptionContentState();
}

class _ProductOrderBottomOptionContentState
    extends ConsumerState<ProductOrderBottomOptionContent> {
  late ProductData _productData;
  ProductOptionData? _productOptionData;
  List<ProductOptionTypeData> _ptOption = [];
  List<ProductOptionTypeDetailData> _ptOptionArr = [];
  List<AddOptionData> _ptAddArr = [];

  List<ProductOptionTypeDetailData> _addPtOptionArr = [];
  List<AddOptionData> _addPtAddArr = [];
  bool _isExpanded = false;
  bool _isOptionSelected = false;

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
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 17),
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
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: _ptOption.length,
                        // 리스트의 길이를 사용
                        itemBuilder: (context, index) {
                          //print("test ${_ptOption[index]}");
                          return _buildExpansionTile(
                            title: _ptOption[index].title ?? "",
                            options: _ptOption[index].children ?? [],
                            onSelected: (value) {
                              print("size =- ${value}");
                              _ptOption[index].selectedValue = value;
                              _selectOptionCheck();
                              _isOptionSelected = true;
                            },
                          );
                        },
                      ),
                    ),
                    _ptAddArr.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                disabledColor: Colors.transparent,
                                listTileTheme: ListTileTheme.of(context).copyWith(
                                    dense: true, minVerticalPadding: 14
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  border: Border.all(
                                      color: const Color(0xFFE1E1E1)),
                                ),
                                child: ExpansionTile(
                                  title: Text(
                                    '추가상품',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      height: 1.2,
                                    ),
                                  ),
                                  children: _ptAddArr.map((ptAdd) {
                                    return ListTile(
                                      title: Text(
                                        ptAdd.option ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                      onTap: () {
                                        // TODO 선택시
                                        print("ptAdd ${ptAdd.option}");
                                        if (_addPtAddArr.isEmpty) {
                                          setState(() {
                                            _addPtAddArr.add(ptAdd);
                                          });
                                        } else {
                                          bool isAdd = true;
                                          for (int i = 0;
                                              i < _addPtAddArr.length;
                                              i++) {
                                            if (_addPtAddArr[i].idx ==
                                                ptAdd.idx) {
                                              isAdd = false;
                                            }
                                          }

                                          if (isAdd) {
                                            setState(() {
                                              _addPtAddArr.add(ptAdd);
                                            });
                                          } else {
                                            Utils.getInstance()
                                                .showToast('이미 추가한 상품 입니다.');
                                          }
                                        }
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    //옵션
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _addPtOptionArr.length,
                          // 리스트의 길이를 사용
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF5F9F9),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _addPtOptionArr[index].option ?? "",
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: Responsive.getFont(context, 14),
                                                height: 1.2,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _addPtOptionArr
                                                      .removeAt(index);
                                                });
                                              },
                                              child: SvgPicture.asset(
                                                  'assets/images/ic_del.svg'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: Responsive.getWidth(
                                                context, 96),
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
                                                  color:
                                                      const Color(0xFFE3E3E3)),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  child: const Icon(
                                                      CupertinoIcons.minus,
                                                      size: 20),
                                                  onTap: () {
                                                    if (_addPtOptionArr[index]
                                                            .count >
                                                        1) {
                                                      setState(() {
                                                        _addPtOptionArr[index]
                                                            .count -= 1;
                                                      });
                                                    }
                                                  },
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
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
                                                    if ((_addPtOptionArr[index]
                                                                .potJaego ??
                                                            0) >
                                                        _addPtOptionArr[index]
                                                            .count) {
                                                      setState(() {
                                                        _addPtOptionArr[index]
                                                            .count += 1;
                                                      });
                                                    }
                                                  },
                                                  child: const Icon(Icons.add,
                                                      size: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '${Utils.getInstance().priceString(_addPtOptionArr[index].count * (_addPtOptionArr[index].potPrice ?? 0))}원',
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
                          }),
                    ),
                    // 추가상품
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _addPtAddArr.length,
                        // 리스트의 길이를 사용
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5F9F9),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                            child: SvgPicture.asset(
                                                'assets/images/ic_del.svg'),
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
                                                    CupertinoIcons.minus,
                                                    size: 20),
                                                onTap: () {
                                                  if (_addPtAddArr[index]
                                                          .count >
                                                      1) {
                                                    setState(() {
                                                      _addPtAddArr[index]
                                                          .count -= 1;
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
                                                    _addPtAddArr[index].count +=
                                                        1;
                                                  });
                                                },
                                                child: const Icon(Icons.add,
                                                    size: 20),
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
                    if (_isOptionSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        margin: const EdgeInsets.only(bottom: 50, top: 15),
                        child: _buildPriceSummary(context),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_isOptionSelected)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildActionButtons(context),
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
    final responseDto = await ref
        .read(productOrderBottomOptionModelProvider.notifier)
        .getList(requestData);
    if (responseDto != null) {
      setState(() {
        _productOptionData = responseDto.data;
        _ptOption = _productOptionData?.ptOption ?? [];
        _ptOptionArr = _productOptionData?.ptOptionArr ?? [];
        _ptAddArr = _productOptionData?.ptAddArr ?? [];
      });
    }
  }

  // 색상, 사이즈, 추가상품 옵션 박스
  Widget _buildExpansionTile({
    required String title,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        disabledColor: Colors.transparent,
        listTileTheme: ListTileTheme.of(context).copyWith(
          dense: true, minVerticalPadding: 14
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
          initiallyExpanded: _isExpanded,
          // 타일의 초기 상태 설정
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
              _isExpanded = expanded; // 타일이 열리고 닫힐 때 상태 변경
            });
          },
          children: options.map(
            (option) {
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
                  setState(
                    () {
                      _isExpanded = false; // 선택 시 타일을 닫음
                    },
                  );
                },
              );
            },
          ).toList(),
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
      optionProductPrice +=
          (_addPtOptionArr[i].potPrice ?? 0 * _addPtOptionArr[i].count) +
              (productPrice * _addPtOptionArr[i].count);
    }
    for (int i = 0; i < _addPtAddArr.length; i++) {
      additionalProductPrice += (_addPtAddArr[i].patPrice ?? 0);
    }
    int totalPrice = optionProductPrice + additionalProductPrice;
    String deliveryPriceStr = "";
    if (totalPrice <
        (_productData.deliveryInfo?.deliveryDetail?.deliveryMinPrice ?? 0)) {
      deliveryPriceStr =
          "${Utils.getInstance().priceString((_productData.deliveryInfo?.deliveryDetail?.deliveryBasicPrice ?? 0))}원";
    } else {
      if ((_productData.deliveryInfo?.deliveryPrice ?? 0) == 0) {
        deliveryPriceStr = "무료";
      } else {
        deliveryPriceStr =
            "${Utils.getInstance().priceString((_productData.deliveryInfo?.deliveryPrice ?? 0))}원";
      }
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceRow(
              '상품금액', '${Utils.getInstance().priceString(totalPrice)}원'),
          const SizedBox(height: 15),
          _buildPriceRow('배송비', deliveryPriceStr),
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
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            height: 1.2,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            fontWeight: FontWeight.bold,
            height: 1.2,
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
                _buyAndCartProduct(0);
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
    bool isAllChecked = true;
    String optionStr = "";
    for (int i = 0; i < _ptOption.length; i++) {
      if (_ptOption[i].selectedValue.isEmpty) {
        isAllChecked = false;
      }
      if (optionStr.isEmpty) {
        optionStr = _ptOption[i].selectedValue;
      } else {
        optionStr += "|${_ptOption[i].selectedValue}";
      }
    }
    if (isAllChecked) {
      for (int i = 0; i < _ptOption.length; i++) {
        _ptOption[i].selectedValue = "";
      }
      for (int i = 0; i < _ptOptionArr.length; i++) {
        if (_ptOptionArr[i].option == optionStr) {
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
              Utils.getInstance().showToast('이미 추가한 옵션 입니다.');
            }
          }
        }
      }
    }
  }

  void _buyAndCartProduct(int addType) async {
    // TODO 회원 비회원 구분 필요ß
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
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

    Map<String, dynamic> requestData = {
      'type': 1, //회원 1 비회원2
      'add_type': addType, //장바구니 0  구매하기 1
      'mt_idx': mtIdx,
      'temp_mt_id': '', //비회원아이디 [앱 토큰]
      'pt_idx': _productData.ptIdx,
      'products': json.encode(products),
      'addProducts': json.encode(addProducts),
    };

    final responseDto = await ref
        .read(productOrderBottomOptionModelProvider.notifier)
        .addCart(requestData);
    if (responseDto != null) {
      Utils.getInstance().showToast(responseDto.message ?? "");
      if (responseDto.result == true) {
        // TODO 장바구니 담을시 또는 구매일시 뷰 전환
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 350,
                alignment: Alignment.center,
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F9F9), shape: BoxShape.circle),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()),
                        );
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
      }
    }
  }
}
