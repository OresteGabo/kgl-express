import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/core/enums/payment_method.dart';
import 'package:kgl_express/models/order_model.dart';

final List<OrderModel> mockOrders = [
  OrderModel(
    id: "kgl001",
    title: "Electronics Delivery",
    pickupLocation: "Kacyiru Sector",
    destination: "KG 201 St, Remera",
    price: 2500,
    status: OrderStatus.delivered,
    recipientPhone: "+250 788 111 222",
    pickupNotes: "Call upon arrival, ask for the security desk.",
    items: [
      OrderItem(
        name: "MacBook Pro 14\"",
        quantity: 1,
        description: "Space Gray, M2 Chip, Sealed Box",
      ),
      OrderItem(
        name: "USB-C Charger",
        quantity: 1,
        description: "96W Power Adapter with MagSafe 3 Cable",
      ),
      OrderItem(
        name: "Magic Mouse",
        quantity: 1,
        description: "Silver edition, wireless",
      ),
    ],
    paymentMethod: PaymentMethod.momo,
  ),
  OrderModel(
    id: "kgl002",
    title: "Anniversary Gift",
    pickupLocation: "Gisozi",
    destination: "Nyarutarama Rd, House 12",
    price: 4500,
    status: OrderStatus.inTransit,
    recipientPhone: "+250 788 333 444",
    pickupNotes: "ID Card required. Handle with extreme care (Fragile).",
    items: [
      OrderItem(
        name: "Red Roses Bouquet",
        quantity: 1,
        description: "Fresh cut, 12 stems with white ribbon",
      ),
      OrderItem(
        name: "Scented Candle",
        quantity: 2,
        description: "Lavender & Vanilla aroma, glass jar",
      ),
      OrderItem(
        name: "Greeting Card",
        quantity: 1,
        description: "Handwritten envelope, do not bend",
      ),
    ],
    paymentMethod: PaymentMethod.cash,
  ),
  OrderModel(
    id: "kgl003",
    title: "Grocery Restock",
    pickupLocation: "Simba Supermarket",
    destination: "Kimihurura",
    price: 1200,
    status: OrderStatus.inTransit,
    recipientPhone: "+250 781 000 999",
    pickupNotes: "Ask for Order #99 at the pickup counter.",
    items: [
      OrderItem(
        name: "Milk 1L",
        quantity: 4,
        description: "Inyange Full Cream, Tetra Pak",
      ),
      OrderItem(
        name: "Bread",
        quantity: 2,
        description: "Simba Fresh White Bread, Large",
      ),
      OrderItem(
        name: "Eggs (Tray)",
        quantity: 1,
        description: "Local Farm Fresh, 30-piece tray",
      ),
      OrderItem(
        name: "Cooking Oil 2L",
        quantity: 1,
        description: "Sunny Vegetable Oil, Plastic Bottle",
      ),
    ],
    paymentMethod: PaymentMethod.airtel,
  ),
];