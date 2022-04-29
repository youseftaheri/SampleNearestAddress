import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class SpecificationRow extends StatelessWidget {
  final String title;
  final String value;

  const SpecificationRow(
      {Key? key,
        required this.title,
        required this.value,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - AppSizes.sidePadding * 4;
    return
            Container(
              width: width,
              padding: const EdgeInsets.all(AppSizes.linePadding * 1.5),
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(AppSizes.imageRadius*5),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.colorPrimaryBack,Theme.of(context).scaffoldBackgroundColor]),
              ),
              child:
              Padding(
                padding: const EdgeInsets.only(
                    top: AppSizes.sidePadding*0.5,
                    right: AppSizes.sidePadding*0.5,
                    left: AppSizes.sidePadding*0.5,
                    bottom: AppSizes.sidePadding*0.5),
                child:
                Wrap(
                  children: [
                    Text(
                      title +
                          ' : ',
                      style: const TextStyle(fontSize: 12,
                          color: AppColors.colorSecondPinkPrimary,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      value,
                      maxLines: 5,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12,
                        color: Theme.of(context).hoverColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
        // );
  }
}
