import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_v1/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_v1/controller/firebase_networks.dart';
import 'package:inventory_v1/screens/sales_screen.dart';
import 'package:inventory_v1/widgets/sizes_dropdown.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:inventory_v1/widgets/toast.dart';

import 'landing_screen.dart';
import 'list_products_for_sale_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  bool showLoading = false;
  bool deleteValue = false;
  final String productId;
  String productDesc;
  final String productAddDate;
  final String productAddMonth;
  final String productAddYear;
  String size;
  String rate;

  ProductDetailsScreen({
    this.productId,
    this.productDesc,
    this.productAddDate,
    this.productAddMonth,
    this.productAddYear,
    this.size,
    this.rate,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController sizeController = TextEditingController();

  showAlertDialog(BuildContext context, String prodId) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          backgroundColor: kCardColor,
          title: Text(
            'Confirm',
            style: TextStyle(fontSize: 20),
          ),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Are you sure you wish to delete ' + prodId + ' Product?',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.0),
                            ),
                          ),
                          child: Text(
                            'CANCEL',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await deleteProductFromFireStoreWithProductId(
                              widget.productId);
                          ShowingToast(context: context).showSuccessToast(
                              "Product " +
                                  widget.productId +
                                  " deleted Successfully");
                          widget.deleteValue = true;
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(32.0)),
                          ),
                          child: Text(
                            'DELETE',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    productDescriptionController.text = widget.productDesc;
    rateController.text = widget.rate;
    sizeController.text = widget.size;

    productDescriptionController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: productDescriptionController.text.length,
      ),
    );
    rateController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: rateController.text.length,
      ),
    );
    return ModalProgressHUD(
      inAsyncCall: widget.showLoading,
      opacity: 0.1,
      progressIndicator: CircularProgressIndicator(
        color: Colors.white,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shadowColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Product Details'),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(''),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            'Product ID:',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          widget.productId,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Product Description:',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              widget.productDesc = value;
                            },
                            initialValue: productDescriptionController.text,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(500),
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFE2E3E3),
                              labelStyle: kAddProductTextFieldLableStyle,
                              contentPadding: EdgeInsets.all(10),
                              border: kAddProductTextFieldBorder,
                              focusedBorder: kAddProductTextFieldFocusedBorder,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                'Size:',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizesDropdown(
                              iconColor: Colors.white,
                              backgroundColor: kCardColor,
                              controller: sizeController,
                              onPress: (value) {
                                setState(() {
                                  widget.size = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                'Rate:',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 75,
                              child: TextFormField(
                                onChanged: (value) {
                                  widget.rate = value;
                                },
                                initialValue: rateController.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFE2E3E3),
                                  labelStyle: kAddProductTextFieldLableStyle,
                                  contentPadding: EdgeInsets.all(10),
                                  border: kAddProductTextFieldBorder,
                                  focusedBorder:
                                      kAddProductTextFieldFocusedBorder,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              setState(() => widget.showLoading = true);
                              await generateSalesDocumentID();
                              await generateBillNumber();
                              finalList.clear();
                              productsChosenForSale.clear();
                              productDescriptionsChosenForSale.clear();
                              productRatesChosenForSale.clear();
                              productSizesChosenForSale.clear();
                              setState(() => widget.showLoading = false);
                              Route route = MaterialPageRoute(
                                builder: (context) => SalesScreen(
                                  productId: widget.productId,
                                  productDesc: widget.productDesc,
                                  size: widget.size,
                                  rate: widget.rate,
                                ),
                              );
                              Navigator.pushReplacement(context, route);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Icon(
                                    FontAwesomeIcons.rupeeSign,
                                    color: kCardColor,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'SELL',
                                    style: TextStyle(
                                      color: kCardColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            color: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              setState(() => widget.showLoading = true);
                              await updateProductWithProductID(
                                context,
                                widget.productId,
                                widget.productDesc,
                                widget.size,
                                widget.rate,
                                widget.productAddDate,
                                widget.productAddMonth,
                                widget.productAddYear,
                              );
                              setState(() => widget.showLoading = false);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.check_circle_sharp,
                                    color: kCardColor,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'UPDATE',
                                    style: TextStyle(
                                      color: kCardColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            color: Colors.amberAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      child: Text(
                        'DELETE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await showAlertDialog(context, widget.productId);
                        if (widget.deleteValue) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    Text(
                      'ADDED ON : ${widget.productAddDate} ' +
                          widget.productAddMonth.toString().toUpperCase() +
                          '\'${widget.productAddYear}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
