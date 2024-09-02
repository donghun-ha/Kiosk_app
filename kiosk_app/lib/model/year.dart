class Year {
  int year;
  int totalSales;
  final List<int> mothlySales;
  final Map<String, int> brandSales;

  Year(
      {required this.year,
      required this.totalSales,
      required this.mothlySales,
      required this.brandSales});
}
