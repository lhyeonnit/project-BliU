import 'package:BliU/data/info_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class ProductInfoBeforeOrder extends StatelessWidget {
  final InfoData? infoData;

  const ProductInfoBeforeOrder({super.key, required this.infoData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 배너
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/product/check_before@2x.png',
                    height: 80,
                  ),
                ),
              ),
              Positioned(
                  left: 110,
                  top: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '구매 전 필수 확인',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 16),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '만족스러운 쇼핑을 위해 구매 전에 꼼꼼히 \n살펴보세요.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 12),
                          color: const Color(0xFF6A5B54),
                          height: 1.2,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          // 배송 안내 섹션
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              // 선 제거

              child: ExpansionTile(
                title: Text(
                  '배송안내',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.getFont(context, 14),
                    height: 1.2,
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F9F9),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          infoData?.delivery ?? "",
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            color: Colors.black54,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 교환/반품 안내 섹션
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            // 선 제거
            child: ExpansionTile(
              title: Text(
                '교환/반품 안내',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F9F9),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      infoData?.returnVal ?? "",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 개별 정보 항목을 표시하는 위젯
// class _InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _InfoRow({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: const TextStyle( fontFamily: 'Pretendard',
// fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle( fontFamily: 'Pretendard',
// color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
