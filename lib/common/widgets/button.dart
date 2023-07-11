import 'package:flutter/cupertino.dart';

import 'package:to_do_app/common/utils/theme.dart';
import 'package:to_do_app/common/utils/colors.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.label, required this.onTap});

  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClrMaterial,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: whiteClr,
            ),
          ),
        ),
      ),
    );
  }
}
