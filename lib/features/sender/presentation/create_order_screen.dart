import 'package:flutter/material.dart';
import 'package:kgl_express/core/constants/mock_data.dart';
import 'package:kgl_express/core/presentation/ui_factory/platform_ui.dart';
import 'package:kgl_express/core/presentation/widgets/location_connector.dart';
import 'package:kgl_express/core/services/contact_service.dart';
import 'package:kgl_express/core/utils/string_utils.dart';
import 'package:kgl_express/features/sender/presentation/widgets/package_item_tile.dart';
import 'package:kgl_express/models/package_model.dart';
import 'package:kgl_express/core/presentation/widgets/SectionHeader.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final _recipientController = TextEditingController();

  // Manage dynamic controllers for package names
  final List<PackageItem> _items = [];
  final List<TextEditingController> _itemControllers = [];

  bool _isSavedInContacts = false;
  final List<String> _myLocalContacts = ["+250788123456", "+250780000001"];

  String _formattedPhone = "";
  String _confirmedName = "";
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    // Initialize with one default item and its controller
    _addNewItem();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _recipientController.dispose();
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handlePhoneInput(String value) {
    String input = value.replaceAll(RegExp(r'\D'), '');
    if (input.startsWith('07')) {
      _formattedPhone = '+250${input.substring(1)}';
    } else if (input.startsWith('7')) {
      _formattedPhone = '+250$input';
    } else if (input.startsWith('250')) {
      _formattedPhone = '+$input';
    } else {
      _formattedPhone = input;
    }

    if (_formattedPhone.length == 13) {
      setState(() {
        _isVerifying = true;
        _confirmedName = "";
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          final fullName = mockRegisteredUsers[_formattedPhone];
          if (fullName != null) {
            _isSavedInContacts = _myLocalContacts.contains(_formattedPhone);
            _confirmedName = _isSavedInContacts ? fullName : obfuscateName(fullName);
          } else {
            _confirmedName = "New Recipient";
          }
          _isVerifying = false;
        });
      });
    } else {
      setState(() {
        _confirmedName = "";
        _isVerifying = false;
      });
    }
  }

  PackageItem _createItem(CompatibilityGroup group, String name, {int qty = 1}) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    switch (group) {
      case CompatibilityGroup.hazardous:
        return ToxicPackage(id: id, name: name, quantity: qty);
      case CompatibilityGroup.fragile:
        return FragilePackage(id: id, name: name, quantity: qty);
      case CompatibilityGroup.safe:
      default:
        return FoodPackage(id: id, name: name, quantity: qty);
    }
  }

  void _addNewItem() {
    setState(() {
      _items.add(_createItem(CompatibilityGroup.safe, ""));
      _itemControllers.add(TextEditingController());
    });
  }

  void _removeItem(int index) {
    if (_items.length > 1) {
      setState(() {
        _items.removeAt(index);
        _itemControllers[index].dispose();
        _itemControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ui = AppUI.factory;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ui.buildAppBar(title: "Send New Item"),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const SectionHeader(title: "Delivery Details"),
            ui.buildInputField(controller: _pickupController, hint: "Pickup Location", icon: Icons.location_on),
            const LocationConnector(),
            ui.buildInputField(controller: _destinationController, hint: "Destination", icon: Icons.flag),

            const SizedBox(height: 40),
            const SectionHeader(title: "Package Items"),

            // Render dynamic items
            ..._items.asMap().entries.map((e) {
              final index = e.key;
              final currentItem = e.value;

              return PackageItemTile(
                index: index,
                item: currentItem,
                nameController: _itemControllers[index],

                // Fix for Final Name
                onNameChanged: (newName) {
                  _items[index] = _createItem(
                    currentItem.compatibilityGroup,
                    newName,
                    qty: currentItem.quantity,
                  );
                },

                onRemove: (idx) => _removeItem(idx),

                onGroupChanged: (group) {
                  setState(() {
                    _items[index] = _createItem(
                      group,
                      currentItem.name,
                      qty: currentItem.quantity,
                    );
                  });
                },

                // Fix for Final Quantity
                onQtyChanged: (idx, newQty) {
                  setState(() {
                    _items[idx] = _createItem(
                      currentItem.compatibilityGroup,
                      currentItem.name,
                      qty: newQty,
                    );
                  });
                },
              );
            }).toList(),

            ui.buildTextButton(
                onPressed: _addNewItem,
                label: "Add another item",
                icon: Icons.add
            ),

            const SizedBox(height: 40),
            const SectionHeader(title: "Recipient Information"),
            ui.buildVerifiedInputField(
              controller: _recipientController,
              isVerifying: _isVerifying,
              confirmedName: _confirmedName,
              isSavedInContacts: _isSavedInContacts,
              onChanged: _handlePhoneInput,
              onPickContact: _onContactPickerPressed,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildConfirmButton() {
    final ui = AppUI.factory;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5)
          )
        ],
      ),
      child: ui.buildButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            // Handle order logic
          }
        },
        child: const Text("Request Rider", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _onContactPickerPressed() async {
    // Call the service
    final String? pickedNumber = await ContactService.pickContactNumber();

    if (pickedNumber != null) {
      setState(() {
        // Update the controller (this makes the text appear in the field)
        _recipientController.text = pickedNumber;

        // Manually trigger your verification logic
        _handlePhoneInput(pickedNumber);
      });
    } else {
      // Optional: Show error only if they didn't just 'cancel' the picker
      // This is where 'context' is valid because we are in the State class
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No contact selected or permission denied")),
      );
    }
  }
}