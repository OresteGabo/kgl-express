import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/provider_type.dart';
import 'package:kgl_express/core/enums/order_status.dart';
import 'package:kgl_express/core/enums/payment_method.dart';
import 'package:kgl_express/features/sender/presentation/provider_profile_screen.dart';
import 'package:kgl_express/features/sender/presentation/service_selection_screen.dart';
import 'package:kgl_express/models/order_model.dart';

final List<Object> mockOrders = [
  // 1. A Bus Ticket (Inter-city)
  BusTicketModel(
    activityId: "TKT-882",
    from: "Nyabugogo",
    to: "Huye Main Station",
    seat: "A12",
    operator: "Volcano Express",
    carPlate: 'RAC 456T',
    passengerName: 'ORESTE MUHIRWA GABO',
    paymentMethod: PaymentMethod.tapAndGo,
  ),

  // 2. An In-Transit Delivery
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
      OrderItem(name: "Red Roses Bouquet", quantity: 1, description: "Fresh cut"),
    ],
    paymentMethod: PaymentMethod.cash,
  ),

  // 3. Another Bus Ticket
  BusTicketModel(
    activityId: "TKT-104",
    from: "Nyabugogo",
    to: "Musanze",
    seat: "B04",
    operator: "Horizon Express",
    carPlate: 'RAC 421B',
    passengerName: 'NDAYISENGA JEAN FRANÇOIS REGIS',
    paymentMethod: PaymentMethod.momo,
  ),

  // 4. A Grocery Order
  OrderModel(
    id: "kgl003",
    title: "Grocery Restock",
    pickupLocation: "Simba Supermarket",
    destination: "Kimihurura",
    price: 1200,
    status: OrderStatus.inTransit,
    recipientPhone: "+250 781 000 999",
    pickupNotes: "Ask for Order #99.",
    items: [
      OrderItem(name: "Milk 1L", quantity: 4, description: "Inyange Full Cream"),
    ],
    paymentMethod: PaymentMethod.airtel,
  ),

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
List<OrderModel> getOrderModels(){
  List<OrderModel> orderModels = [];
  for (var element in mockOrders) {
    if(element is OrderModel){
      orderModels.add(element);
    }
  }
  return orderModels;
}

// Mock database of registered users in Rwanda
const Map<String, String> mockRegisteredUsers = {
  "+250780000001": "Muhire Oreste",
  "+250788123456": "Uwase Aline",
  "+250791234567": "Gasana Jean Bosco",
  "+250722000000": "Niyonsenga Eric",
};

final activeActivities = mockOrders.where((item) {
  if (item is OrderModel) {
    // Only show if it's actually moving
    return item.status == OrderStatus.inTransit || item.status == OrderStatus.pending;
  }
  if (item is BusTicketModel) {
    // Only show if the trip hasn't happened yet
    return item.isActive;
  }
  return false;
}).toList();


final List<RwandaService> rwandaServices = [
  RwandaService(name: "Mechanic", icon: Icons.settings),
  RwandaService(name: "Electrician", icon: Icons.bolt),
  RwandaService(name: "Plumber", icon: Icons.plumbing),
  RwandaService(name: "House Cleaning", icon: Icons.cleaning_services),
  RwandaService(name: "Carpenter", icon: Icons.handyman),
  RwandaService(name: "Painter", icon: Icons.format_paint),
  RwandaService(name: "Masonry", icon: Icons.foundation),
  RwandaService(name: "Welding", icon: Icons.precision_manufacturing),
  RwandaService(name: "Tiling", icon: Icons.grid_view),
  RwandaService(name: "Landscaping", icon: Icons.landscape),
];




