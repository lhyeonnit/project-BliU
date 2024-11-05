import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/order_detail_info_data.dart';
import 'package:BliU/data/return_info_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/cancel/child_view/cancel_item.dart';
import 'package:BliU/screen/exchange_return/child_view/exchange_return_info.dart';
import 'package:BliU/screen/cancel/view_model/cancel_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CancelScreen extends ConsumerStatefulWidget {
  final OrderData orderData;
  final OrderDetailData orderDetailData;

  const CancelScreen({super.key, required this.orderData, required this.orderDetailData,});

  @override
  ConsumerState<CancelScreen> createState() => CancelScreenState();
}

class CancelScreenState extends ConsumerState<CancelScreen> {
  OrderDetailInfoData? orderDetailInfoData;
  final _addItemController = ExpansionTileController();
  final ScrollController _scrollController = ScrollController();
  String _selectedTitle = "취소사유 선택";
  int _dropdownValue = 0;
  String _detailedReason = '';
  List<CategoryData> _cancelCategory = [];
  int? userType;
  ReturnInfoData? returnInfoData;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('취소요청'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: SvgPicture.asset("assets/images/product/ic_close.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
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
            ListView(
              controller: _scrollController,
              children: [
                CancelItem(
                  orderData: widget.orderData,
                  orderDetailData: widget.orderDetailData,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      disabledColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      listTileTheme: ListTileTheme.of(context).copyWith(
                        dense: true,
                        minVerticalPadding: 14,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(color: const Color(0xFFE1E1E1)),
                      ),
                      child: ExpansionTile(
                        controller: _addItemController,
                        title: Text(
                          _selectedTitle,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            height: 1.2,
                          ),
                        ),
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.black,
                        children: _cancelCategory.map((cancelCategory) {
                          return ListTile(
                            title: Text(
                              cancelCategory.ctName ?? "",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                // 선택한 항목을 _selectedTitle에 저장하고 ExpansionTile을 닫음
                                _selectedTitle = cancelCategory.ctName ?? "취소사유 선택";
                                _addItemController.collapse();
                                _dropdownValue = cancelCategory.ctIdx ?? 0;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextField(
                    onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                    style: TextStyle(
                      decorationThickness: 0,
                      height: 1.2,
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                    ),
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      hintText: '세부 내용 입력',
                      hintStyle: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: const Color(0xFF595959),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                      ),
                      counter: Align(
                        alignment: Alignment.centerLeft, // 왼쪽 정렬
                        child: Text(
                          '${_detailedReason.length}/500',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 13),
                            color: const Color(0xFF7B7B7B),
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _detailedReason = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 110),
                  child: ExchangeReturnInfo(
                    returnInfoData: returnInfoData,
                    orderDetailData: widget.orderDetailData,
                    userType: userType ?? 0,
                  ),
                ),
              ],
            ),
            // 하단 고정 버튼
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  MoveTopButton(scrollController: _scrollController),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        // 확인 버튼 눌렀을 때 처리
                        if (_dropdownValue == 0) {
                          Utils.getInstance().showSnackBar(context, "취소사유를 선택해 주세요");
                          return;
                        }

                        if (_detailedReason.isEmpty) {
                          Utils.getInstance().showSnackBar(context, "세부 내용을 입력해 주세요.");
                          return;
                        }
                        _orderCancel();
                      },
                      child: Container(
                        height: 48,
                        margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getOrderDetail();
    _getOrderCancelInfo();
  }
  void _getOrderCancelInfo() async {

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'odt_code': widget.orderDetailData.odtCode,
    };

    final orderCancelInfoResponseDTO = await ref.read(cancelViewModelProvider.notifier).getOrderCancelInfo(requestData);

    if (orderCancelInfoResponseDTO != null) {
      if (orderCancelInfoResponseDTO.result == true) {
        returnInfoData = orderCancelInfoResponseDTO.data;
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, orderCancelInfoResponseDTO.message ?? "");
      }
    }
  }
  void _getOrderDetail() async {

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'ot_code': widget.orderData.detailList?[0].otCode,
    };

    final orderDetailInfoResponseDTO = await ref.read(cancelViewModelProvider.notifier).getOrderDetail(requestData);
    final categoryResponseDTO = await ref.read(cancelViewModelProvider.notifier).getCategory();

    if (orderDetailInfoResponseDTO != null) {
      if (orderDetailInfoResponseDTO.result == true) {
        orderDetailInfoData = orderDetailInfoResponseDTO.data;
        userType = memberType;
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, orderDetailInfoResponseDTO.message ?? "");
      }
    }

    if (categoryResponseDTO != null) {
      if (categoryResponseDTO.result == true) {
        _cancelCategory = categoryResponseDTO.list ?? [];
      }
    }
    setState(() {});
  }

  void _orderCancel() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'odt_code': widget.orderDetailData.odtCode,
      'ct_idx': _dropdownValue,
      'ct_reason': _detailedReason,
    };

    final defaultResponseDTO = await ref.read(cancelViewModelProvider.notifier).orderCancel(requestData);
    if (!mounted) return;
    if (defaultResponseDTO.result == true) {
      Navigator.pop(context);
    }
    Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
  }
}
