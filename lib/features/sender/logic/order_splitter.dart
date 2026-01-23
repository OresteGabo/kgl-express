
import 'package:kgl_express/models/package_model.dart';

class OrderSplitter {
  static List<List<PackageItem>> splitItems(List<PackageItem> allItems) {
    // Map uses CompatibilityGroup enum as the key
    final Map<CompatibilityGroup, List<PackageItem>> groupedTrips = {};

    for (var item in allItems) {
      groupedTrips.putIfAbsent(item.compatibilityGroup, () => []);
      groupedTrips[item.compatibilityGroup]!.add(item);
    }

    return groupedTrips.values.toList();
  }
}