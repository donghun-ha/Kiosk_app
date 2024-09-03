import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiosk_app/model/customer.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class Testid extends StatefulWidget {
  const Testid({super.key});

  @override
  State<Testid> createState() => _TestidState();
}

class _TestidState extends State<Testid> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      getImageFromGallery(ImageSource.gallery);
                    },
                    child: const Text('Gallery')
                    ),
                ),
            Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Colors.grey,
                    child: Center(
                      child: imageFile == null
                      ? const Text('image is not selected')
                      : Image.file(File(imageFile!.path))
                      ,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        insertAction();
                      },
                      child: const Text('입력')
                      ),
                  )
          ],
        ),
      ),
    );
  }

  Future getImageFromGallery(ImageSource imageSource) async{
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if(pickedFile == null){
      return;
    }else {
      imageFile = XFile(pickedFile.path);
      setState(() {});
    }
  }

  Future insertAction()async{
    // File Type을 Byte Type으로 변환하기
    File imageFile1 = File(imageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();

    var customerInsert = Customer(
      id: 'bowwow67',
      name: '홍길동',
      phone: '휴대폰번호',
      password: 'qwer',
      image: getImage
      );
      await handler.insertCustomer(customerInsert);
    }
}