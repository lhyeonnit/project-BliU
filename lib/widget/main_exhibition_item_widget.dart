import 'package:flutter/material.dart';

class MainExhibitionItemWidget extends StatelessWidget {

  const MainExhibitionItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container( // TODO 큰 이미지
            color: Colors.cyanAccent,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            alignment: Alignment.bottomCenter,
            child: const Column(
              children: [

              ],
            ),
          )
        ],
      ),
    );
  }

}