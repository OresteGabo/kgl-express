import 'package:flutter/material.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer les données
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final _recipientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Send New Item",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delivery Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Fill in the information to find a rider.",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // --- Section Pick up ---
              _buildLocationField(
                label: "Pickup Location",
                hint: "Where should the rider go?",
                icon: Icons.location_on,
                color: Colors.green,
                controller: _pickupController,
              ),

              const Padding(
                padding: EdgeInsets.only(left: 37),
                child: SizedBox(
                  height: 30,
                  child: VerticalDivider(thickness: 1, color: Colors.grey),
                ),
              ),

              // --- Section Destination ---
              _buildLocationField(
                label: "Destination",
                hint: "Where is the package going?",
                icon: Icons.flag,
                color: Colors.redAccent,
                controller: _destinationController,
              ),

              const SizedBox(height: 40),

              // --- Recipient Info ---
              const Text("Recipient Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              TextFormField(
                controller: _recipientController,
                decoration: _inputDecoration("Recipient Name & Phone", Icons.person_outline),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 80), // Espace pour le bouton
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildLocationField({
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    required TextEditingController controller,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              TextFormField(
                controller: controller,
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.normal),
                ),
                validator: (v) => v!.isEmpty ? "Please enter a location" : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Logique de création ici
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Processing Order...")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text("Request Rider",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}