import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget appBar;

  const MyAppBar({super.key, required this.appBar});

  ///width doesnt matter
  @override
  Size get preferredSize => Size(
      Utils.getInstance().isWeb() ? 450 : double.infinity,
      kToolbarHeight
  );

  @override
  Widget build(BuildContext context) {
    if (Utils.getInstance().isWeb()) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          color: Colors.pink,
          // we can set width here with conditions
          width: 450,
          height: kToolbarHeight,
          child: appBar,
        ),
      );
    } else {
      return appBar;
    }
  }
}