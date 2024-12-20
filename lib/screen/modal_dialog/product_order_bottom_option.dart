import 'dart:convert';

import 'package:BliU/data/add_option_data.dart';
import 'package:BliU/data/option_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/product_option_data.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/cart/cart_screen.dart';
import 'package:BliU/screen/join_add_info/join_add_info_screen.dart';
import 'package:BliU/screen/modal_dialog/view_model/product_order_bottom_option_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  const ProductOrderBottomOptionContent({super.key, required this.productData, required this.scrollController});

  @override
  ConsumerState<ProductOrderBottomOptionContent> createState() => ProductOrderBottomOptionContentState();
}

class ProductOrderBottomOptionContentState extends ConsumerState<ProductOrderBottomOptionContent> {
  late ProductData _productData;

  ProductOptionData? _productOptionData;
  List<OptionData> _optionArr = [];
  final List<OptionData> _addPtOptionArr = [];
  List<AddOptionData> _ptAddArr = [];

  final List<AddOptionData> _addPtAddArr = [];
  List<bool> _isExpandedList = [];
  bool _isOptionSelected = false;
  final _addItemController = ExpansionTileController();

  // 선택된 옵션 값을 저장할 Map, 키는 옵션 제목(title)
  Map<String, String?> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    _productData = widget.productData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    Map<String, dynamic> requestData = {
      'pt_idx': _productData.ptIdx,
    };

