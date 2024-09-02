import 'package:flutter/material.dart';

class ProductItemWidget extends StatelessWidget {

  const ProductItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 186,
          child: Image.asset(
            'assets/app_resource/icon.png',
            fit: BoxFit.fitHeight,
          )
        ),
        Expanded(
            flex: 117,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: const Text(
                    '꿈꾸는데이지',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7B7B7B),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: const Text(
                    '꿈꾸는데이지 안나 토션 레이스 베스트',
                    style: TextStyle(
                      fontSize: 14
                    ),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        '15%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '1000원',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          color: Colors.red,
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                              ),
                              Text(
                                '13,000',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFA4A4A4)
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          color: Colors.blue,
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                              ),
                              Text(
                                '13,000',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFA4A4A4)
                                ),
                              )
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                )
              ],
            )
        )
      ],
    );
  }

}