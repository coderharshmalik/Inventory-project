import 'package:flutter/material.dart';

const kCardColor = Color(0xFF111328);
const kAddProductColor = Color(0xFF303030);
const kbottomSheetBackgroundColor = Color(0xFFECEFF1);

const kFunctionTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
);

const kAssetAmountTextStyle = TextStyle(
  fontSize: 40.0,
  color: Colors.white70,
);

const kAddProductsTextStyle = TextStyle(
  fontSize: 25.0,
  color: Color(0xFF303030),
  fontWeight: FontWeight.bold,
);

const kAddProductTextFieldStyle = TextStyle(
  color: Colors.black,
);

const kAddProductTextFieldLableStyle = TextStyle(
  fontSize: 19.0,
  color: Colors.black38,
);

const kAddProductTextFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(20.0),
  ),
  borderSide: BorderSide.none,
);

const kAddProductTextFieldFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(20.0),
  ),
  borderSide: BorderSide(
    color: Colors.black54,
    width: 2.0,
  ),
);

const kAddProductTextFieldErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(20.0),
  ),
  borderSide: BorderSide(
    color: Colors.red,
    width: 2.0,
  ),
);

const kAddProductTextFieldEnabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(20.0),
  ),
  borderSide: BorderSide(
    color: Colors.grey,
    width: 2.0,
  ),
);

const kAddProductSizesStyle = TextStyle(
  color: kCardColor,
  fontSize: 18.0,
);

const kViewProductSizesStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
);

const kViewProductsSearchProductTextFieldDecoration = InputDecoration(
  hintText: 'Search Product...',
  hintStyle: kAddProductTextFieldLableStyle,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(60.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(60.0),
    ),
    borderSide: BorderSide(
      color: Colors.white,
      width: 2.0,
    ),
  ),
  filled: true,
  fillColor: Color(0xFFE2E3E3),
  isDense: true,
  contentPadding: EdgeInsets.all(10),
);

const kViewProductProductIdTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

const kViewProductDateTextStyle = TextStyle(
  color: Colors.grey,
  letterSpacing: 3,
  fontSize: 12,
);

const kViewProductProductDescTextStyle = TextStyle(
  fontSize: 15,
  color: Colors.amberAccent,
);

const kViewProductSizeTextStyle = TextStyle(
  color: Colors.orangeAccent,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);
