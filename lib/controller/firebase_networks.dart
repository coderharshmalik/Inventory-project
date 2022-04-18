import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:inventory_v1/screens/landing_screen.dart';
import 'package:inventory_v1/widgets/toast.dart';

final _fireStore = FirebaseFirestore.instance;
List<DropdownMenuItem<String>> sizeListFromFireStore = [];
List<Map<String, String>> productsListFromFireStore = [];
String finalProductDocumentId;
String finalSalesDocumentId;
String finalNewProductId;
String finalNewBillNumber;
String todayDate;
String todayMonth;
String todayYear;
List<Map<String, dynamic>> allProductsList = [];
List<String> allSoldProductsList = [];
var sizeFromFireStore;

Future getSizesFromFireBase() async {
  try {
    sizeFromFireStore =
        await _fireStore.collection("productSizes").doc("sizes").get();
  } catch (e) {
    print(e);
    print('Error in Getting Sizes from Firebase');
  }
}

Future generateDocumentID() async {
  List<DocumentSnapshot> documents;
  List<String> productDocumentIdList = [];
  int lastAddedProductDocumentId;
  int newProductDocumentId;

  var documentsFromFireStore = await _fireStore.collection("products").get();

  if (documentsFromFireStore != null) {
    documents = documentsFromFireStore.docs;
    if (documents.isNotEmpty) {
      documents.forEach((data) {
        productDocumentIdList.add(data.id);
      });
      productDocumentIdList.sort();
      lastAddedProductDocumentId =
          int.parse(productDocumentIdList.last.substring(7));
      newProductDocumentId = lastAddedProductDocumentId + 1;

      finalProductDocumentId =
          'Product${newProductDocumentId.toString().padLeft(10, '0')}';
    } else {
      finalProductDocumentId = 'Product0000000001';
    }
  }

  print(finalProductDocumentId);
}

Future generateSalesDocumentID() async {
  List<DocumentSnapshot> documents;
  List<String> salesDocumentIdList = [];
  int lastAddedSalesDocumentId;
  int newSalesDocumentId;

  var documentsFromFireStore = await _fireStore.collection("sales").get();

  if (documentsFromFireStore != null) {
    documents = documentsFromFireStore.docs;
    if (documents.isNotEmpty) {
      documents.forEach((data) {
        salesDocumentIdList.add(data.id);
      });
      salesDocumentIdList.sort();
      lastAddedSalesDocumentId =
          int.parse(salesDocumentIdList.last.substring(5));
      newSalesDocumentId = lastAddedSalesDocumentId + 1;

      finalSalesDocumentId =
          'Sales${newSalesDocumentId.toString().padLeft(10, '0')}';
    } else {
      finalSalesDocumentId = 'Sales0000000001';
    }
  }

  print(finalSalesDocumentId);
}

Future generateBillNumber() async {
  List<String> billNumberFromFireStore = [];
  DateTime dateUnformatted = DateTime.now();
  DateFormat dateFormatted = DateFormat('dd-MMM-yy');
  String fullDateNeeded = dateFormatted.format(dateUnformatted);

  var documentsFromFireStore = await _fireStore.collection("sales").get();

  if (documentsFromFireStore != null) {
    List<DocumentSnapshot> salesList = documentsFromFireStore.docs;

    if (salesList.isNotEmpty) {
      salesList.forEach(
        (receivedRecords) {
          billNumberFromFireStore.add(receivedRecords.get('BillNumber'));
        },
      );

      billNumberFromFireStore.sort();

      String lastAddedBillNumber = billNumberFromFireStore.last;
      String lastAddedBillNumberDigitsOnly = lastAddedBillNumber.substring(4);
      int lastAddedBillNumberDigitsOnlyInt =
          int.parse(lastAddedBillNumberDigitsOnly);
      int newProductIdInt = lastAddedBillNumberDigitsOnlyInt + 1;

      finalNewBillNumber = 'LMNS${newProductIdInt.toString().padLeft(10, '0')}';
    } else {
      finalNewBillNumber = 'LMNS0000000001';
    }
    print(finalNewBillNumber);
  }
}

