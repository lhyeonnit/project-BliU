import 'dart:io';

import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/order_detail_info_data.dart';
import 'package:BliU/data/return_info_data.dart';
import 'package:BliU/screen/exchange_return/child_widget/exchange_return_info_child_widget.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ReturnDetailChildWidget extends StatefulWidget {
  final OrderDetailInfoData? orderDetailInfoData;
  final OrderDetailData orderDetailData;
  final List<CategoryData> returnCategory;
  final ReturnInfoData? returnInfoData;
  final int userType;
  final Function(
      String reason,
      int reasonIdx,
      String detail,
      String returnAccount,
      String returnBank,
      List<File> images,
      bool isAgree) onDataCollected;

  const ReturnDetailChildWidget({
    required this.returnInfoData,
    required this.orderDetailInfoData,
    required this.orderDetailData,
    required this.returnCategory,
    required this.onDataCollected,
    required this.userType,
    super.key});

  @override
  State<ReturnDetailChildWidget> createState() => ReturnDetailChildWidgetState();
}

class ReturnDetailChildWidgetState extends State<ReturnDetailChildWidget> {
  OverlayEntry? _overlayEntryReason; // 취소 사유 드롭다운
  OverlayEntry? _overlayEntryBank; // 은행명 드롭다운
  String _dropdownText = '사유 선택';
  int _dropdownValue = 0;
  String _dropdownAccount = '은행명';
  String _detailedReason = '';
  String _returnAccount = '';
  bool _infoVisible = false;
  bool _isAgree = false;
  double _deliveryWebViewHeight = 300;

  final LayerLink _layerLinkReason = LayerLink(); // 취소 사유 드롭다운을 위한 LayerLink
  final LayerLink _layerLinkBank = LayerLink(); // 은행명 드롭다운을 위한 LayerLink

  List<CategoryData> _returnReasons = [];

  // TODO 은행 항목 변경 필요
  final List<String> _returnBank = [
    '국민은행',
    '농협은행',
    '우리은행',
    '카카오뱅크',
  ];

  // 이미지 리스트
  final List<File> _selectedImages = [];

  // 드롭다운 생성 (취소 사유).
  void _createOverlayReason() {
    if (_overlayEntryReason == null) {
      _overlayEntryReason = _customDropdown(_returnReasons, _layerLinkReason, (int index) {
        setState(() {
          _dropdownText = _returnReasons[index].ctName ?? "";
          _dropdownValue = _returnReasons[index].ctIdx ?? 0;
          if (_dropdownValue == 8 || _dropdownValue == 9) {
            _infoVisible = true;
          } else {
            _infoVisible = false;
          }
          _updateCollectedData();
        });
      });
      Overlay.of(context).insert(_overlayEntryReason!);
    }
  }

  // 드롭다운 생성 (은행명).
  void _createOverlayBank() {
    if (_overlayEntryBank == null) {
      _overlayEntryBank = _customDropdown(_returnBank, _layerLinkBank, (int index) {
        setState(() {
          _dropdownAccount = _returnBank[index];
          _updateCollectedData();
        });
      });
      Overlay.of(context).insert(_overlayEntryBank!);
    }
  }

  // 드롭다운 해제 (취소 사유).
  void _removeOverlayReason() {
    _overlayEntryReason?.remove();
    _overlayEntryReason = null;
  }

  // 드롭다운 해제 (은행명).
  void _removeOverlayBank() {
    _overlayEntryBank?.remove();
    _overlayEntryBank = null;
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage(
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 80,
    );
    if (images != null) {
      setState(() {
        // 현재 선택된 이미지 개수에 따라 추가될 이미지를 제한
        if (_selectedImages.length + images.length <= 3) {
          _selectedImages.addAll(images.map((image) => File(image.path)).toList());
          _updateCollectedData();
        } else {
          // 남은 자리에만 이미지를 추가
          int remainingSlots = 3 - _selectedImages.length;
          _selectedImages.addAll(images.take(remainingSlots).map((image) => File(image.path)).toList());
          _updateCollectedData();
        }
      });
    }
  }

