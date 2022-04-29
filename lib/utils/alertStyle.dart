import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../config/theme.dart';

AlertStyle alertStyle() {
  return  AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(color:AppColors.white, fontSize: 15),
    descTextAlign: TextAlign.start,
    animationDuration: const Duration(milliseconds: 500),
    backgroundColor: AppColors.black,
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: const BorderSide(
        width: 0.5,
        color: AppColors.lightPrimary,
      ),
    ),
    titleStyle: const TextStyle(
      color: Colors.red,
    ),
    alertAlignment: Alignment.center,
  );
}