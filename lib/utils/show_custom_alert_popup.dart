import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

showCustomAlertPopup({required BuildContext context,
  required String type, required AlertStyle style,
  required String title, required String message,
  required String button1, required VoidCallback onTap1,
  required String button2, required VoidCallback onTap2}) async {
  await Alert(
      context: context,
      style: style,
      title: title,
      desc: message,
      image: Image.asset('assets/img/address_logo.webp', width: 30, height: 30,),
      buttons:
      button1.isEmpty ? [] :
      (button2.isEmpty ? [
        DialogButton(
          onPressed: onTap1,
          child: Text(button1, style: const TextStyle(color: AppColors.white,fontSize: 15),
          ),
        )] : [DialogButton(
        onPressed: onTap1,
        child: Text(button1, style: const TextStyle(color: Colors.white, fontSize: 15),),
      ),
        DialogButton(
          onPressed: onTap2,
          child: Text(button2, style: const TextStyle(color: Colors.white, fontSize: 15),),
        )]
      )).show();
}