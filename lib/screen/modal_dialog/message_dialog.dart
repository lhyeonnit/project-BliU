import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function()? doConfirm;
  const MessageDialog({super.key, required this.title, required this.message, this.doConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 18),
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      height: 1.2,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Expanded(
                    //   flex: 1,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //
                    //     },
                    //     child: Container(
                    //       margin: const EdgeInsets.only(right: 5),
                    //       height: 44,
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: const BorderRadius.all(
                    //           Radius.circular(6),
                    //         ),
                    //         border: Border.all(color: const Color(0xFFDDDDDD)),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           '취소',
                    //           style: TextStyle(
                    //             fontFamily: 'Pretendard',
                    //             fontSize: Responsive.getFont(context, 14),
                    //             color: Colors.white,
                    //             height: 1.2,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if (doConfirm != null) {
                            doConfirm?.call();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 5),
                          height: 44,
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}