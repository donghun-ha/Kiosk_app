import 'package:flutter/material.dart';
import 'package:kiosk_app/model/product.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CoSales extends StatefulWidget {
  const CoSales({super.key});

  @override
  State<CoSales> createState() => _CoSalesState();
}

class _CoSalesState extends State<CoSales> {
  // Property
  late List<Product> pdata;
  DatabaseHandler handler = DatabaseHandler();
  late TooltipBehavior tooltipBehavior;

  @override
  void initState() {
    super.initState();
    tooltipBehavior = TooltipBehavior(enable: true);
    pdata = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '매출현황',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 380,
          height: 600,
          child: FutureBuilder<List<Product>>(
            future: handler.queryProduct(), // 상품 데이터를 가져오는 Future 메서드 호출
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // 로딩 중일 때 표시
              } else if (snapshot.hasError) {
                return Text('오류 발생: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('데이터가 없습니다.');
              } else {
                pdata = snapshot.data!; // 데이터가 존재할 경우에 pdata에 할당

                return SfCartesianChart(
                  title: const ChartTitle(text: "브랜드 별 매출 현황"),
                  tooltipBehavior: tooltipBehavior,
                  series: <ColumnSeries<Product, String>>[
                    ColumnSeries<Product, String>(
                      color: Theme.of(context).colorScheme.primary,
                      name: 'Brand',
                      dataSource: snapshot.data!,
                      xValueMapper: (Product product, _) => product.brand,
                      yValueMapper: (Product product, _) => product.price,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                    ),
                  ],
                  primaryXAxis: const CategoryAxis(
                    title: AxisTitle(text: '브랜드'),
                  ),
                  primaryYAxis: const NumericAxis(
                    title: AxisTitle(text: '매출 (원)'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
