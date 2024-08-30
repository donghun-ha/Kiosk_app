import 'package:flutter/material.dart';

class CustomerPayment extends StatefulWidget {
  const CustomerPayment({super.key});

  @override
  State<CustomerPayment> createState() => _CustomerPaymentState();
}

class _CustomerPaymentState extends State<CustomerPayment> {
  late List<String> shoeName;
  late List<String>shoePrice;
  late List<String>shoeImage;
  late List<Color> buttonColor;
  late Color firstButtonColor;
  late Color secondButtonColor;
  late int count;

  @override
  void initState() {
    super.initState();
    shoeName = ['나이키 에어'];
    shoePrice = ['100000'];
    shoeImage = ['사진'];
    count = 1;
    buttonColor = [
      Color(0xff6644AB),
      Color.fromARGB(255, 186, 167, 225)
    ];
    firstButtonColor = Color(0xff6644AB);
    secondButtonColor = Color.fromARGB(255, 186, 167, 225);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: const Text(
            'Report',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 40
            ),
            ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 89,
              height: 28,
              child: ElevatedButton(
                onPressed: () {
                  firstchangeColor();
                  //
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: firstButtonColor,
                ),
                child: const Text(
                  'Weekly',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                  ),
                  )
                ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
              width: 94,
              height: 28,
              child: ElevatedButton(
                onPressed: () {
                  secondchangeColor();
                  //
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondButtonColor,
                ),
                child: const Text(
                  'Monthly',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                  ),
                  )
                ),
                        ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 360,
              height: 550,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: shoeName.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Text('${shoeImage[index]}')
                            ),
                            decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xffE4E4E4),
                                    ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 10, 0),
                          child: Column(
                            children: [
                              Text('${shoeName[index]}'),
                              Text('${shoePrice[index]}'),
                              Text('수량 : $count'), 
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                'Total : ${shoePrice[0]}',
                style: TextStyle(
                  color: Color(0xffDCB21C),
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
                ),
            )
          ],
        ),
      ),
    );
  }
  firstchangeColor(){
    firstButtonColor = Color(0xff6644AB);
    secondButtonColor = Color.fromARGB(255, 186, 167, 225);
    setState(() {});
  }

  secondchangeColor(){
    firstButtonColor = Color.fromARGB(255, 186, 167, 225);
    secondButtonColor = Color(0xff6644AB);
    setState(() {});
  }
}