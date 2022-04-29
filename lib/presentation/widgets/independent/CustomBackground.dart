import 'package:flutter/material.dart';
import 'package:sample_nearest_address/config/theme.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
        return
          Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.white,AppColors.lightPrimary, AppColors.colorSecondPrimary])),
        );
  }
}