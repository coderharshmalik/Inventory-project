import 'package:flutter/material.dart';
import 'landing_screen.dart';
import 'package:inventory_v1/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'summary_screen.dart';
import 'package:inventory_v1/controller/firebase_networks.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CheckoutScreen extends StatefulWidget {
  final billNumber;
  final totalPrice;

  CheckoutScreen({
    this.billNumber,
    this.totalPrice,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool showLoading = false;

  Future addSoldProductsToFireBase() async {
    String allSoldProductIds = '',
        allSoldProductDescription = '',
        allSoldProductRates = '',
        allSoldProductSizes = '';
    for (String soldProd in productsChosenForSale) {
      allSoldProductIds = allSoldProductIds + regexForSoldProducts + soldProd;
    }
    for (String soldProdDesc in productDescriptionsChosenForSale) {
      allSoldProductDescription =
          allSoldProductDescription + regexForSoldProducts + soldProdDesc;
    }
    for (String soldProdRates in productRatesChosenForSale) {
      allSoldProductRates =
          allSoldProductRates + regexForSoldProducts + soldProdRates;
    }
    for (String soldProdSize in productSizesChosenForSale) {
      allSoldProductSizes =
          allSoldProductSizes + regexForSoldProducts + soldProdSize;
    }
    allSoldProductIds =
        allSoldProductIds.substring(regexForSoldProducts.length);
    allSoldProductDescription =
        allSoldProductDescription.substring(regexForSoldProducts.length);
    allSoldProductRates =
        allSoldProductRates.substring(regexForSoldProducts.length);
    allSoldProductSizes =
        allSoldProductSizes.substring(regexForSoldProducts.length);
    try {
      await addSoldProductsRecord(
        allSoldProductIds,
        allSoldProductRates,
        allSoldProductDescription,
        allSoldProductSizes,
        widget.totalPrice.toString(),
        productsChosenForSale.length.toString(),
      );
    } catch (e) {
      print('Error in adding bill to Fire');
    }
  }

  Future deleteSoldProductsFromFirestore(List<String> products) async {
    try {
      for (String eachProds in products) {
        await deleteProductFromFireStoreWithProductId(eachProds.trim());
      }
    } catch (e) {
      print('Error in deletion');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showLoading,
      opacity: 0.1,
      progressIndicator: CircularProgressIndicator(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronLeft,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Checkout',
            ),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8.0,
                ),
                child: Text(
                  'Verify Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8.0,
                ),
                child: Text(
                  'Bill: ${widget.billNumber}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: productsChosenForSale.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          child: Card(
                            color: kCardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    productsChosenForSale[index],
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.rupeeSign,
                                        size: 14,
                                      ),
                                      Text(
                                        productRatesChosenForSale[index],
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quantity : ${productsChosenForSale.length}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Total Price : ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.rupeeSign,
                          size: 14,
                        ),
                        Text(
                          '${widget.totalPrice}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                child: MaterialButton(
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  height: 40,
                  textColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                  ),
                  color: Colors.deepPurpleAccent,
                  onPressed: () async {
                    setState(() => showLoading = true);
                    await addSoldProductsToFireBase();
                    await deleteSoldProductsFromFirestore(
                        productsChosenForSale);
                    setState(() => showLoading = false);
                    Route route = MaterialPageRoute(
                      builder: (context) => SummaryScreen(
                        billNumber: finalNewBillNumber,
                        totalPrice: widget.totalPrice,
                      ),
                    );
                    Navigator.pushReplacement(context, route);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
