import 'package:BliU/data/cancel_info_data.dart';
import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/cancel/child_widget/cancel_child_widget.dart';
import 'package:BliU/screen/cancel/view_model/cancel_view_model.dart';
import 'package:BliU/utils/my_app_bar.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CancelScreen extends ConsumerStatefulWidget {
  final OrderData orderData;
  final String odtCode;
  final String otCode;

  const CancelScreen({super.key, required this.orderData, required this.odtCode, required this.otCode});

  @override
  ConsumerState<CancelScreen> createState() => CancelScreenState();
}

class CancelScreenState extends ConsumerState<CancelScreen> {
  final _addItemController = ExpansionTileController();
  final ScrollController _scrollController = ScrollController();

  int _dropdownValue = 0;
  String _selectedTitle = "취소사유 선택";
  String _detailedReason = '';
  List<CategoryData> _cancelCategory = [];
  int _userType = 2;
  CancelInfoData? _cancelInfoData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _afterBuild(BuildContext context) {
    _getOrderCancelInfo();
  }
  void _getOrderCancelInfo() async {

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    _userType = memberType;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'odt_code': widget.odtCode,
      'ot_code': widget.otCode,
    };
    final categoryResponseDTO = await ref.read(cancelViewModelProvider.notifier).getCategory();
    final orderCancelInfoResponseDTO = await ref.read(cancelViewModelProvider.notifier).getOrderCancelInfo(requestData);

    if (orderCancelInfoResponseDTO != null) {
      if (orderCancelInfoResponseDTO.result == true) {
        _cancelInfoData = orderCancelInfoResponseDTO.data;
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, orderCancelInfoResponseDTO.message ?? "");
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
      'ot_code': widget.otCode,
      'odt_code': _cancelInfoData?.cancelItem ?? "",
      'ct_idx': _dropdownValue,
      'ct_reason': _detailedReason,
      'oct_all': _cancelInfoData?.octAll ?? "",
      'price': _cancelInfoData?.octReturnPrice ?? 0,
      'point': _cancelInfoData?.octReturnPoint ?? 0,
    };

    final defaultResponseDTO = await ref.read(cancelViewModelProvider.notifier).orderCancel(requestData);
    if (!mounted) return;
    if (defaultResponseDTO.result == true) {
      Navigator.pop(context);
    }
    Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
  }

  @override
  Widget build(BuildContext context) {
    List<OrderDetailData> cancelList = [];
    cancelList = _cancelInfoData?.cancelList ?? [];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: MyAppBar(
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
      ),
      body: SafeArea(
        child: Utils.getInstance().isWebView(
          Stack(
            children: [
              ListView(
                controller: _scrollController,
                children: [
                  Column(
                    children: cancelList.map((orderDetailData){
                      return CancelChildWidget(
                        orderData: widget.orderData,
                        orderDetailData: orderDetailData,
                      );
                    }).toList(),
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
                    child: _cancelInfoWidget(),
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
      ),
    );
  }

  Widget _cancelInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: _userType == 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 10,
                width: double.infinity,
                color: const Color(0xFFF5F9F9),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: Text(
                  '환불정보',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 18),
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              // 배송지 정보 세부 내용
              Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFEEEEEE),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      '포인트환급액',
                      "${Utils.getInstance().priceString(_cancelInfoData?.octReturnPoint ?? 0)}원",
                      context,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: _buildInfoRow(
                        '배송비',
                        "${Utils.getInstance().priceString(_cancelInfoData?.deliveryPriece ?? 0)}원",
                        context,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 10,
          width: double.infinity,
          color: const Color(0xFFF5F9F9),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '환불예정금액',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 18),
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                "${Utils.getInstance().priceString((_cancelInfoData?.octReturnPrice ?? 0))}원",
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
        // 배송지 정보 세부 내용
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFEEEEEE),
              ),
            ),
          ),
          child: _buildInfoRow('환불방법', _cancelInfoData?.octReturnType ?? "", context),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
              height: 1.2,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
