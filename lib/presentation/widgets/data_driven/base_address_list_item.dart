import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class BaseAddressListItem extends StatefulWidget {
  final WidgetBuilder mainContentBuilder;
  final double imageHeight;
  final double imageWidth;
  final Widget deleteButton;
  final Widget editButton;

  const BaseAddressListItem(
      {
        required this.deleteButton,
        required this.editButton,
        required this.mainContentBuilder,
        this.imageHeight = 135,
        this.imageWidth = 135,
      })
      : super();

  @override
  _BaseAddressListItemState createState() => _BaseAddressListItemState();
}

class _BaseAddressListItemState extends State<BaseAddressListItem> {
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.imageHeight + 30,
      margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.widgetSidePadding / 4,),
      child: Opacity(
        opacity: 1,
        child: Stack(
          children: <Widget>[
            Container(
              height: widget.imageHeight,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 2),
                ],
                borderRadius: BorderRadius.circular(AppSizes.imageRadius*2),
              ),
              child: Card(color: _theme.scaffoldBackgroundColor,
                elevation: 20,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppSizes.imageRadius *2)),
                ),
                child: Stack(children: <Widget>[

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32, left: 12, right: 12, bottom: 10),
                          child: widget.mainContentBuilder(context),
                        ),
                      )
                    ],
                  ),
                ],
                ),
              ),
            ),
            Positioned(
              top: widget.imageHeight - 32,
              left: 0,
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget.editButton,
                    widget.deleteButton,
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
