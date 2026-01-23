import 'package:kgl_express/core/enums/payment_method.dart';
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

class OrderItem {
  final String name;
  final int quantity;
  final String description;

  OrderItem({required this.name, required this.quantity, required this.description});
}

class OrderModel {
  final String id;
  final String title;
  final String pickupLocation;
  final String destination;
  final double price;
  final OrderStatus status;
  final String recipientPhone;
  final String pickupNotes; // e.g., "ID Required"
  final PaymentMethod paymentMethod;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.title,
    required this.pickupLocation,
    required this.destination,
    required this.price,
    required this.status,
    required this.recipientPhone,
    required this.pickupNotes,
    required this.paymentMethod,
    required this.items,
  });
}