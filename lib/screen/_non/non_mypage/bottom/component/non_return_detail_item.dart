import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../utils/responsive.dart';
import 'non_exchange_return_info.dart';

class NonReturnDetailItem extends StatefulWidget {
  final Function(String reason, String detail, String returnAccount, String returnBank, List<File> images) onDataCollected;

  const NonReturnDetailItem({required this.onDataCollected, Key? key}) : super(key: key);

  @override
  State<NonReturnDetailItem> createState() => _NonReturnDetailItemState();
}

class _NonReturnDetailItemState extends State<NonReturnDetailItem> {
  OverlayEntry? _overlayEntryReason; // 취소 사유 드롭다운
  OverlayEntry? _overlayEntryBank;   // 은행명 드롭다운
  String _dropdownValue = '사유 선택';
  String _dropdownAccount = '은행명';
  String _detailedReason = '';
  String _returnAccount = '';

  final LayerLink _layerLinkReason = LayerLink(); // 취소 사유 드롭다운을 위한 LayerLink
  final LayerLink _layerLinkBank = LayerLink();   // 은행명 드롭다운을 위한 LayerLink

  final List<String> _returnReasons = [
    '색상 및 사이즈 변경',
    '제품 불량',
    '배송 중 손상',
    '오배송',
    '기타',
  ];

  final List<String> _returnBank = [
    '국민은행',
    '농협은행',
    '우리은행',
    '카카오뱅크',
  ];

  // 이미지 리스트
  List<File> _selectedImages = [];

  // 드롭다운 생성 (취소 사유).
  void _createOverlayReason() {
    if (_overlayEntryReason == null) {
      _overlayEntryReason = _customDropdown(_returnReasons, _layerLinkReason, (String selected) {
        setState(() {
          _dropdownValue = selected;
          _updateCollectedData();
        });
      });
      Overlay.of(context).insert(_overlayEntryReason!);
    }
  }

  // 드롭다운 생성 (은행명).
  void _createOverlayBank() {
    if (_overlayEntryBank == null) {
      _overlayEntryBank = _customDropdown(_returnBank, _layerLinkBank, (String selected) {
        setState(() {
          _dropdownAccount = selected;
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
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      // 하단 버튼 공간 확보
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 취소사유 선택
          Padding(
            padding: EdgeInsets.symmetric(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE1E1E1)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dropdownValue,
                              style: TextStyle(
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
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 10),
                  child: Text(
                    '! 판매자 귀책이 아닐 시 반품 비용이 발생할 수 있습니다.',
                    style: TextStyle(fontSize: Responsive.getFont(context, 12)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: TextField(
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      hintText: '세부 내용 입력',
                      hintStyle: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Color(0xFF595959)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      counter: Align(
                        alignment: Alignment.centerLeft, // 왼쪽 정렬
                        child: Text(
                          '${_detailedReason.length}/500',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 13),
                            color: Color(0xFF7B7B7B),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Text(
                  '환불계좌',
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 13),
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '*',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 13),
                      color: Color(0xFFFF6192),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Expanded(
                    flex: 3,
                    child: Container(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE1E1E1)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _dropdownAccount,
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.black,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                      'assets/images/product/ic_select.svg'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    child: TextField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                        hintText: '환불받을 은행계좌',
                        hintStyle: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFF595959)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
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
                ),
              ],
            ),
          ),
          // 사진 선택 및 표시
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
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
                            color: Color(0xFF7B7B7B),
                            fontSize: Responsive.getFont(context, 13)),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      border: Border.all(color: Color(0xFFDDDDDD))),
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
                  Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                            border: Border.all(
                              color: Color(0xFFE7EAEF),
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

                NonExchangeReturnInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OverlayEntry _customDropdown(
      List<String> items, LayerLink link, Function(String) onSelect) {
    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.9,
        child: CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: Offset(0, 50),
          child: Material(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE1E1E1)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    pressedOpacity: 1,
                    minSize: 0,
                    onPressed: () {
                      onSelect(items.elementAt(index));
                      if (link == _layerLinkReason) {
                        _removeOverlayReason();
                      } else {
                        _removeOverlayBank();
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        items.elementAt(index),
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
    String reason = _dropdownValue;
    String details = _detailedReason;
    String returnBank = _dropdownAccount;
    String returnAccount = _returnAccount;
    List<File> images = _selectedImages; // 이미지를 리스트로 수집
    widget.onDataCollected(reason, details, returnBank, returnAccount, images);
  }
}