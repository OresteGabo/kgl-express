import 'package:kgl_express/models/package_model.dart';
import 'package:kgl_express/core/enums/order_status.dart';

class DeliveryOrder {
  final String id;
  final List<PackageItem> items;
  final String destinationPhone;
  final bool receiverPays;
  final OrderStatus status; // Using the Enum instead of a String

  DeliveryOrder({
    required this.id,
    required this.items,
    required this.destinationPhone,
    this.receiverPays = false,
    this.status = OrderStatus.pending, // Default value
  });

  // Example of why this is better for your "Unlimited Scalability"
  int get totalVehicleCount => items.map((i) => i.compatibilityGroup).toSet().length;
}