// Full List for the Listing Pages
final List<ServiceProvider> allDummyProviders = [
  ServiceProvider(
    name: "Alice Umutoni",
    specialty: Speciality.electrician,
    location: "Nyamirambo, Kigali",
    rating: 4.8,
    jobsCompleted: 89,
    phoneNumber: "+250781111111",
    bio: "Certified technician for domestic wiring, solar panel installation, and smart home setup.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.airtel, PaymentMethod.spenn],
  ),
  ServiceProvider(
    name: "Jean turatsinze",
    specialty: Speciality.mechanic,
    location: "Kimironko, Kigali",
    rating: 4.9,
    jobsCompleted: 124,
    phoneNumber: "+250780000000",
    bio: "Over 10 years of experience in European and Japanese car brands. Specializing in engine diagnostics and suspension.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.bkPay, PaymentMethod.cash],
  ),
  ServiceProvider(
    name: "Emmanuel K.",
    specialty: Speciality.plumber,
    location: "Kibagabaga, Kigali",
    rating: 4.7,
    jobsCompleted: 210,
    phoneNumber: "+250782222222",
    bio: "Emergency leak repairs and bathroom installations. Fast and reliable service across Kigali.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.cash],
  ),
  ServiceProvider(
    name: "Grace M.",
    specialty: Speciality.houseCleaning,
    location: "Kacyiru, Kigali",
    rating: 4.9,
    jobsCompleted: 340,
    phoneNumber: "+250783333333",
    bio: "Deep cleaning services for homes and offices. I bring my own high-quality cleaning supplies.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.card],
  ),
  ServiceProvider(
    name: "Fabrice N.",
    specialty: Speciality.carpenter,
    location: "Gikondo, Kigali",
    rating: 4.6,
    jobsCompleted: 56,
    phoneNumber: "+250784444444",
    bio: "Custom furniture maker and cabinet installer. I specialize in modern Rwandan wood designs.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.bkPay, PaymentMethod.cash],
  ),
  ServiceProvider(
    name: "Divine I.",
    specialty: Speciality.painter,
    location: "Rebero, Kigali",
    rating: 4.8,
    jobsCompleted: 42,
    phoneNumber: "+250785555555",
    bio: "Interior and exterior painting. Expert in decorative finishes and wall textures.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.airtel],
  ),
  ServiceProvider(
    name: "Safi L.",
    specialty: Speciality.laundry,
    location: "Remera, Kigali",
    rating: 4.7,
    jobsCompleted: 156,
    phoneNumber: "+250786666666",
    bio: "Wash, dry, and iron services with home pickup and delivery available.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.cash],
  ),
  ServiceProvider(
    name: "Patrick O.",
    specialty: Speciality.acRepair,
    location: "Nyarutarama, Kigali",
    rating: 4.5,
    jobsCompleted: 78,
    phoneNumber: "+250787777777",
    bio: "Maintenance and repair for all split and central AC units. Certified HVAC technician.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.bkPay, PaymentMethod.card],
  ),
  ServiceProvider(
    name: "Charité gorki",
    specialty: Speciality.masonry,
    location: "Masaka, Kigali",
    rating: 4.8,
    jobsCompleted: 450,
    phoneNumber: "+250782223240",
    bio: "Specialist in bricklaying, foundation work, and fence construction. I manage a team of 5 skilled workers for larger projects.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.bkPay, PaymentMethod.cash],
  ),
  ServiceProvider(
    name: "Blaise W.",
    specialty: Speciality.welder,
    location: "Gatsata, Kigali",
    rating: 4.7,
    jobsCompleted: 132,
    phoneNumber: "+250788000002",
    bio: "Custom gate fabrication, window grills, and steel roof trusses. Quality welding with anti-rust finishing.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.airtel, PaymentMethod.cash],
  ),
  ServiceProvider(
    name: "Solange U.",
    specialty: Speciality.tiler,
    location: "Busanza, Kigali",
    rating: 4.9,
    jobsCompleted: 75,
    phoneNumber: "+250788000003",
    bio: "Expert in ceramic, porcelain, and granite tile installation for bathrooms, kitchens, and living rooms.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.spenn, PaymentMethod.bkPay],
  ),
  ServiceProvider(
    name: "Innocent Z.",
    specialty: Speciality.landscaper,
    location: "Kigali Heights Area",
    rating: 4.6,
    jobsCompleted: 112,
    phoneNumber: "+250788000004",
    bio: "Compound design, grass planting, and cabro (paving block) installation. Making your home exterior beautiful.",
    acceptedPayments: [PaymentMethod.momo, PaymentMethod.cash],
  ),
  ServiceProvider(
    name: "KGL Builders Construction specializing Ltd",
    specialty: Speciality.masonry,
    location: "Nyarutarama",
    rating: 4.9,
    jobsCompleted: 500,
    phoneNumber: "+250780123456",
    bio: "Full-service construction firm specializing in residential houses.",
    acceptedPayments: [PaymentMethod.bkPay, PaymentMethod.card, PaymentMethod.momo],
    type: ProviderType.company, // <--- Marked as Company
  ),
  ServiceProvider(
    name: "Byiringiro jonathan",
    specialty: Speciality.deliverer,
    location: "Nyarutarama",
    rating: 4.9,
    jobsCompleted: 500,
    phoneNumber: "+250780626533",
    bio: "MOTAR.",
    acceptedPayments: [PaymentMethod.bkPay, PaymentMethod.card, PaymentMethod.momo],
    type: ProviderType.individual,
  )
];

final randomElement = allDummyProviders[Random().nextInt(allDummyProviders.length)];
final index = allDummyProviders.indexOf(randomElement);
