import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiosk_app/model/brand.dart';
import 'package:kiosk_app/model/year.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class CoSales extends StatefulWidget {
  const CoSales({super.key});

  @override
  State<CoSales> createState() => _CoSalesState();
}

class _CoSalesState extends State<CoSales> {
  int _selectedIndex = 0;
  int _selectedYearIndex = 0;
  late List<Brand> brandData;
  late List<Year> yearData;
  late TooltipBehavior tooltipBehavior;

  @override
  void initState() {
    super.initState();
    brandData = [];
    yearData = [];
    addData();
    addyearData();
    tooltipBehavior = TooltipBehavior(enable: true);
  }

  Widget _buildYearDropdown() {
    return DropdownButton<int>(
      value: _selectedYearIndex,
      items: List.generate(yearData.length, (index) {
        return DropdownMenuItem<int>(
          value: index,
          child: Text(yearData[index].year.toString()),
        );
      }),
      onChanged: (int? newIndex) {
        setState(() {
          _selectedYearIndex = newIndex ?? 0;
        });
      },
    );
  }

  void addData() {
    brandData.add(Brand(brand: 'Puma', quantity: 230, colors: Colors.red));
    brandData
        .add(Brand(brand: 'NewBalance', quantity: 440, colors: Colors.blue));
    brandData.add(Brand(brand: 'Adidas', quantity: 650, colors: Colors.green));
    brandData.add(Brand(brand: 'Vans', quantity: 645, colors: Colors.orange));
    brandData.add(Brand(brand: 'Nike', quantity: 885, colors: Colors.purple));
    brandData.add(Brand(brand: 'Prospecs', quantity: 320, colors: Colors.cyan));
  }

  void addyearData() {
    yearData.add(Year(
      year: 2020,
      totalSales: 200000000,
      mothlySales: [
        18000000,
        20000000,
        15000000,
        17000000,
        16000000,
        14000000,
        22000000,
        21000000,
        20000000,
        24000000,
        19000000,
        20000000
      ],
      brandSales: {
        'Puma': 150,
        'NewBalance': 220,
        'Adidas': 300,
        'Vans': 280,
        'Nike': 350,
        'Prospecs': 100
      },
    ));
    yearData.add(Year(
      year: 2021,
      totalSales: 154000000,
      mothlySales: [
        15000000,
        14000000,
        13000000,
        16000000,
        15000000,
        14000000,
        13000000,
        12000000,
        15000000,
        16000000,
        17000000,
        18000000
      ],
      brandSales: {
        'Puma': 140,
        'NewBalance': 210,
        'Adidas': 290,
        'Vans': 270,
        'Nike': 340,
        'Prospecs': 110
      },
    ));
    yearData.add(Year(
      year: 2022,
      totalSales: 400000000,
      mothlySales: [
        35000000,
        30000000,
        32000000,
        38000000,
        40000000,
        41000000,
        39000000,
        43000000,
        45000000,
        46000000,
        47000000,
        50000000
      ],
      brandSales: {
        'Puma': 200,
        'NewBalance': 270,
        'Adidas': 350,
        'Vans': 330,
        'Nike': 400,
        'Prospecs': 150
      },
    ));
    yearData.add(Year(
      year: 2023,
      totalSales: 330000000,
      mothlySales: [
        25000000,
        27000000,
        30000000,
        32000000,
        34000000,
        36000000,
        33000000,
        37000000,
        35000000,
        38000000,
        40000000,
        45000000
      ],
      brandSales: {
        'Puma': 180,
        'NewBalance': 240,
        'Adidas': 310,
        'Vans': 320,
        'Nike': 370,
        'Prospecs': 160
      },
    ));
    yearData.add(Year(
      year: 2024,
      totalSales: 620000000,
      mothlySales: [
        52000000,
        53000000,
        54000000,
        55000000,
        56000000,
        57000000,
        58000000,
        59000000,
        60000000,
        61000000,
        62000000,
        63000000
      ],
      brandSales: {
        'Puma': 250,
        'NewBalance': 300,
        'Adidas': 400,
        'Vans': 360,
        'Nike': 450,
        'Prospecs': 180
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 60,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff9FDFBD),
          ),
          child: const Center(
            child: Text(
              '매출현황',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CupertinoSlidingSegmentedControl<int>(
              children: const {
                0: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Text(
                    '연도별 총 매출 현황',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                1: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Text(
                    '연도별 브랜드 매출 현황',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              },
              onValueChanged: (int? value) {
                setState(() {
                  _selectedIndex = value ?? 0;
                });
              },
              groupValue: _selectedIndex,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildYearDropdown(),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  _selectedIndex == 0
                      ? '연도별 총 매출 현황 : ${formatSales(yearData[_selectedYearIndex].totalSales)}'
                      : '연도별 브랜드 매출 현황 :',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Expanded(
            child: showChart(),
          ),
        ],
      ),
    );
  }

  Widget showChart() {
    switch (_selectedIndex) {
      case 1:
        return Center(
          child: SizedBox(
            width: 450,
            height: 600,
            child: SfCartesianChart(
              title: ChartTitle(
                  text: "${yearData[_selectedYearIndex].year} 연도별 브랜드 판매 현황"),
              tooltipBehavior: tooltipBehavior,
              series: [
                ColumnSeries<MapEntry<String, int>, String>(
                  name: '판매량',
                  dataSource:
                      yearData[_selectedYearIndex].brandSales.entries.toList(),
                  xValueMapper: (MapEntry<String, int> entry, _) => entry.key,
                  yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
                  pointColorMapper: (MapEntry<String, int> entry, _) {
                    // Find color for the brand if needed
                    return brandData
                        .firstWhere((b) => b.brand == entry.key)
                        .colors;
                  },
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                ),
              ],
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: '브랜드'),
                labelRotation: 45,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                maximumLabels: 6,
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: '판매량'),
                minimum: 0,
              ),
            ),
          ),
        );
      case 0:
      default:
        return Center(
          child: SizedBox(
            width: 450,
            height: 600,
            child: SfCartesianChart(
              title: ChartTitle(
                  text: "${yearData[_selectedYearIndex].year}년 월별 매출"),
              tooltipBehavior: tooltipBehavior,
              series: [
                LineSeries<int, String>(
                  color: Theme.of(context).colorScheme.primary,
                  name: '매출',
                  dataSource: yearData[_selectedYearIndex].mothlySales,
                  xValueMapper: (int sales, int index) => "${index + 1}월",
                  yValueMapper: (int sales, _) => sales,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                ),
              ],
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: '월'),
              ),
              primaryYAxis: NumericAxis(
                title: const AxisTitle(text: '매출'),
                minimum: 0,
                numberFormat: NumberFormat.compact(),
              ),
            ),
          ),
        );
    }
  }

  // --- Functions ---
  String formatSales(int sales) {
    // NumberFormat 클래스 사용하여 한국어 스타일로 숫자를 간략하게 포맷
    return NumberFormat.compactCurrency(
      locale: "ko_KR",
      symbol: "", // "원" 같은 통화 기호를 생략
    ).format(sales);
  }
}// End