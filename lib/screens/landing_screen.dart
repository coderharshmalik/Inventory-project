import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_v1/widgets/landing_page_report_widget.dart';
import 'package:inventory_v1/widgets/reusable_card.dart';
import 'package:inventory_v1/constants.dart';
import 'total_asset_screen.dart';
import 'add_products_screen.dart';
import 'sales_screen.dart';
import 'package:inventory_v1/widgets/icon_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:inventory_v1/controller/firebase_networks.dart';
import 'package:inventory_v1/widgets/sizes_dropdown.dart';

final _fireauth = FirebaseAuth.instance;
List<String> productsChosenForSale = [];
List<String> productRatesChosenForSale = [];
List<String> productDescriptionsChosenForSale = [];
List<String> productSizesChosenForSale = [];
String regexForSoldProducts = ' ##<-->##<++>## ';

class LandingScreen extends StatefulWidget {
  final String id = '/landingScreen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool showLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showLoading,
      opacity: 0.1,
      progressIndicator: CircularProgressIndicator(
        color: Colors.white,
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Mangal\'s Inventory',
              ),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () async {
                    showDialog(
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
                                    'Are you sure you wish to exit?',
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 20.0, bottom: 20.0),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(32.0),
                                            ),
                                          ),
                                          child: Text(
                                            'CANCEL',
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() => showLoading = true);
                                          await _fireauth.signOut();
                                          setState(() => showLoading = false);
                                          SystemNavigator.pop();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 20.0, bottom: 20.0),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(32.0)),
                                          ),
                                          child: Text(
                                            'EXIT',
                                            style:
                                                TextStyle(color: Colors.white),
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.logout_sharp,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ReuseableCard(
                          colour: kCardColor,
                          cardChild: LandingPageReportWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() => showLoading = true);
                                  await generateSalesDocumentID();
                                  await generateBillNumber();
                                  setState(() => showLoading = false);
                                  Navigator.pushNamed(
                                    context,
                                    SalesScreen().id,
                                  );
                                },
                                child: ReuseableCard(
                                  colour: kCardColor,
                                  cardChild: IconContent(
                                    iconData: FontAwesomeIcons.rupeeSign,
                                    text: 'SALE',
                                  ), //Update
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  allProductsList = [];
                                  setState(() => showLoading = true);
                                  await getAllProductsDetails();
                                  await getSizesDropdown(
                                      kViewProductSizesStyle);
                                  setState(() => showLoading = false);
                                  Navigator.pushNamed(
                                    context,
                                    '/viewProductsScreen',
                                  );
                                },
                                child: ReuseableCard(
                                  colour: kCardColor,
                                  cardChild: IconContent(
                                    iconData: FontAwesomeIcons.search,
                                    text: 'VIEW',
                                  ), //Search
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() => showLoading = true);
                                  await generateDocumentID();
                                  await generateProductID();
                                  await getSizesDropdown(kAddProductSizesStyle);
                                  setState(() => showLoading = false);

                                  showModalBottomSheet(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.0),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: AddProductsScreen(),
                                      ),
                                    ),
                                  );
                                },
                                child: ReuseableCard(
                                  colour: kCardColor,
                                  cardChild: IconContent(
                                    iconData: FontAwesomeIcons.plus,
                                    text: 'ADD',
                                  ), //Add
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
