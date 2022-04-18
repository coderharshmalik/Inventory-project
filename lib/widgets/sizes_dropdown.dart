import 'package:flutter/material.dart';
import 'package:inventory_v1/controller/firebase_networks.dart';

Future getSizesDropdown(TextStyle textStyle) async {
  if (sizeFromFireStore != null) {
    sizeListFromFireStore = [];
    for (String sizeForList in sizeFromFireStore.data().values) {
      var newItem = DropdownMenuItem(
        child: Text(
          sizeForList,
          style: textStyle,
        ),
        value: sizeForList,
      );
      sizeListFromFireStore.add(newItem);
    }
  } else {
    await getSizesFromFireBase();
    sizeListFromFireStore = [];
    for (String sizeForList in sizeFromFireStore.data().values) {
      var newItem = DropdownMenuItem(
        child: Text(
          sizeForList,
          style: textStyle,
        ),
        value: sizeForList,
      );
      sizeListFromFireStore.add(newItem);
    }
  }
}

class SizesDropdown extends StatelessWidget {
  final Color iconColor;
  final Color backgroundColor;
  final TextEditingController controller;
  final Function onPress;

  SizesDropdown({
    this.iconColor,
    this.backgroundColor,
    this.controller,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      iconEnabledColor: iconColor,
      dropdownColor: backgroundColor,
      value: controller.text,
      items: sizeListFromFireStore,
      onChanged: onPress,
    );
  }
}
