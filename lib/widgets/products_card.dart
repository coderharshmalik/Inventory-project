import 'package:flutter/material.dart';
import 'package:inventory_v1/constants.dart';

class ProductsCard extends StatelessWidget {
  final String productId;
  final String productDesc;
  final String productAddDate;
  final String productAddMonth;
  final String productAddYear;
  final String size;
  final String rate;

  ProductsCard({
    this.productId,
    this.productDesc,
    this.productAddDate,
    this.productAddMonth,
    this.productAddYear,
    this.size,
    this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: kCardColor,
      // shadowColor: Colors.black,
      elevation: 6,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 12,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productId,
                  style: kViewProductProductIdTextStyle,
                ),
                Text(
                  '$productAddDate $productAddMonth\'$productAddYear',
                  style: kViewProductDateTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productDesc.length < 30
                      ? productDesc
                      : productDesc.substring(0, 27) + '...',
                  style: kViewProductProductDescTextStyle,
                ),
                Text(
                  size,
                  style: kViewProductSizeTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
