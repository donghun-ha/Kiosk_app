import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/model/global.dart';
import 'package:kiosk_app/view/customer_modify.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  late DatabaseHandler handler;
  late int countNum;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    countNum = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: handler.quaryCustomer(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.length; i++) {
              if (snapshot.data![i].id == checkId) {
                countNum = i;
                break;
              }
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data![countNum].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: OutlinedButton(
                        onPressed: () {
                          Get.to(() => const CustomerModify(), arguments: [
                            snapshot.data![countNum].name,
                            snapshot.data![countNum].phone,
                            snapshot.data![countNum].id,
                            snapshot.data![countNum].password
                          ])!
                              .then((value) => reloadData());
                        },
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(
                                color: Color.fromARGB(255, 190, 190, 190))),
                        child: const Text(
                          '프로필 수정',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Row(
                      children: [
                        Text(
                          'ID',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Row(
                      children: [
                        Text(
                          snapshot.data![countNum].id,
                          style:
                              const TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Row(
                      children: [
                        Text(
                          '휴대폰 번호',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Row(
                      children: [
                        Text(
                          snapshot.data![countNum].phone,
                          style:
                              const TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  reloadData() {
    setState(() {});
  }
}
