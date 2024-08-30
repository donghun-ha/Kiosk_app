import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/model/product.dart';
import 'package:kiosk_app/view/insert_product.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CoProduct extends StatefulWidget {
  const CoProduct({super.key});

  @override
  State<CoProduct> createState() => _CoProductState();
}

class _CoProductState extends State<CoProduct> {
  late TextEditingController searchController;
  DatabaseHandler handler = DatabaseHandler();
  String? _selectedItem;
  var _searchQuery = '';
  late Future<List<Product>> _searchResults;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _selectedItem = '전체 검색';
    _searchResults = handler.queryProductByName(_searchQuery);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = searchController.text; // 검색어 상태 업데이트
      _searchResults =
          handler.queryProductByName(_searchQuery); // 검색 결과 다시 가져오기
    });
  }

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
              '제품관리',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(const InsertProduct()),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => _onSearchChanged(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: DropdownButton<String>(
                  value: _selectedItem, // 기본 선택된 값
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem = newValue;
                      _onSearchChanged(); // 검색 기준 변경 시 재검색
                    });
                  },
                  items: <String>['전체 검색', '제품명', '브랜드'] // 드롭다운 항목
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  underline: Container(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ),
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _searchResults, // 검색 결과를 반영하도록 수정
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No products available.'),
                  );
                } else {
                  if (kDebugMode) {
                    print('Snapshot Data: ${snapshot.data}');
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 4,
                          color: const Color(0xffE7EDD1),
                          child: SizedBox(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          '제품명: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 85,
                                          child: Text(
                                            snapshot.data![index].name,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: IconButton(
                                            onPressed: () async {
                                              bool confirmDelete =
                                                  await Get.dialog(
                                                AlertDialog(
                                                  title: const Text('삭제 확인'),
                                                  content: const Text(
                                                      '정말 삭제하시겠습니까?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back(
                                                            result:
                                                                false); // 취소 버튼을 누르면 false 반환
                                                      },
                                                      child: const Text('취소'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back(
                                                            result:
                                                                true); // 삭제 버튼을 누르면 true 반환
                                                      },
                                                      child: const Text('삭제'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirmDelete == true) {
                                                // 사용자가 삭제를 확인한 경우
                                                Product product = Product(
                                                  id: snapshot.data![index].id,
                                                  name: snapshot
                                                      .data![index].name,
                                                  size: snapshot
                                                      .data![index].size,
                                                  color: snapshot
                                                      .data![index].color,
                                                  stock: snapshot
                                                      .data![index].stock,
                                                  price: snapshot
                                                      .data![index].price,
                                                  brand: snapshot
                                                      .data![index].brand,
                                                  image: snapshot
                                                      .data![index].image,
                                                );
                                                await handler
                                                    .deletProduct(product);
                                                _onSearchChanged(); // 삭제 후 검색 결과 업데이트
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.delete_forever_outlined,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image.memory(
                                      snapshot.data![index].image,
                                      width: 120,
                                      height: 100,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '     판매가 \n ${snapshot.data![index].price}원',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '     사이즈 \n      ${snapshot.data![index].size}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '     재고량 \n     ${snapshot.data![index].stock}EA',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Future<List<Product>>>(
        '_searchResults', _searchResults));
  }

  // --- functions ---

  _showAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제 확인'),
        content: const Text('정말 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}// End
