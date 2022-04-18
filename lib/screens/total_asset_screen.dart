import 'package:flutter/material.dart';
import 'package:inventory_v1/constants.dart';
import 'package:inventory_v1/controller/firebase_networks.dart';

class TotalAssetScreen extends StatefulWidget {
  @override
  _TotalAssetScreenState createState() => _TotalAssetScreenState();
}

class _TotalAssetScreenState extends State<TotalAssetScreen> {
  double totalAssetValue = 0.00;

  void totalAssetRate() async {
    try {
      await for (var snapshot in getFireStoreInstanceStream()) {
        for (var docs in snapshot.docChanges) {
          totalAssetValue = totalAssetValue + docs.doc.get('Rate');
          setState(() {
            print('$totalAssetValue');
          });
        }
      }
    } catch (e) {
      print(e);
      print('Error in calculating total assets rate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total Asset worth',
                style: kFunctionTextStyle,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'INR ' + totalAssetValue.toString(),
                style: kAssetAmountTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
