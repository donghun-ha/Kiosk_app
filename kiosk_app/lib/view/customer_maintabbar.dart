import 'package:flutter/material.dart';
import 'package:kiosk_app/view/customer_cart.dart';
import 'package:kiosk_app/view/customer_main.dart';
import 'package:kiosk_app/view/customer_payment.dart';
import 'package:kiosk_app/view/customer_profile.dart';

class CustomerMaintabbar extends StatefulWidget {
  const CustomerMaintabbar({super.key});

  @override
  State<CustomerMaintabbar> createState() => _CustomerMaintabbarState();
}

class _CustomerMaintabbarState extends State<CustomerMaintabbar> with SingleTickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          CustomerMain(),
          CustomerCart(),
          CustomerPayment(),
          CustomerProfile()
        ]
        ),
        bottomNavigationBar: Container(
          height: 70,
          child: TabBar(
            labelColor: Color.fromARGB(255, 117, 121, 132),
              indicatorColor: Color.fromARGB(255, 117, 121, 132),
              indicatorWeight: 2,
              controller: tabController,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.shopping_cart),
                ),
                Tab(
                  icon: Icon(Icons.receipt_long),
                ),
                Tab(
                  icon: Icon(Icons.person),
                ),
              ],
            ),
        )
    );
  }
}