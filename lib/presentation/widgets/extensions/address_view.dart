import 'package:flutter/material.dart';
import 'package:sample_nearest_address/data/model/addressData.dart';
import 'package:sample_nearest_address/presentation/widgets/data_driven/base_address_list_item.dart';
import 'package:sample_nearest_address/utils/strings.dart';
import '../../../config/theme.dart';

extension View on Address {
  Widget getListView(
      {required BuildContext context,
        required VoidCallback deleteFunction,
        required VoidCallback editFunction,
        required int index,
      })
  {
    return BaseAddressListItem(
        deleteButton: _getDeleteButton(context, deleteFunction),
        editButton: _getEditButton(context, editFunction),
        mainContentBuilder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildAddress(Theme.of(context), index),
              const SizedBox(height: 4,),
              Text(addressText,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14,
                      color: AppColors.colorPrimary,
                      fontWeight: FontWeight.normal)),
            ],
          );
        }
    );
  }

  Widget _getDeleteButton(BuildContext context, VoidCallback deleteFunction) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: AppColors.red,
      onPressed: deleteFunction,
      child: const Padding(
        padding: EdgeInsets.only(left: 2, bottom: 2),
        child: Icon(Icons.delete_forever_outlined, color: AppColors.white,),
      ),
    );
  }

  Widget _getEditButton(BuildContext context, VoidCallback editFunction) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: AppColors.colorPrimary,
      onPressed: editFunction,
      child: const Padding(
        padding: EdgeInsets.only(left: 2, bottom: 2),
        child: Icon(Icons.edit, color: AppColors.white,),
      ),
    );
  }

  Widget buildAddress(ThemeData _theme, int index) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(Strings.address, style: TextStyle(fontSize: 14, color: _theme.primaryColor, fontWeight: FontWeight.bold)),
          Text((index + 1).toString() + ":", style: TextStyle(fontSize: 14, color: _theme.hoverColor, fontWeight: FontWeight.bold)),
        ]
    );
  }

}