Future addSoldProductsRecord(
    String products,
    String productRates,
    String productDescriptions,
    String productSizes,
    String totalPrice,
    String quantity) async {
  DateTime dateUnformatted = DateTime.now();
  DateFormat dateFormatted = DateFormat('dd MMM yy');
  String fullDateNeeded = dateFormatted.format(dateUnformatted);

  var splitDate = fullDateNeeded.split(' ');
  todayDate = splitDate[0];
  todayMonth = splitDate[1];
  todayYear = splitDate[2];

  if (products.isNotEmpty && productRates.isNotEmpty) {
    await _fireStore.collection('sales').doc(finalSalesDocumentId).set(
      {
        'BillNumber': finalNewBillNumber,
        'SoldProducts': products,
        'SoldProductRates': productRates,
        'SoldProductDescription': productDescriptions,
        'SoldProductSizes': productSizes,
        'NoOfProductsSold': quantity,
        'TotalPrice': totalPrice,
        'SoldDate': todayDate,
        'SoldMonth': todayMonth,
        'SoldYear': todayYear,
        'Timestamp': dateUnformatted,
      },
    );
  }
}

Future getSoldOutProductsFromFireBase() async {
  List<String> soldProductsList = [];
  List<String> noOfProductsSold = [];
  List<String> interimList = [];
  var documentsFromFireStore = await _fireStore.collection("sales").get();

  if (documentsFromFireStore != null) {
    List<DocumentSnapshot> documentList = documentsFromFireStore.docs;

    if (documentList.isNotEmpty) {
      documentList.forEach(
        (receivedRecords) {
          noOfProductsSold.add(receivedRecords.get('NoOfProductsSold'));
          soldProductsList.add(receivedRecords.get('SoldProducts'));
        },
      );
    }

    for (int i = 0; i < noOfProductsSold.length; i++) {
      if (int.parse(noOfProductsSold[i]) == 1) {
        allSoldProductsList.add(soldProductsList[i]);
      } else {
        interimList.clear();
        interimList = soldProductsList[i].split(regexForSoldProducts);
        for (String prods in interimList) {
          allSoldProductsList.add(prods);
        }
        interimList.clear();
      }
    }
  }
}

Future generateProductID() async {
  List<String> productIdFromFireStore = [];
  DateTime dateUnformatted = DateTime.now();
  DateFormat dateFormatted = DateFormat('dd MMM yy');
  String fullDateNeeded = dateFormatted.format(dateUnformatted);

  var splitDate = fullDateNeeded.split(' ');
  todayDate = splitDate[0];
  todayMonth = splitDate[1];
  todayYear = splitDate[2];

  var documentsWithDateFilterFromFireStore = await _fireStore
      .collection("products")
      .where(
        "ProductAddMonth",
        isEqualTo: todayMonth,
      )
      .where(
        'ProductAddYear',
        isEqualTo: todayYear,
      )
      .get();
  if (documentsWithDateFilterFromFireStore != null) {
    List<DocumentSnapshot> dateFilteredList =
        documentsWithDateFilterFromFireStore.docs;

    if (dateFilteredList.isNotEmpty) {
      dateFilteredList.forEach((receivedRecords) {
        productIdFromFireStore.add(receivedRecords.get('ProductId'));
      });

      productIdFromFireStore.sort();
      String lastAddedProductId = productIdFromFireStore.last;
      String lastAddedProductIdNumbersOnly = lastAddedProductId.substring(6);
      int lastAddedProductIdNumbersOnlyInt =
          int.parse(lastAddedProductIdNumbersOnly);
      int newProductIdInt = lastAddedProductIdNumbersOnlyInt + 1;
      finalNewProductId = todayMonth.toUpperCase() +
          todayYear +
          '-' +
          newProductIdInt.toString().padLeft(5, '0');
    } else {
      finalNewProductId = todayMonth.toUpperCase() + todayYear + '-00001';
    }

    await getSoldOutProductsFromFireBase();

    while (allSoldProductsList.contains(finalNewProductId)) {
      String lastDigitsOfNewProdId = finalNewProductId.substring(6);
      int lastDigitsOfNewProdIdInt = int.parse(lastDigitsOfNewProdId) + 1;
      finalNewProductId = finalNewProductId.substring(0, 6) +
          lastDigitsOfNewProdIdInt.toString().padLeft(5, '0');
    }
    allSoldProductsList.clear();
    print(finalNewProductId);
  }
}

Future generateProductListForSale() async {
  productsListFromFireStore.clear();
  var documentsFromFireStore = await _fireStore.collection("products").get();

  if (documentsFromFireStore != null) {
    List<DocumentSnapshot> snapshotList = documentsFromFireStore.docs;

    if (snapshotList.isNotEmpty) {
      snapshotList.forEach(
        (receivedRecords) {
          productsListFromFireStore.add(
            {
              'ProductID': receivedRecords.get('ProductId'),
              'ProductDesc': receivedRecords.get('ProductDescription'),
              'Size': receivedRecords.get('Size'),
              'Rate': receivedRecords.get('Rate'),
            },
          );
        },
      );
    }
  }
}

