import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_v1/constants.dart';
import 'package:inventory_v1/widgets/add_products_text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:inventory_v1/controller/firebase_networks.dart';
import 'package:inventory_v1/widgets/sizes_dropdown.dart';

class AddProductsScreen extends StatefulWidget {
  final String id = '/addProductsScreen';
  @override
  _AddProductsScreenState createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  TextEditingController productIdController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  int rate = 1;
  String size = sizeListFromFireStore.first.value;
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    productIdController.text = finalNewProductId;
    sizeController.text = size;
    rateController.text = rate.toString();
    rateController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: rateController.text.length,
      ),
    );
    productDescriptionController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: productDescriptionController.text.length,
      ),
    );
    return ModalProgressHUD(
      inAsyncCall: showLoading,
      child: Container(
        decoration: BoxDecoration(
          color: kbottomSheetBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.all(20.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Text(
                'Add Product',
                style: kAddProductsTextStyle,
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: AddProductsTextField(
                            maxLines: 1,
                            lableTextForTextField: 'Product ID',
                            controller: productIdController,
                            editable: false,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: AddProductsTextField(
                            lableTextForTextField: 'Description',
                            textInputType: TextInputType.multiline,
                            maxLines: 4,
                            inputFormat: [
                              LengthLimitingTextInputFormatter(500),
                            ],
                            onChangeFunction: (value) {
                              productDescriptionController.text = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Size:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              SizesDropdown(
                                iconColor: Colors.black,
                                backgroundColor: kbottomSheetBackgroundColor,
                                controller: sizeController,
                                onPress: (value) {
                                  setState(() {
                                    size = value;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.minus,
                                    color: kCardColor,
                                  ),
                                  onPressed: rate <= 1
                                      ? null
                                      : () {
                                          setState(() {
                                            rate = rate - 1;
                                          });
                                        },
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: AddProductsTextField(
                                  lableTextForTextField: 'Rate',
                                  inputFormat: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.digitsOnly,
                                    // FilteringTextInputFormatter.allow(
                                    //   RegExp('[0-9]{5}\.[0-9]{2}'),
                                    // )
                                  ],
                                  onChangeFunction: (value) {
                                    setState(() {
                                      rate = int.parse(value);
                                    });
                                  },
                                  controller: rateController,
                                  textInputType: TextInputType.number,
                                ),
                              ),
                              InkWell(
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.plus,
                                    color: kCardColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      rate = rate + 1;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 17.0,
                              ),
                              child: FloatingActionButton(
                                backgroundColor: kCardColor,
                                child: Icon(
                                  FontAwesomeIcons.check,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await addProduct(
                                    context,
                                    productIdController.text,
                                    productDescriptionController.text,
                                    sizeController.text,
                                    rateController.text,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
