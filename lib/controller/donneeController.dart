import 'package:africars/model/Indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class donneeController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeData();
  }

}

class homeData extends State<donneeController>{
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  int touchedIndex;
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);




  bool showAvg = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }
  @override
  Widget build(BuildContext context) {
    const cutOffYValue = 5.0;
    const dateTextStyle =
    TextStyle(fontSize: 10, color: Colors.purple, fontWeight: FontWeight.bold);
    // TODO: implement build
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.70,
                child: Container(

                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      color: Color(0xff232d37)),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: LineChart(
                      showAvg ? avgData() : mainData(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 34,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },

                ),
              ),
              AspectRatio(
                aspectRatio: 1.3,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                                pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                  setState(() {
                                    if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                        pieTouchResponse.touchInput is FlPanEnd) {
                                      touchedIndex = -1;
                                    } else {
                                      touchedIndex = pieTouchResponse.touchedSectionIndex;
                                    }
                                  });
                                }),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                sections: showingSections()),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Indicator(
                            color: Color(0xff0293ee),
                            text: 'Boutique 1',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Color(0xfff8b250),
                            text: 'Boutique 2',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Color(0xff845bef),
                            text: 'Boutique 3',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Color(0xff13d38e),
                            text: 'Boutique 4',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              'Ventes',
                              style: TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            const SizedBox(
                              width: 4,
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              BarChartData(
                                maxY: 20,
                                barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: Colors.grey,
                                      getTooltipItem: (_a, _b, _c, _d) => null,
                                    ),
                                    touchCallback: (response) {
                                      if (response.spot == null) {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                          showingBarGroups = List.of(rawBarGroups);
                                        });
                                        return;
                                      }

                                      touchedGroupIndex = response.spot.touchedBarGroupIndex;

                                      setState(() {
                                        if (response.touchInput is FlLongPressEnd ||
                                            response.touchInput is FlPanEnd) {
                                          touchedGroupIndex = -1;
                                          showingBarGroups = List.of(rawBarGroups);
                                        } else {
                                          showingBarGroups = List.of(rawBarGroups);
                                          if (touchedGroupIndex != -1) {
                                            double sum = 0;
                                            for (BarChartRodData rod
                                            in showingBarGroups[touchedGroupIndex].barRods) {
                                              sum += rod.y;
                                            }
                                            final avg =
                                                sum / showingBarGroups[touchedGroupIndex].barRods.length;

                                            showingBarGroups[touchedGroupIndex] =
                                                showingBarGroups[touchedGroupIndex].copyWith(
                                                  barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                                    return rod.copyWith(y: avg);
                                                  }).toList(),
                                                );
                                          }
                                        }
                                      });
                                    }),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    textStyle: TextStyle(
                                        color: const Color(0xff7589a2),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    margin: 20,
                                    getTitles: (double value) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return 'Mn';
                                        case 1:
                                          return 'Te';
                                        case 2:
                                          return 'Wd';
                                        case 3:
                                          return 'Tu';
                                        case 4:
                                          return 'Fr';
                                        case 5:
                                          return 'St';
                                        case 6:
                                          return 'Sn';
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    textStyle: TextStyle(
                                        color: const Color(0xff7589a2),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    margin: 32,
                                    reservedSize: 14,
                                    getTitles: (value) {
                                      if (value == 0) {
                                        return '1K';
                                      } else if (value == 10) {
                                        return '5K';
                                      } else if (value == 19) {
                                        return '10K';
                                      } else {
                                        return '';
                                      }
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroups,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1.66,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.center,
                        barTouchData: BarTouchData(
                          enabled: false,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            textStyle: const TextStyle(color: Color(0xff939393), fontSize: 10),
                            margin: 10,
                            getTitles: (double value) {
                              switch (value.toInt()) {
                                case 0:
                                  return 'Apr';
                                case 1:
                                  return 'May';
                                case 2:
                                  return 'Jun';
                                case 3:
                                  return 'Jul';
                                case 4:
                                  return 'Aug';
                                default:
                                  return '';
                              }
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            textStyle: const TextStyle(
                                color: Color(
                                  0xff939393,
                                ),
                                fontSize: 10),
                            margin: 0,
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          checkToShowHorizontalLine: (value) => value % 10 == 0,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: const Color(0xffe7e8ec),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        groupsSpace: 4,
                        barGroups: getData(),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                width: 300,
                height: 140,
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 4),
                          FlSpot(1, 3.5),
                          FlSpot(2, 4.5),
                          FlSpot(3, 1),
                          FlSpot(4, 4),
                          FlSpot(5, 6),
                          FlSpot(6, 6.5),
                          FlSpot(7, 6),
                          FlSpot(8, 4),
                          FlSpot(9, 6),
                          FlSpot(10, 6),
                          FlSpot(11, 7),
                        ],
                        isCurved: true,
                        barWidth: 8,
                        colors: [
                          Colors.black,
                        ],
                        belowBarData: BarAreaData(
                          show: true,
                          colors: [Colors.green],
                          cutOffY: cutOffYValue,
                          applyCutOffY: true,
                        ),
                        aboveBarData: BarAreaData(
                          show: true,
                          colors: [Colors.red],
                          cutOffY: cutOffYValue,
                          applyCutOffY: true,
                        ),
                        dotData: FlDotData(
                          show: false,
                        ),
                      ),
                    ],
                    minY: 0,
                    titlesData: FlTitlesData(
                      bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 14,
                          textStyle: dateTextStyle,
                          getTitles: (value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Jan';
                              case 1:
                                return 'Feb';
                              case 2:
                                return 'Mar';
                              case 3:
                                return 'Apr';
                              case 4:
                                return 'May';
                              case 5:
                                return 'Jun';
                              case 6:
                                return 'Jul';
                              case 7:
                                return 'Aug';
                              case 8:
                                return 'Sep';
                              case 9:
                                return 'Oct';
                              case 10:
                                return 'Nov';
                              case 11:
                                return 'Dec';
                              default:
                                return '';
                            }
                          }),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTitles: (value) {
                          return '\$ ${value + 0.5}';
                        },
                      ),
                    ),
                    axisTitleData: FlAxisTitleData(
                        leftTitle: AxisTitle(showTitle: true, titleText: 'Value', margin: 4),
                        bottomTitle: AxisTitle(
                            showTitle: true,
                            margin: 0,
                            titleText: '2019',
                            textStyle: dateTextStyle,
                            textAlign: TextAlign.right)),
                    gridData: FlGridData(
                      show: true,
                      checkToShowHorizontalLine: (double value) {
                        return value == 1 || value == 6 || value == 4 || value == 5;
                      },
                    ),
                  ),
                ),
              ),





            ],
          ),

        )
    );
  }




  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 17000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 2000000000, dark),
                BarChartRodStackItem(2000000000, 12000000000, normal),
                BarChartRodStackItem(12000000000, 17000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 24000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 13000000000, dark),
                BarChartRodStackItem(13000000000, 14000000000, normal),
                BarChartRodStackItem(14000000000, 24000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 23000000000.5,
              rodStackItem: [
                BarChartRodStackItem(0, 6000000000.5, dark),
                BarChartRodStackItem(6000000000.5, 18000000000, normal),
                BarChartRodStackItem(18000000000, 23000000000.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 29000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 9000000000, dark),
                BarChartRodStackItem(9000000000, 15000000000, normal),
                BarChartRodStackItem(15000000000, 29000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 32000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 2000000000.5, dark),
                BarChartRodStackItem(2000000000.5, 17000000000.5, normal),
                BarChartRodStackItem(17000000000.5, 32000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 31000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 11000000000, dark),
                BarChartRodStackItem(11000000000, 18000000000, normal),
                BarChartRodStackItem(18000000000, 31000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 35000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 14000000000, dark),
                BarChartRodStackItem(14000000000, 27000000000, normal),
                BarChartRodStackItem(27000000000, 35000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 31000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 8000000000, dark),
                BarChartRodStackItem(8000000000, 24000000000, normal),
                BarChartRodStackItem(24000000000, 31000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 15000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 6000000000.5, dark),
                BarChartRodStackItem(6000000000.5, 12000000000.5, normal),
                BarChartRodStackItem(12000000000.5, 15000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 17000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 9000000000, dark),
                BarChartRodStackItem(9000000000, 15000000000, normal),
                BarChartRodStackItem(15000000000, 17000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 34000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 6000000000, dark),
                BarChartRodStackItem(6000000000, 23000000000, normal),
                BarChartRodStackItem(23000000000, 34000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 32000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 7000000000, dark),
                BarChartRodStackItem(7000000000, 24000000000, normal),
                BarChartRodStackItem(24000000000, 32000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 14000000000.5,
              rodStackItem: [
                BarChartRodStackItem(0, 1000000000.5, dark),
                BarChartRodStackItem(1000000000.5, 12000000000, normal),
                BarChartRodStackItem(12000000000, 14000000000.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 20000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 4000000000, dark),
                BarChartRodStackItem(4000000000, 15000000000, normal),
                BarChartRodStackItem(15000000000, 20000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 24000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 4000000000, dark),
                BarChartRodStackItem(4000000000, 15000000000, normal),
                BarChartRodStackItem(15000000000, 24000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 14000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 1000000000.5, dark),
                BarChartRodStackItem(1000000000.5, 12000000000, normal),
                BarChartRodStackItem(12000000000, 14000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 27000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 7000000000, dark),
                BarChartRodStackItem(7000000000, 25000000000, normal),
                BarChartRodStackItem(25000000000, 27000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 29000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 6000000000, dark),
                BarChartRodStackItem(6000000000, 23000000000, normal),
                BarChartRodStackItem(23000000000, 29000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 16000000000.5,
              rodStackItem: [
                BarChartRodStackItem(0, 9000000000, dark),
                BarChartRodStackItem(9000000000, 15000000000, normal),
                BarChartRodStackItem(15000000000, 16000000000.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 15000000000,
              rodStackItem: [
                BarChartRodStackItem(0, 7000000000, dark),
                BarChartRodStackItem(7000000000, 12000000000.5, normal),
                BarChartRodStackItem(12000000000.5, 15000000000, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
    ];
  }






  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        y: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }





  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }





  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle:
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle:
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

}