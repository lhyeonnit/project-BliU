import 'dart:io';

import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/order_detail_info_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../utils/responsive.dart';

class ExchangeItem extends StatefulWidget {
  final OrderDetailInfoData? orderDetailInfoData;
  final List<CategoryData> exchangeCategory;
  final List<CategoryData> exchangeDeliveryCostCategory;
  final Function(String reason, int reasonIdx, String details, int shippingCost, List<File> images) onDataCollected;

  const ExchangeItem({required this.orderDetailInfoData, required this.exchangeCategory, required this.exchangeDeliveryCostCategory, required this.onDataCollected, super.key});

  @override
  State<ExchangeItem> createState() => _ExchangeItemState();
}

class _ExchangeItemState extends State<ExchangeItem> {
  OverlayEntry? _overlayEntry;
  String _dropdownText = '사유 선택';
  int _dropdownValue = 0;
  String _detailedReason = '';
  final LayerLink _layerLink = LayerLink();
  List<CategoryData> get _exchangeReasons => widget.exchangeCategory;
  List<CategoryData> get _exchangeDeliveryCostMethod => widget.exchangeDeliveryCostCategory;

  // 이미지 리스트
  List<File> _selectedImages = [];

  // 교환 배송비 선택
  int _shippingOption = 0;

  // 드롭다운 생성.
  void _createOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _customDropdown();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  // 드롭다운 해제.
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // 이미지 선택 함수
  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage(
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 80,
    );
    if (images != null) {
      setState(() {
        // 현재 선택된 이미지 개수에 따라 추가될 이미지를 제한
        if (_selectedImages.length + images.length <= 3) {
          _selectedImages
              .addAll(images.map((image) => File(image.path)).toList());
          _updateCollectedData();
        } else {
          // 남은 자리에만 이미지를 추가
          int remainingSlots = 3 - _selectedImages.length;
          _selectedImages.addAll(images
              .take(remainingSlots)
              .map((image) => File(image.path))
              .toList());
        }
      });
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
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
                    if (_overlayEntry == null) {
                      _createOverlay();
                    } else {
                      _removeOverlay();
                    }
                  },
                  child: Center(
                    child: CompositedTransformTarget(
                      link: _layerLink,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE1E1E1),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 선택값.
                            Text(
                              _dropdownText,
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                              ),
                            ),

                            // 아이콘.
                            SvgPicture.asset(
                                'assets/images/product/ic_select.svg'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextField(
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      hintText: '세부 내용 입력',
                      hintStyle: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFF595959)),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black),
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
          // 사진 선택 및 표시
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '사진',
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 13),
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '최대3장',
                      style: TextStyle(
                          color: const Color(0xFF7B7B7B),
                          fontSize: Responsive.getFont(context, 13)),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                      border: Border.all(color: const Color(0xFFDDDDDD))),
                  child: GestureDetector(
                    onTap: _pickImages, // 이미지 선택 함수 호출
                    child: Center(
                        child: Text(
                      '첨부하기',
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          fontWeight: FontWeight.normal),
                    )),
                  ),
                ),
                // 선택된 이미지 표시
                if (_selectedImages.isNotEmpty)
                  SizedBox(
                    height: 100,
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
                                  fit: BoxFit.cover,
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
                                  child: SvgPicture.asset(
                                      'assets/images/ic_del.svg'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          // 교환 배송비 선택
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '교환 배송비',
                      style: TextStyle(
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
                          fontSize: Responsive.getFont(context, 13),
                          color: const Color(0xFFFF6192),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ..._exchangeDeliveryCostMethod.map((categoty) {
                int index = _exchangeDeliveryCostMethod.indexOf(categoty);
                return Row(
                  children: [
                    Radio(
                      value: index,
                      groupValue: _shippingOption,
                      onChanged: (value) {
                        setState(() {
                          _shippingOption = value ?? 0;
                          _updateCollectedData();
                        });
                      },
                      activeColor: const Color(0xFFFF6192),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return const Color(0xFFDDDDDD); // 비선택 상태의 라디오 버튼 색상
                        }
                        return const Color(0xFFFF6192); // 선택된 상태의 색상
                      }),
                    ),
                    Expanded(
                      child: Text(
                        categoty.ctName ?? "",
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  OverlayEntry _customDropdown() {
    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.9, // 드롭다운 너비 설정
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50), // 드롭다운이 열리는 위치 설정
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
                itemCount: _exchangeReasons.length,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    pressedOpacity: 1,
                    minSize: 0,
                    onPressed: () {
                      setState(() {
                        _dropdownText = _exchangeReasons[index].ctName ?? "";
                        _dropdownValue = _exchangeReasons[index].ctIdx ?? 0;
                        _updateCollectedData();
                      });
                      _removeOverlay();
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _exchangeReasons[index].ctName ?? "",
                        style: TextStyle(
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
    int shippingCost = _exchangeDeliveryCostMethod[_shippingOption].ctIdx ?? 0;
    List<File> images = _selectedImages; // 이미지를 리스트로 수집
    widget.onDataCollected(reason, reasonIdx, details, shippingCost, images);
  }
}
