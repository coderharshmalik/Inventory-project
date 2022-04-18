import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_v1/constants.dart';
import 'package:inventory_v1/screens/landing_screen.dart';
import 'package:inventory_v1/screens/list_products_for_sale_screen.dart';
import 'package:inventory_v1/screens/sales_screen.dart';
import 'package:inventory_v1/widgets/products_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_v1/controller/firebase_networks.dart';
import 'package:inventory_v1/screens/product_details_screen.dart';
import 'package:inventory_v1/widgets/toast.dart';

List<Map<String, dynamic>> sizesHorizontalList;
Map<String, dynamic> mapOfList;

class ViewProductsScreen extends StatefulWidget {
  final String id = '/viewProductsScreen';
  @override
  _ViewProductsScreenState createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  @override
  void initState() {
    super.initState();
    getSizesList();
  }

  String tempVal = '';
  String sizeFilterSelection = '';

  int previouslySelectedSizeIndex;
  int productsListedBelow = 0;
  TextEditingController searchController = new TextEditingController();

  onSearching(String value) {
    tempVal = value;
    setState(() {});
  }

  getSizesList() {
    if (sizeFromFireStore != null) {
      sizesHorizontalList = [];
      mapOfList = {};
      for (String sizeForList in sizeFromFireStore.data().values) {
        mapOfList = {
          'size': sizeForList,
          'color': Colors.white54,
        };
        sizesHorizontalList.add(mapOfList);
      }
      print(sizesHorizontalList);
    } else {
      print('Error');
    }
    // return sizesHorizontalList;
  }

  @override
  Widget build(BuildContext context) {
    searchController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: searchController.text.length,
      ),
    );
    return SafeArea(
      child: Scaffold(
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
          title: Text('View Products'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Showing ${productsListedBelow != null ? productsListedBelow : 0} products',
              ),
              StreamBuilder<QuerySnapshot>(
                stream: getFireStoreInstanceStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('Loading...'),
                    );
                  }
                  final productsFromFireStore = snapshot.data.docs;
                  List<Dismissible> productCardWidgets = [];
                  productsListedBelow = 0;
                  for (var product in productsFromFireStore) {
                    final productId = product.get('ProductId');
                    final productDesc = product.get('ProductDescription');
                    final productAddDate = product.get('ProductAddDate');
                    final productAddMonth = product.get('ProductAddMonth');
                    final productAddYear = product.get('ProductAddYear');
                    final size = product.get('Size');
                    final rate = product.get('Rate');
                    final timestamp = product.get('Timestamp');

                    if (productId
                            .toString()
                            .toLowerCase()
                            .contains(tempVal.toLowerCase()) ||
                        productDesc
                            .toString()
                            .toLowerCase()
                            .contains(tempVal.toLowerCase()) ||
                        size.toString().toLowerCase().trim() ==
                            tempVal.toLowerCase().trim()) {
                      productsListedBelow += 1;
                      final productCardWidget = Dismissible(
                        confirmDismiss: (direction) async {
                          switch (direction) {
                            case DismissDirection.endToStart:
                              {
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
                                      contentPadding:
                                          EdgeInsets.only(top: 10.0),
                                      content: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Text(
                                                'Are you sure you wish to delete $productId Product?',
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
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 20.0,
                                                          bottom: 20.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  32.0),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'CANCEL',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 20.0,
                                                          bottom: 20.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        32.0)),
                                                      ),
                                                      child: Text(
                                                        'DELETE',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
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
                              break;
                            case DismissDirection.startToEnd:
                              {
                                await generateSalesDocumentID();
                                await generateBillNumber();
                                finalList.clear();
                                productsChosenForSale.clear();
                                productDescriptionsChosenForSale.clear();
                                productRatesChosenForSale.clear();
                                productSizesChosenForSale.clear();
                                Route route = MaterialPageRoute(
                                  builder: (context) => SalesScreen(
                                    productId: productId,
                                    productDesc: productDesc,
                                    size: size,
                                    rate: rate,
                                  ),
                                );
                                Navigator.pushReplacement(context, route);
                              }
                              break;
                          }
                          return false;
                        },
                        secondaryBackground: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'DELETE',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Icon(
                              Icons.delete_forever,
                              size: 35,
                            ),
                          ],
                        ),
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: 23,
                            ),
                            Text(
                              'SELL',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        key: Key(product.id),
                        onDismissed: (direction) async {
                          await deleteProductFromFireStoreWithProductId(
                              productId);
                          ShowingToast(context: context).showSuccessToast(
                              "Product " + productId + " deleted Successfully");
                        },
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          child: ProductsCard(
                            productId: productId,
                            productDesc: productDesc,
                            productAddDate: productAddDate,
                            productAddMonth: productAddMonth,
                            productAddYear: productAddYear,
                            size: size,
                            rate: rate,
                          ),
                          onTap: () {
                            Route route = MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                productId: productId,
                                productDesc: productDesc,
                                productAddDate: productAddDate,
                                productAddMonth: productAddMonth,
                                productAddYear: productAddYear,
                                size: size,
                                rate: rate,
                              ),
                            );
                            Navigator.push(context, route);
                          },
                        ),
                      );
                      productCardWidgets.add(productCardWidget);
                    }
                  }
                  return Expanded(
                    child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: productCardWidgets,
                    ),
                  );
                },
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: sizesHorizontalList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        searchController.clear();
                        if (previouslySelectedSizeIndex == null) {
                          previouslySelectedSizeIndex = index;
                        }

                        sizeFilterSelection =
                            sizesHorizontalList[index]['size'];

                        setState(() {
                          if ((sizesHorizontalList[index]['color'] ==
                                  Colors.white54) &&
                              previouslySelectedSizeIndex != index) {
                            sizesHorizontalList[previouslySelectedSizeIndex]
                                ['color'] = Colors.white54;
                            sizesHorizontalList[index]['color'] = Colors.white;
                            onSearching(sizeFilterSelection);
                          } else if ((sizesHorizontalList[index]['color'] ==
                                  Colors.white54) &&
                              previouslySelectedSizeIndex == index) {
                            sizesHorizontalList[index]['color'] = Colors.white;
                            onSearching(sizeFilterSelection);
                          } else {
                            sizesHorizontalList[index]['color'] =
                                Colors.white54;
                            onSearching('');
                          }
                        });
                        previouslySelectedSizeIndex = index;
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: sizesHorizontalList[index]['color'],
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              sizesHorizontalList[index]['size'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        onTap: () {
                          onSearching('');
                          sizesHorizontalList.forEach((element) {
                            element.forEach((key, value) {
                              if (key == 'color' && value == Colors.white) {
                                element.update(
                                    'color', (value) => Colors.white54);
                                print(sizesHorizontalList);
                                setState(() {});
                              }
                            });
                          });
                        },
                        controller: searchController,
                        onChanged: (value) {
                          onSearching(value);
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration:
                            kViewProductsSearchProductTextFieldDecoration,
                      ),
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
