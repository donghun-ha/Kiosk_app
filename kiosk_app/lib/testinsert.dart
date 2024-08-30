import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiosk_app/model/product.dart';

import 'vm/database_handler.dart';

class Testinsert extends StatefulWidget {
  const Testinsert({super.key});

  @override
  State<Testinsert> createState() => _TestinsertState();
}

class _TestinsertState extends State<Testinsert> {
  // Property
  late DatabaseHandler handler;
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController sizeController;
  late TextEditingController colorController;
  late TextEditingController relationController;
  late TextEditingController stockController;
  late TextEditingController priceController;
  late TextEditingController brandController;
  //Image Picker
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    idController = TextEditingController();
    nameController = TextEditingController();
    sizeController = TextEditingController();
    colorController = TextEditingController();
    stockController = TextEditingController();
    priceController = TextEditingController();
    brandController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주소록 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: '신발ID를 입력 하세요',
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '신발이름을 입력 하세요',
                  ),
                ),
                TextField(
                  controller: sizeController,
                  decoration: const InputDecoration(
                    labelText: '사이즈를 입력 하세요',
                  ),
                ),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(
                    labelText: '컬러를 입력 하세요',
                  ),
                ),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: '재고를 입력 하세요',
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: '가격을 입력 하세요',
                  ),
                ),
                TextField(
                  controller: brandController,
                  decoration: const InputDecoration(
                    labelText: '브랜드를 입력 하세요',
                  ),
                ),
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
        ),
      ),
    );
  }


  // ---Function---
  // 외부의 갤러리 이기 때문에 async를 써준다.
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

    var productInsert = Product(
      id: idController.text.trim(),
      name: nameController.text.trim(),
      size: int.parse(sizeController.text.trim()),
      color: colorController.text.trim(),
      stock: int.parse(stockController.text.trim()),
      price: int.parse(priceController.text.trim()),
      brand: brandController.text.trim(),
      image: getImage
      );
      int result = await handler.insertproduct(productInsert);
      if(result != 0){
        _showDialog();
      }
    }
  _showDialog(){
        Get.defaultDialog(
          title: '입력 결과',
          middleText: '입력이 완료되었습니다.',
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          barrierDismissible: false,
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text('OK')
              )
          ]
        );
      }
} // End