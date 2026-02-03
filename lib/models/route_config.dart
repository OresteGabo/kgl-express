class RouteConfig {
  final String operatorName;
  final int? intervalMinutes;        // 30 for Huye, 60 for Rubavu
  final List<String>? fixedSchedules; // For specific departures
  final double price;

  RouteConfig({
    required this.operatorName,
    this.intervalMinutes,
    this.fixedSchedules,
    required this.price,
  });
}