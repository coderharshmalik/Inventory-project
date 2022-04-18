import 'package:flutter/material.dart';
import 'landing_screen.dart';
import 'package:inventory_v1/controller/firebase_networks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_v1/constants.dart';
import 'checkout_screen.dart';
import 'package:inventory_v1/widgets/toast.dart';
import 'list_products_for_sale_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SalesScreen extends StatefulWidget {
  final String id = '/SalesScreen';
  final String productId;
  final String productDesc;
  final String size;
  final String rate;

  SalesScreen({
    this.productId,
    this.productDesc,
    this.size,
    this.rate,
  });

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  bool showLoading = false;
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    if (widget.productId != null &&
        !(productsChosenForSale.contains(widget.productId))) {
      productsChosenForSale.add(widget.productId);
      productDescriptionsChosenForSale.add(widget.productDesc);
      productRatesChosenForSale.add(widget.rate);
      productSizesChosenForSale.add(widget.size);
    }

    for (String rateInList in productRatesChosenForSale) {
      totalPrice = totalPrice + double.parse(rateInList);
    }

    return ModalProgressHUD(
      inAsyncCall: showLoading,
      opacity: 0.1,
      progressIndicator: CircularProgressIndicator(
        color: Colors.white,
      ),
      child: WillPopScope(
        onWillPop: () async {
          productsChosenForSale.clear();
          productRatesChosenForSale.clear();
          productDescriptionsChosenForSale.clear();
          productSizesChosenForSale.clear();
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  FontAwesomeIcons.chevronLeft,
                ),
                onPressed: () {
                  productsChosenForSale.clear();
                  productRatesChosenForSale.clear();
                  productDescriptionsChosenForSale.clear();
                  productSizesChosenForSale.clear();
                  Navigator.of(context).pop();
                },
              ),
              title: Text('Sales'),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Text(
                      finalNewBillNumber != null
                          ? 'Bill No: ' + finalNewBillNumber
                          : 'Bill No: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                productsChosenForSale.length != 0
                    ? Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: productsChosenForSale.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
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
                                                productRatesChosenForSale[
                                                    index],
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
                      )
                    : Expanded(
                        child: Text(''),
                      ),
                IconButton(
                  onPressed: () async {
                    setState(() => showLoading = true);
                    await generateProductListForSale();
                    setState(() => showLoading = false);
                    Navigator.pushNamed(context, ListProductsForSaleScreen().id)
                        .then((_) => setState(() {}));
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 35,
                  ),
                ),
                Divider(
                  thickness: 2,
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
                        productsChosenForSale.length != 0
                            ? 'Quantity : ${productsChosenForSale.length}'
                            : 'Quantity : 0',
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
                            '$totalPrice',
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
                      'PROCEED TO CHECKOUT',
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
                    onPressed: () {
                      if (productsChosenForSale.length > 0) {
                        Route route = MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            billNumber: finalNewBillNumber,
                            totalPrice: totalPrice,
                          ),
                        );
                        Navigator.push(context, route)
                            .then((_) => setState(() {}));
                      } else {
                        ShowingToast(context: context).showFailureToast(
                          'No products added to sell',
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