  @override
  void dispose() {
    _removeOverlayReason();
    _removeOverlayBank();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _returnReasons = widget.returnCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      // 하단 버튼 공간 확보
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 취소사유 선택
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_overlayEntryReason == null) {
                      _createOverlayReason();
                    } else {
                      _removeOverlayReason();
                    }
                  },
                  child: Center(
                    child: CompositedTransformTarget(
                      link: _layerLinkReason, // 취소 사유 LayerLink
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE1E1E1),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dropdownText,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                            SvgPicture.asset('assets/images/product/ic_select.svg'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _infoVisible,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 10),
                    child: Text(
                      '! 불량·파손·오배송 시 판매자 부담으로 처리됩니다.',
                      style: TextStyle(
                        color: const Color(0xFFFF6192),
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                      ),
                    ),
                  ),
                ),
                Padding(
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
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      counter: Align(
                        alignment: Alignment.centerLeft, // 왼쪽 정렬
                        child: Text(
                          '${_detailedReason.length}/500',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 13),
                            color: const Color(0xFF7B7B7B),
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _detailedReason = value;
                        _updateCollectedData();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.orderDetailInfoData?.order?.otPayType == "계좌 이체",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      Text(
                        '환불계좌',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 13),
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '*',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 13),
                            color: const Color(0xFFFF6192),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (_overlayEntryBank == null) {
                                _createOverlayBank();
                              } else {
                                _removeOverlayBank();
                              }
                            },
                            child: Center(
                              child: CompositedTransformTarget(
                                link: _layerLinkBank, // 은행명 LayerLink
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFE1E1E1)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _dropdownAccount,
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          color: Colors.black,
                                        ),
                                      ),
                                      SvgPicture.asset('assets/images/product/ic_select.svg'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: TextField(
                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                          style: TextStyle(
                            decorationThickness: 0,
                            height: 1.2,
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                          ),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                            hintText: '환불받을 은행계좌',
                            hintStyle: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: const Color(0xFF595959),
                              height: 1.2,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _returnAccount = value;
                              _updateCollectedData();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 사진 선택 및 표시
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '사진',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 13),
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '최대3장',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: const Color(0xFF7B7B7B),
                          fontSize: Responsive.getFont(context, 13),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _pickImages, // 이미지 선택 함수 호출
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(color: const Color(0xFFDDDDDD))),
                    child: Center(
                      child: Text(
                        '첨부하기',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          fontWeight: FontWeight.normal,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                // 선택된 이미지 표시
                if (_selectedImages.isNotEmpty)
                  Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            border: Border.all(
                              color: const Color(0xFFE7EAEF),
                            ),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                // 모서리를 둥글게 설정 (6)
                                child: Image.file(
                                  _selectedImages[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 7,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages.removeAt(index);
                                    });
                                  },
                                  child: SvgPicture.asset('assets/images/ic_del.svg'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ExchangeReturnInfoChildWidget(userType: widget.userType,orderDetailData: widget.orderDetailData, returnInfoData: widget.returnInfoData ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 10,
            width: double.infinity,
            color: const Color(0xFFF5F9F9),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
            child: Text(
              '교환/반품 정책',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 18),
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          Container(
            height: _deliveryWebViewHeight,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
            child: InAppWebView(
              initialFile: "assets/html/exchange.html",
              initialSettings: InAppWebViewSettings(
                transparentBackground: true,
              ),
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  Future.delayed(const Duration(seconds: 2), () {
                    controller.getContentHeight().then((height) {
                      setState(() {
                        _deliveryWebViewHeight = double.parse(height.toString());
                      });
                    });
                  });
                }
              },
              onZoomScaleChanged: (controller, o, n) {
                controller.reload();
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isAgree = !_isAgree;
                _updateCollectedData();
              });
            },
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(6),
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(
                        color: _isAgree ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                      ),
                      color: _isAgree ? const Color(0xFFFF6191) : Colors.white,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/check01_off.svg', // 체크박스 아이콘
                      colorFilter: ColorFilter.mode(
                        _isAgree ? Colors.white : const Color(0xFFCCCCCC),
                        BlendMode.srcIn,
                      ),
                      height: 10,
                      width: 10,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    '교환/반품 안내사항을 확인했습니다.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  OverlayEntry _customDropdown(List<dynamic> items, LayerLink link, Function(int) onSelect) {
    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.9,
        child: CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: Material(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE1E1E1)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  String textStr = "";
                  if (items[index] is CategoryData) {
                    textStr = (items[index] as CategoryData).ctName ?? "";
                  } else {
                    textStr = items[index].toString();
                  }

                  return CupertinoButton(
                    pressedOpacity: 1,
                    minSize: 0,
                    onPressed: () {
                      onSelect(index);
                      if (link == _layerLinkReason) {
                        _removeOverlayReason();
                      } else {
                        _removeOverlayBank();
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        textStr,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateCollectedData() {
    String reason = _dropdownText;
    int reasonIdx = _dropdownValue;
    String details = _detailedReason;
    String returnBank = _dropdownAccount;
    String returnAccount = _returnAccount;
    List<File> images = _selectedImages; // 이미지를 리스트로 수집
    bool isAgree = _isAgree;
    widget.onDataCollected(reason, reasonIdx, details, returnBank, returnAccount, images, isAgree);
  }
}
