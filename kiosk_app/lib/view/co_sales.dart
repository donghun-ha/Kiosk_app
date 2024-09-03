import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiosk_app/model/brand.dart';
import 'package:kiosk_app/model/year.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:kiosk_app/vm/database_handler.dart';

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

  final DatabaseHandler dbHandler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    brandData = [];
    yearData = [];
    addData();
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
        return _buildBrandSalesChart();
      case 0:
      default:
        return _buildMonthlySalesChart();
    }
  }

  Widget _buildBrandSalesChart() {
    final brandSales = yearData[_selectedYearIndex].brandSales;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: brandSales.values.reduce((a, b) => a > b ? a : b).toDouble(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      brandSales.keys.elementAt(value.toInt()),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: brandSales.entries.map((entry) {
            final index = brandSales.keys.toList().indexOf(entry.key);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  color:
                      brandData.firstWhere((b) => b.brand == entry.key).colors,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMonthlySalesChart() {
    final monthlySales = yearData[_selectedYearIndex].mothlySales;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(monthlySales.length, (index) {
                return FlSpot(index.toDouble(), monthlySales[index].toDouble());
              }),
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  return Text(NumberFormat.compact().format(value));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text("${(value + 1).toInt()}월");
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }

  String formatSales(int sales) {
    return NumberFormat.compactCurrency(
      locale: "ko_KR",
      symbol: "",
    ).format(sales);
  }
}
