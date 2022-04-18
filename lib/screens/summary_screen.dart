import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart';
import 'landing_screen.dart';
import 'package:share_plus/share_plus.dart';

class SummaryScreen extends StatelessWidget {
  final billNumber;
  final totalPrice;

  SummaryScreen({
    this.billNumber,
    this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    String shareBillText =
        'LMNS Shop\nBill No: $billNumber\n${productsChosenForSale.length} products sold at $totalPrice';
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Summary'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Share.share(shareBillText);
                },
                icon: Icon(
                  Icons.share,
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 8.0,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.lightGreen,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Text(
                      'All Done!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8.0,
                ),
                child: Text(
                  'Bill: $billNumber',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Text(
                      productsChosenForSale.length > 1
                          ? '${productsChosenForSale.length} products sold at price '
                          : '${productsChosenForSale.length} product sold at price ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      FontAwesomeIcons.rupeeSign,
                      size: 14,
                    ),
                    Text(
                      '$totalPrice',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      child: ListView.builder(
                        itemCount: productsChosenForSale.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage('images/sold.png'),
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                child: OutlinedButton(
                  child: Text(
                    'DONE',
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 17,
                    ),
                  ),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    productsChosenForSale.clear();
                    productRatesChosenForSale.clear();
                    productDescriptionsChosenForSale.clear();
                    productSizesChosenForSale.clear();
                    Navigator.pushReplacementNamed(context, LandingScreen().id);
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
