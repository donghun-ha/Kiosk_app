import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CoSales extends StatefulWidget {
  const CoSales({super.key});

  @override
  State<CoSales> createState() => _CoSalesState();
}

class _CoSalesState extends State<CoSales> {
  int _selectedIndex = 0; // int로 변경

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 60,
          width: 100,
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
          child: CupertinoSlidingSegmentedControl<int>(
            children: const {
              0: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text(
                  '월별 매출 현황',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              1: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text(
                  '브랜드 매출 현황',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            },
            onValueChanged: (int? value) {
              setState(() {
                _selectedIndex = value ?? 0; // 선택된 인덱스 업데이트
              });
            },
            groupValue: _selectedIndex, // 현재 선택된 인덱스를 지정
          ),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: Divider(
              color: Colors.grey,
              thickness: 1, // thickness를 1로 설정
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  _selectedIndex == 0 ? '월별 총 매출 :' : '브랜드 매출 현황 :',
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
            thickness: 1, // thickness를 1로 설정
          ),
          Expanded(
            child: _showChart(), //
          ),
        ],
      ),
    );
  }

  Widget _showChart() {
    // 선택된 인덱스에 따라 다른 차트를 반환
    switch (_selectedIndex) {
      case 1:
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 6,
            titlesData: const FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            barGroups: [
              BarChartGroupData(
                  x: 0, barRods: [BarChartRodData(toY: 3, color: Colors.blue)]),
              BarChartGroupData(
                  x: 1, barRods: [BarChartRodData(toY: 1, color: Colors.blue)]),
              BarChartGroupData(
                  x: 2, barRods: [BarChartRodData(toY: 4, color: Colors.blue)]),
            ],
          ),
        );
      case 0:
      default:
        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 1),
                  const FlSpot(1, 3),
                  const FlSpot(2, 2),
                  const FlSpot(3, 4),
                  const FlSpot(4, 3),
                ],
                isCurved: true,
                color: Colors.blue,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            titlesData: const FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            gridData: const FlGridData(show: true),
          ),
        );
    }
  }
}