Future addProduct(BuildContext context, String productId, String productDesc,
    String size, String rate) async {
  try {
    if (productDesc.isNotEmpty && (int.parse(rate) != 0)) {
      await _fireStore.collection('products').doc(finalProductDocumentId).set(
        {
          'ProductId': productId,
          'ProductDescription': productDesc,
          'Size': size,
          'Rate': rate,
          'ProductAddDate': todayDate,
          'ProductAddMonth': todayMonth,
          'ProductAddYear': todayYear,
          'Timestamp': DateTime.now(),
        },
      );
      ShowingToast(context: context)
          .showSuccessToast("Product " + productId + " added Successfully");
      Navigator.pop(context);
    } else {
      if (productDesc.isEmpty) {
        ShowingToast(context: context).showFailureToast(
          "Description can\'t be empty",
        );
      } else if (int.parse(rate) == 0) {
        ShowingToast(context: context).showFailureToast(
          "Rate can\'t be 0",
        );
      }
    }
  } catch (e) {
    ShowingToast(context: context).showFailureToast(
      "Error occurred while adding product",
    );
  }
}

Future getAllProductsDetails() async {
  var documentWithAllProductDetails =
      await _fireStore.collection('products').get();
  List<DocumentSnapshot> allProductsListFromFireStore =
      documentWithAllProductDetails.docs;
  if (allProductsListFromFireStore.isNotEmpty) {
    allProductsListFromFireStore.forEach((element) {
      allProductsList.add({
        'ProductId': element.get('ProductId'),
        'ProductDescription': element.get('ProductDescription'),
        'Size': element.get('Size'),
        'Rate': element.get('Rate'),
        'ProductAddDate': element.get('ProductAddDate'),
        'ProductAddMonth': element.get('ProductAddMonth'),
        'ProductAddYear': element.get('ProductAddYear'),
        'Timestamp': element.get('Timestamp'),
      });
    });
    // print('Getting products details');
    // allProductsList.forEach((element) {
    //   print(element);
    // });
  }
}

Future updateProductWithProductID(
  BuildContext context,
  String productId,
  String productDesc,
  String size,
  String rate,
  String addDate,
  String addMonth,
  String addYear,
) async {
  try {
    if (productDesc.isNotEmpty && rate.isNotEmpty && (int.parse(rate) != 0)) {
      await _fireStore
          .collection('products')
          .where(
            "ProductId",
            isEqualTo: productId,
          )
          .get()
          .then(
            (value) => value.docs.forEach(
              (element) async {
                String docId = element.id;
                await _fireStore.collection('products').doc(docId).set(
                  {
                    'ProductId': productId,
                    'ProductDescription': productDesc,
                    'Size': size,
                    'Rate': rate,
                    'ProductAddDate': addDate,
                    'ProductAddMonth': addMonth,
                    'ProductAddYear': addYear,
                    'Timestamp': DateTime.now(),
                  },
                );
                ShowingToast(context: context).showSuccessToast(
                    "Product " + productId + " updated Successfully");
                Navigator.pop(context);
              },
            ),
          );
    } else {
      if (productDesc.isEmpty) {
        ShowingToast(context: context).showFailureToast(
          'Description is Mandatory',
        );
      } else if (rate.isEmpty) {
        ShowingToast(context: context).showFailureToast(
          'Rate is Mandatory',
        );
      } else if (int.parse(rate) == 0) {
        ShowingToast(context: context).showFailureToast(
          'Rate can\'t be 0',
        );
      }
    }
  } catch (e) {
    ShowingToast(context: context).showFailureToast(
      'Error in updating product ' + productId,
    );
  }
}

Stream<QuerySnapshot<Map<String, dynamic>>> getFireStoreInstanceStream() {
  var stream;
  try {
    stream = _fireStore.collection('products').snapshots();
  } catch (e) {
    print('Error in getting Firestore Stream');
    stream = null;
  }
  return stream;
}

deleteProductFromFireStoreWithProductId(String productId) async {
  try {
    await _fireStore
        .collection('products')
        .where(
          "ProductId",
          isEqualTo: productId,
        )
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) async {
              String docId = element.id;
              await _fireStore.collection('products').doc(docId).delete();
            },
          ),
        );
  } catch (e) {
    print('Error in deletion of Product');
  }
}