    final productOptionResponseDTO = await ref.read(productOrderBottomOptionViewModelProvider.notifier).getList(requestData);
    if (productOptionResponseDTO != null) {
      setState(() {
        _productOptionData = productOptionResponseDTO.data;
        _ptAddArr = productOptionResponseDTO.data?.ptAddOption ?? [];

        _initOption();
      });
    }
  }

  void _initOption() {
    _optionArr = [];
    final ptOptionSelect = _productOptionData?.ptOptionSelect;
    ptOptionSelect?.forEach((title) {
      final option = OptionData(idx: null,
        title: title,
        option: null,
        optionArr: null,
        potPrice: null,
        potJaego: null,
      );
      _optionArr.add(option);
    });

    if (_optionArr.isNotEmpty) {
      try {
        _isExpandedList = List.generate(_optionArr.length, (index) => false);
        if (_productOptionData?.ptType == "2") {
          //조합형
          final ptOption = _productOptionData?.ptOption ?? [];
          _optionArr[0].optionArr = ptOption;
        } else {
          //단독
          final ptOptions = _productOptionData?.ptOption ?? [];
          for (var option in _optionArr) {
            for (var ptOption in ptOptions) {
              if (option.title == ptOption.title) {
                option.optionArr = ptOption.optionArr;
              }
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('_initOption error $e');
        }
      }
    }
  }

  // 색상, 사이즈, 추가상품 옵션 박스
  Widget _buildExpansionTile({
    required String title,
    required List<OptionData> options,
    required int index,
    required Function(OptionData) onSelected,
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
              for (int i = 0; i < _isExpandedList.length; i++) {
                _isExpandedList[i] = false;
              }
              _isExpandedList[index] = expanded;
            });
          },
          children: options.map((option) {
            bool isSoldOut = false;
            if (_productOptionData?.ptType != "2") {
              if ((option.potJaego ?? 0) > 0) {
                isSoldOut = false;
              } else {
                isSoldOut = true;
              }
            }

            return ListTile(
              title: Text(
                option.title ?? "",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                  color: isSoldOut ? Colors.grey : Colors.black
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
      final potPrice = _addPtOptionArr[i].potPrice ?? 0;
      final count = _addPtOptionArr[i].count;

      optionProductPrice += (potPrice * count) + (productPrice * count);
    }

    for (int i = 0; i < _addPtAddArr.length; i++) {
      final patPrice = _addPtAddArr[i].patPrice ?? 0;
      final count = _addPtAddArr[i].count;

      additionalProductPrice += (patPrice * count);
    }

    int totalPrice = optionProductPrice + additionalProductPrice;

    String deliveryPriceStr = "";
    if (_productData.ptDelivery == 1) {
      deliveryPriceStr = "무료";
    } else {

      final deliveryMinPrice = _productData.deliveryInfo?.deliveryDetail?.deliveryMinPrice ?? 0;
      final deliveryBasicPrice = _productData.deliveryInfo?.deliveryDetail?.deliveryBasicPrice ?? 0;

      String deliveryBasicPriceStr = "";
      if (deliveryBasicPrice == 0) {
        deliveryBasicPriceStr = "무료";
      } else {
        deliveryBasicPriceStr = "${Utils.getInstance().priceString(deliveryBasicPrice)}원";
      }

      if (_productData.deliveryInfo?.deliveryDetail?.deliveryPriceType == 1) {
        deliveryPriceStr = deliveryBasicPriceStr;
      } else {
        if (totalPrice < deliveryMinPrice) {
          deliveryPriceStr = deliveryBasicPriceStr;
        } else {
          deliveryPriceStr = "무료";
        }
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
        if (result == null) {
          return;
        }
        if (result == 'member') {
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
                        itemCount: _optionArr.length,
                        itemBuilder: (context, index) {
                          final selectTitle = _optionArr[index].title ?? "";
                          final options = _optionArr[index].optionArr ?? [];

                          String displayTitle = _selectedOptions[selectTitle] == null ? selectTitle : "${_selectedOptions[selectTitle]}";

                          return _buildExpansionTile(
                            title: displayTitle,
                            options: options,
                            index: index,
                            onSelected: (selectedOption) {
                              if (_productOptionData?.ptType == "2") {
                                //조합형 처리
                                final optionArr = selectedOption.optionArr ?? [];
                                if (optionArr.isNotEmpty) {
                                  final option = optionArr[0];
                                  if (option.option != null && (option.option ?? "").isNotEmpty) {
                                    if ((option.potJaego ?? 0) <= 0) {
                                      Utils.getInstance().showSnackBar(context, '품절된 옵션 입니다.');
                                      return;
                                    }

                                    _addPtOptionArr.add(option);
                                    _selectedOptions = {};
                                    _initOption();
                                  } else {
                                    final nextTitle = _optionArr[index + 1].title ?? "";

                                    _selectedOptions[selectTitle] = selectedOption.title;
                                    _selectedOptions[nextTitle] = null;
                                    for(int i = index + 1; i < optionArr.length; i++) {
                                      _optionArr[i].optionArr = null;
                                    }

                                    _optionArr[index + 1].optionArr = optionArr;
                                  }
                                }
                              } else {
                                if ((selectedOption.potJaego ?? 0) <= 0) {
                                  Utils.getInstance().showSnackBar(context, '품절된 옵션 입니다.');
                                  return;
                                }
                                _addPtOptionArr.add(selectedOption);
                              }

                              setState(() {
                                _isOptionSelected = _addPtOptionArr.isNotEmpty;
                                final ptOptionSelect = _productOptionData?.ptOptionSelect ?? [];

                                int index = ptOptionSelect.indexWhere((element) => element == selectTitle);
                                if (index != -1) {
                                  _isExpandedList[index] = false; // 해당 타일 닫기
                                }
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
                                        ptAdd.title ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                          color: (ptAdd.patJaego ?? 0) <= 0 ? Colors.grey : Colors.black,
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
                                    if ((ptAdd.patJaego ?? 0) <= 0) {
                                      Utils.getInstance().showSnackBar(context, '품절된 추가 옵션 입니다.');
                                      return;
                                    }

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
                                                  _addPtOptionArr[index].title ?? "",
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
                                                _isOptionSelected = _addPtOptionArr.isNotEmpty;
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
                                            _addPtAddArr[index].title ?? "",
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
                                                child: const Icon(CupertinoIcons.minus, size: 20),
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
                                                const EdgeInsets.symmetric(horizontal: 5),
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
                                                  if ((_addPtAddArr[index].patJaego ?? 0) > _addPtAddArr[index].count) {
                                                    setState(() {
                                                      _addPtAddArr[index].count += 1;
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

}
