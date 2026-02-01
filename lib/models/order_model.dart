import 'package:kgl_express/core/enums/payment_method.dart';
import 'package:kgl_express/models/package_model.dart';
import 'package:kgl_express/core/enums/order_status.dart';

// 1. The "Contract" - Anything that implements this can be shown in the Live Feed
abstract class LiveActivity {
  String get activityId;
  String get mainTitle;
}

class DeliveryOrder {
  final String id;
  final List<PackageItem> items;
  final String destinationPhone;
  final bool receiverPays;
  final OrderStatus status;

  DeliveryOrder({
    required this.id,
    required this.items,
    required this.destinationPhone,
    this.receiverPays = false,
    this.status = OrderStatus.pending,
  });

  int get totalVehicleCount => items.map((i) => i.compatibilityGroup).toSet().length;
}

class OrderItem {
  final String name;
  final int quantity;
  final String description;

  OrderItem({required this.name, required this.quantity, required this.description});
}

// 2. Updated OrderModel to support the Live Feed
class OrderModel implements LiveActivity {
  final String id;
  final String title;
  final String pickupLocation;
  final String destination;
  final double price;
  final OrderStatus status;
  final String recipientPhone;
  final String pickupNotes;
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

  // Interface overrides
  @override
  String get activityId => id;
  @override
  String get mainTitle => title;
}

// 3. New Model for Bus (For the Factory example)
class BusTicketModel implements LiveActivity {
  @override
  final String activityId;
  final String from;
  final String to;
  final String seat;
  final String operator;
  final String carPlate;      // e.g., RAC 123 A
  final String passengerName; // Name of the person holding this ticket
  final PaymentMethod paymentMethod;
  final String? operatorLogo; // URL or Asset path
  final bool isActive;

  BusTicketModel({
    required this.activityId,
    required this.from,
    required this.to,
    this.seat = "ANY",
    required this.operator,
    required this.carPlate,
    required this.passengerName,
    required this.paymentMethod,
    this.operatorLogo,
    this.isActive = true,

  });

  @override
  String get mainTitle => "$operator Bus";
}
