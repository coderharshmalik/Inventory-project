import 'package:flutter/material.dart';
import 'package:inventory_v1/screens/report_screen.dart';
import 'package:marquee/marquee.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LandingPageReportWidget extends StatefulWidget {
  @override
  _LandingPageReportWidgetState createState() =>
      _LandingPageReportWidgetState();
}

class _LandingPageReportWidgetState extends State<LandingPageReportWidget> {
  List<ChartData> _chartData;
  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Products: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                '5000',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfCircularChart(
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: _chartData,
                        xValueMapper: (data, _) => data.productsIn,
                        yValueMapper: (data, _) => data.noOFProducts,
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: Color(0xFF8D8E98),
                indent: 8,
                endIndent: 8,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            // Text(
                            //   'Total Products:',
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 17,
                            //   ),
                            // ),
                            // Text(
                            //   '5000',
                            //   style: TextStyle(
                            //     fontSize: 17,
                            //   ),
                            // ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              color: Color.fromRGBO(75, 135, 185, 1),
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //     'Products in Inventory:'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 20,
                                  child: Marquee(
                                    text: 'Products in Inventory: ',
                                    blankSpace: 20.0,
                                    velocity: 20.0,
                                    pauseAfterRound: Duration(seconds: 3),
                                  ),
                                ),
                                Text('3000'),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              color: Color.fromRGBO(192, 108, 132, 1),
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Products Sold:'),
                                Text('2000'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            children: [
              // Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ReportScreen().id);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'View full report',
                    style: TextStyle(
                      color: Color(0xFF8D8E98),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

List<ChartData> getChartData() {
  final List<ChartData> chartData = [
    ChartData(
      productsIn: 'Inventory',
      noOFProducts: 24,
    ),
    ChartData(
      productsIn: 'Sold',
      noOFProducts: 10,
    ),
  ];
  return chartData;
}

class ChartData {
  final String productsIn;
  final int noOFProducts;
  ChartData({
    this.noOFProducts,
    this.productsIn,
  });
}
