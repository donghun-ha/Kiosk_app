import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/view/login.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              height: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SHOE',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 70,
                    color: Colors.black,
                    child: const Text(
                      'MARKET',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 200, 0, 100),
              child: Text(
                '“Step into Style with [SHOE MARKET]. \n Discover the latest trends and \n exclusive offers just for you. \n Your perfect pair is only a tap away—welcome \n to a new world of fashion and comfort!”',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            // splash page info
            ElevatedButton(
              onPressed: () => Get.to(const Login()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: const Size(350, 50),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
