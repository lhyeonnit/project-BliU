import 'package:BliU/data/info_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class ProductInfoBeforeOrder extends StatelessWidget {
  final InfoData? infoData;
  const ProductInfoBeforeOrder({super.key, required this.infoData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 배너
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            'assets/images/product/check_before@2x.png',
            height: 80,
          ),
        ),
        // 배송 안내 섹션
        ExpansionTile(
          title: const Text('배송안내',style: TextStyle(fontWeight: FontWeight.bold),),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    infoData?.delivery ?? "",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                // child: const Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     _InfoRow(label: '택배사', value: 'CJ대한통운'),
                //     _InfoRow(label: '배송비', value: '기본 배송비 0000원 / 50,000 이상 무료'),
                //     _InfoRow(label: '추가 배송비', value: '도서산간 추가배송비 3000, 제주 추가배송비 3000'),
                //     _InfoRow(label: '배송 기간', value: '평균 2-5일 이내 발송 (영업일 기준)'),
                //   ],
                // ),
              ),
            ),
          ],
        ),

        // 교환/반품 안내 섹션
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // 선 제거
          child: ExpansionTile(
            title: const Text(
              '교환/반품 안내',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    infoData?.returnVal ?? "",
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 14)
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
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
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
