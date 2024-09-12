import 'package:BliU/data/product_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductAi extends StatefulWidget {
  final List<ProductData> productList;
  const ProductAi({super.key, required this.productList});

  @override
  _ProductAiState createState() => _ProductAiState();
}

class _ProductAiState extends State<ProductAi> {
  late List<ProductData> productList;

  @override
  Widget build(BuildContext context) {
    productList = widget.productList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '연관 상품',
            style: TextStyle(
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(
          height: 280, // 높이를 설정하여 이미지 카드들이 가로로 스크롤되도록 함
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤 가능하도록 설정
            itemCount: productList.length, // 임의의 연관 상품 갯수
            itemBuilder: (context, index) {
              final productData = productList[index];

              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  width: 160, // 가로 너비를 160으로 고정
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)), // 사진의 모서리만 둥글게 설정
                            child: Image.network(
                              productData.ptImg ?? "",
                              height: 160,
                              width: 160, // 고정된 너비 설정
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                //TODO 좋아요 액션
                                // if (productData.likeChk == "Y") {
                                //   productList[index].likeChk = "N";
                                // } else {
                                //   productList[index].likeChk = "Y";
                                // }
                              },
                              child: Icon(
                                productList[index].likeChk == "Y"
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: productList[index].likeChk == "Y"
                                    ? Colors.pink
                                    : Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productData.stName ?? "",
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 12),
                                color: Colors.grey
                              ),
                            ),
                            const SizedBox(height: 4), // 텍스트와 텍스트 사이에 간격 추가
                            Text(
                              productData.ptName ?? "",
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1, // 한 줄만 표시
                              overflow: TextOverflow.ellipsis, // 길면 생략부호 처리
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                (productData.ptDiscountPer ?? 0) > 0 ?
                                Row(
                                  children: [
                                    Text(
                                      '${productData.ptDiscountPer ?? 0}%',
                                      style: TextStyle(
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ]
                                ) : Container(),
                                Text(
                                  '${Utils.getInstance().priceString(productData.ptPrice ?? 0)}원',
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1, // 한 줄만 표시
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite_outline,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  Utils.getInstance().priceString(productData.ptLike ?? 0),
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 12),
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1, // 한 줄만 표시
                                ),
                                const SizedBox(width: 10), // 고정된 공간을 추가하여 아이콘과 텍스트 간격 유지
                                const Icon(
                                  Icons.people,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  Utils.getInstance().priceString(productData.ptReview ?? 0),
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 12),
                                    color: Colors.grey
                                  ),
                                  maxLines: 1, // 한 줄만 표시
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
