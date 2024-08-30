import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:kiosk_app/view/local_invent_detail.dart';

class LocalInventPage extends StatefulWidget {
  const LocalInventPage({super.key});

  @override
  _LocalInventPageState createState() => _LocalInventPageState();
}

class _LocalInventPageState extends State<LocalInventPage> {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  String _searchType = '제품명';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _databaseHandler.getProductsSummary();
      print('Loaded products: $products'); // 디버깅을 위한 출력
      setState(() {
        _products = products;
        _filteredProducts = _products; // 초기에 모든 제품을 표시
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterProducts(String query) {
    query = query.trim();
    if (query.isEmpty) {
      setState(() => _filteredProducts = _products);
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filtered = _products.where((product) {
      final searchField = _searchType == '제품명' ? 'name' : 'brand';
      final fieldValue = product[searchField]?.toString().toLowerCase() ?? '';
      return fieldValue.contains(lowercaseQuery);
    }).toList();

    setState(() => _filteredProducts = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: Text('상품 재고'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/local_profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: '$_searchType 검색',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      _filterProducts(value.trim());
                    },
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    setState(() {
                      _searchType = value;
                      _filterProducts(_searchController.text);
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: '제품명',
                      child: Text('제품명'),
                    ),
                    const PopupMenuItem<String>(
                      value: '브랜드',
                      child: Text('브랜드'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? Center(child: Text('검색 결과가 없습니다'))
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 5,
                        ),
                        padding: EdgeInsets.all(35),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LocalInventDetailPage(
                                    productName: product['name'].toString(),
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: FutureBuilder<Uint8List?>(
                                      future: _databaseHandler.getProductImage(
                                          product['id'].toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.data != null) {
                                          return Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          );
                                        } else {
                                          return Center(
                                              child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 50));
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'] ?? 'No name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '브랜드: ${product['brand'] ?? 'N/A'}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                            '총 재고: ${product['total_stock'] ?? 'N/A'}'),
                                        Text(
                                            '평균 가격: ${_formatPrice(product['avg_price'])}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    if (price is num) {
      return '${price.toStringAsFixed(2)}원';
    }
    if (price is String) {
      try {
        return '${double.parse(price).toStringAsFixed(2)}원';
      } catch (e) {
        return '${price}원';
      }
    }
    return '${price}원';
  }
}
