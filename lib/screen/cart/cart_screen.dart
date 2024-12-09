import 'dart:convert';

import 'package:BliU/data/cart_data.dart';
import 'package:BliU/data/cart_item_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/cart/item/cart_item.dart';
import 'package:BliU/screen/cart/view_model/cart_view_model.dart';
import 'package:BliU/screen/join_add_info/join_add_info_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => CartScreenState();
}

class CartScreenState extends ConsumerState<CartScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _isAllSelected = true;
  List<int> _cartSelectedList = [];

  List<CartData> _cartItems = [];
  int totalCount = 0;

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_nextLoad);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_nextLoad);
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    _page = 1;
    _hasNextPage = true;

    final requestData = await _makeRequestData();

    final cartResponseDTO = await ref.read(cartViewModelProvider.notifier).getList(requestData);
    if (cartResponseDTO != null) {
      setState(() {
        _cartItems = cartResponseDTO.list ?? [];
        totalCount = 0;
        for (var item in _cartItems) {
          totalCount += item.productList?.length ?? 0;
        }

        if (_isAllSelected) {
          _cartSelectedList = [];
          for (var item in _cartItems) {
            for (var product in (item.productList ?? [] as List<CartItemData>)) {
              if ((product.ptJaego ?? 0) > 0) {
                _cartSelectedList.add(product.ctIdx ?? 0);
              }
            }
          }
          if (_cartSelectedList.isEmpty) {
            _isAllSelected = false;
          }
        }
      });
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {
    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning && _scrollController.position.extentAfter < 200){
      setState(() {
        _isLoadMoreRunning = true;
      });

      _page += 1;

      final requestData = await _makeRequestData();

      final cartResponseDTO = await ref.read(cartViewModelProvider.notifier).getList(requestData);
      if (cartResponseDTO != null) {
        if ((cartResponseDTO.list ?? []).isNotEmpty) {
          setState(() {
            _cartItems.addAll(cartResponseDTO.list ?? []);
            totalCount = 0;
            for (var item in _cartItems) {
              totalCount += item.productList?.length ?? 0;
            }

            if (_isAllSelected) {
              _cartSelectedList = [];
              for (var item in _cartItems) {
                for (var product in (item.productList ?? [] as List<CartItemData>)) {
                  _cartSelectedList.add(product.ctIdx ?? 0);
                }
              }
            }
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future<Map<String, dynamic>> _makeRequestData() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken, // 앱토큰 비회원
      'pg': _page,
    };

    return requestData;
  }

  void _toggleSelectAll() {
    setState(() {
      _isAllSelected = !_isAllSelected;

      // 모든 아이템의 선택 상태 업데이트
      for (var item in _cartItems) {
        for (var product in item.productList ?? [] as List<CartItemData>) {
          _cartSelectedList.add(product.ctIdx ?? 0);
        }
      }

      if (!_isAllSelected) {
        _cartSelectedList = [];
      }
    });
  }

  void _toggleSelection(int ctIdx, bool isSelected) {
    setState(() {
      // 선택된 항목 수 업데이트
      if (isSelected) {
        _cartSelectedList.add(ctIdx);
      } else {
        _cartSelectedList.remove(ctIdx);
      }

      // 전체 선택 상태 동기화
      _isAllSelected = _cartSelectedList.length == totalCount;
    });
  }

  int _getTotalProductPrice() {
    // 선택된 기준으로 가격 가져오기
    int totalProductPrice = 0;
    for (var cartItem in _cartItems) {
      for (var product in cartItem.productList ?? [] as List<CartItemData>) {
        if (_cartSelectedList.contains(product.ctIdx)) {
          totalProductPrice += ((product.ptPrice ?? 0) * (product.ptCount ?? 0));
        }
      }
    }
    return totalProductPrice;
  }

  int _getTotalDeliveryPrice() {
    int totalDeliveryPrice = 0;
    for (var cartItem in _cartItems) {
      bool isAllCheck = true;
      if (_cartSelectedList.length != totalCount) {
        isAllCheck = false;
      }
      if (isAllCheck) {
        totalDeliveryPrice += cartItem.stDeliveryPrice ?? 0;
      } else {
        for (var product in cartItem.productList ?? [] as List<CartItemData>) {
          if (_cartSelectedList.contains(product.ctIdx)) {
            totalDeliveryPrice += product.ctDeliveryDefaultPrice ?? 0;
          }
        }
      }
    }
    return totalDeliveryPrice;
  }

  int _getTotalPaymentPrice() {
    return _getTotalProductPrice() + _getTotalDeliveryPrice();
  }

  // 수량 조정
  void _cartUpdate(int ctIdx, int ctCount) async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'ct_idx': ctIdx,
      'ct_count': ctCount
    };

    final defaultResponseDTO = await ref.read(cartViewModelProvider.notifier).cartUpdate(requestData);
    if (defaultResponseDTO != null) {
      if (defaultResponseDTO.result == true) {
        _getList();
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
      }
    }
  }

  //장바구니 삭제
  void _cartDel(String ctIdx) async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'ct_idx': ctIdx,
    };

    final defaultResponseDTO = await ref.read(cartViewModelProvider.notifier).cartDel(requestData);
    if (defaultResponseDTO != null) {
      if (defaultResponseDTO.result == true) {
        _getList();
      }

      if (!mounted) return;
      Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
    }
  }

  void _goOrder() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    List<Map<String, dynamic>> cartArr = [];
    for (var cartItem in _cartItems) {
      Map<String, dynamic> cartMap = {
        'st_idx': cartItem.stIdx,
      };
      List<int> ctIdxs = [];
      for (var product in cartItem.productList ?? [] as List<CartItemData>) {
        if (_cartSelectedList.contains(product.ctIdx)) {
          ctIdxs.add(product.ctIdx ?? 0);
        }
      }

      if (ctIdxs.isNotEmpty) {
        cartMap['ct_idxs'] = ctIdxs;
        cartArr.add(cartMap);
      }
    }
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'ot_idx': '',
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'cart_arr': json.encode(cartArr),
    };

    final payOrderDetailDTO = await ref.read(cartViewModelProvider.notifier).orderDetail(requestData);
    if (payOrderDetailDTO != null) {
      final payOrderDetailData = payOrderDetailDTO.data;
      final userInfoCheck = payOrderDetailDTO.data?.userInfoCheck;
      if (payOrderDetailData != null) {
        if(!mounted) return;
        if (userInfoCheck == "Y" || memberType == 2) {
          final map = {
            'payOrderDetailData': payOrderDetailData,
            'memberType': memberType,
          };
          Navigator.pushNamed(context, '/payment', arguments: map);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JoinAddInfoScreen(payOrderDetailData: payOrderDetailData, memberType: memberType,),),
          );
        }
        return;
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, "Network Error");
      }
    } else {
      if (!mounted) return;
      Utils.getInstance().showSnackBar(context, "Network Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
        title: const Text("장바구니"),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0x0D000000), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 6.0,
                    spreadRadius: 0.1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
              visible: _cartItems.isNotEmpty,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 50), // 하단 고정 버튼 공간 확보
                          children: [
                            // 전체선택 및 전체삭제 UI
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFFEEEEEE)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: _toggleSelectAll,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          height: 22,
                                          width: 22,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                                            border: Border.all(
                                              color: _isAllSelected ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                            ),
                                            color: _isAllSelected ? const Color(0xFFFF6191) : Colors.white,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/images/check01_off.svg', // 체크박스 아이콘
                                            colorFilter: ColorFilter.mode(
                                              _isAllSelected ? Colors.white : const Color(0xFFCCCCCC),
                                              BlendMode.srcIn,
                                            ),
                                            height: 10, // 아이콘의 높이
                                            width: 10, // 아이콘의 너비
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '전체선택(${_cartSelectedList.length}/$totalCount)',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _cartDel("all");
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset('assets/images/ic_delet.svg'),
                                        const SizedBox(width: 5,),
                                        Text(
                                          '전체삭제',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            color: Colors.black,
                                            height: 1.2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ..._cartItems.map((cartItem) {
                              final productList = cartItem.productList ?? [];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 스토어명
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    height: 40,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(20)), // 사진의 모서리 둥글게 설정
                                            border: Border.all(
                                              color: const Color(0xFFDDDDDD),// 테두리 색상 설정
                                              width: 1.0, // 테두리 두께 설정
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(20)), // 사진의 모서리만 둥글게 설정
                                            child: Image.network(
                                              cartItem.stProfile ?? "",
                                              fit: BoxFit.cover,
                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return SizedBox(
                                                  child: SvgPicture.asset('assets/images/no_imge_shop.svg'),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: Responsive.getWidth(context, 10)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          child: Text(
                                            cartItem.stName ?? "",
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 각 스토어의 상품들
                                  Column(
                                    children: productList.map((product) {
                                      return CartItem(
                                        item: product,
                                        isSelected: _cartSelectedList.contains(product.ctIdx),
                                        onIncrementQuantity: (index) {
                                          setState(() {
                                            final cartCount = (product.ptCount ?? 0) + 1;
                                            if ((product.ctIdx ?? 0) > 0) {
                                              _cartUpdate(product.ctIdx ?? 0, cartCount);
                                            }
                                          });
                                        },
                                        onDecrementQuantity: (index) {
                                          setState(() {
                                            final cartCount = (product.ptCount ?? 0) - 1;
                                            if ((product.ctIdx ?? 0) > 0 && cartCount > 0) {
                                              _cartUpdate(product.ctIdx ?? 0, cartCount);
                                            }
                                          });
                                        },
                                        onDelete: (index) {
                                          setState(() {
                                            if ((product.ctIdx ?? 0) > 0) {
                                              _cartDel((product.ctIdx ?? 0).toString());
                                            }
                                          });
                                        },
                                        onToggleSelection: _toggleSelection, // 개별 선택 상태 변경 함수 전달
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 10.0),
                                  // 배송비 및 결제금액
                                  Container(
                                    width: Responsive.getWidth(context, 380),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F9F9),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '배송비 ${(cartItem.stDeliveryPrice ?? 0) == 0 ? "무료" : "${Utils.getInstance().priceString(cartItem.stDeliveryPrice ?? 0)}원"}',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 13),
                                            color: const Color(0xFF7B7B7B),
                                            height: 1.2,
                                          ),
                                        ),
                                        SizedBox(width: Responsive.getWidth(context, 10)),
                                        Text(
                                          '총 결제금액',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            height: 1.2,
                                          ),
                                        ),
                                        SizedBox(width: Responsive.getWidth(context, 10)),
                                        Text(
                                          '${Utils.getInstance().priceString(cartItem.stProductPrice ?? 0)}원',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              );
                            }),
                            const Divider(thickness: 10, color: Color(0xFFF5F9F9)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '총 상품 금액',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                      Text(
                                        '${Utils.getInstance().priceString(_getTotalProductPrice())} 원',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('총 배송비',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                      Text(
                                        '${Utils.getInstance().priceString(_getTotalDeliveryPrice())} 원',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15.0, bottom: 20),
                                    child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '총 결제예상금액',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                      Text(
                                        '${Utils.getInstance().priceString(_getTotalPaymentPrice())} 원',
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
                        ),
                        MoveTopButton(scrollController: _scrollController),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFF4F4F4),
                          blurRadius: 6.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, -3), // 위쪽으로 그림자 위치 조정
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 17.0),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '총 상품 금액: ',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
                              ),
                            ),
                            Text(
                              '${Utils.getInstance().priceString(_getTotalProductPrice())} 원',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '총 배송비: ',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
                              ),
                            ),
                            Text(
                              '${Utils.getInstance().priceString(_getTotalDeliveryPrice())} 원',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_cartSelectedList.isNotEmpty) {
                              _goOrder();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: _cartSelectedList.isNotEmpty ? Colors.black : const Color(0xFFDDDDDD), // 선택된 항목이 없으면 회색
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          child: Text(
                            '주문하기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: Colors.white,
                              fontSize: Responsive.getFont(context, 14),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _cartItems.isEmpty,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 200, bottom: 15),
                      child: Image.asset('assets/images/product/empty_cart.png',
                        width: 180,
                        height: 180,
                      ),
                    ),
                    Text(
                      '아직 상품을 담지 않았어요!',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF7B7B7B),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _cartItems.isEmpty,
              child: Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                      decoration: const BoxDecoration(
                        color: Colors.black, // 다운로드할 쿠폰이 있으면 활성화
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.white,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
