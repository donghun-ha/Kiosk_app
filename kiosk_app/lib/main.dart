import 'package:flutter/material.dart';
import 'package:kiosk_app/view/local_main.dart';
import 'package:kiosk_app/view/local_order.dart';
import 'package:kiosk_app/view/local_order_detail.dart';
import 'package:kiosk_app/view/local_profile.dart';
import 'package:kiosk_app/view/local_modify.dart';
import 'package:kiosk_app/view/local_password.dart';
import 'package:kiosk_app/view/local_invent.dart';
import 'package:kiosk_app/view/local_invent_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiosk App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LocalMainPage(),
        '/local_order': (context) => LocalOrderPage(),
        '/local_order_detail': (context) => LocalOrderDetailPage(
              orderId: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/local_profile': (context) => LocalProfilePage(),
        '/local_modify': (context) => LocalModifyPage(),
        '/local_password': (context) => LocalPasswordPage(),
        '/local_invent': (context) => LocalInventPage(),
        '/local_invent_detail': (context) => LocalInventDetailPage(
              productName: ModalRoute.of(context)!.settings.arguments as String,
            ),
      },
    );
  }
}
