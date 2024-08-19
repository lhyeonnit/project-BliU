import 'package:flutter/material.dart';

import 'my_info_edit_check.dart';
import 'my_info_edit_screen.dart';

class MyInfo extends StatelessWidget {
  const MyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: const AssetImage(
                'assets/images/my/gender_select_boy.png'),
            backgroundColor: Colors.pinkAccent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '김아름님 안녕하세요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('id1234'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyInfoEditCheck(),
                ),
              );

            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text('내정보수정',style: TextStyle(color: Colors.black),),
          ),
        ],
      ),

    );
  }
}
