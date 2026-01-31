import 'package:flutter/material.dart';
import 'package:kgl_express/core/presentation/ui_factory/ui_factory.dart';
import 'package:kgl_express/models/package_model.dart';

class AndroidFactory implements UIFactory {
  @override
  PreferredSizeWidget buildAppBar({required String title, Widget? leading}) {
    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: leading, // Corrected signature
    );
  }

  @override
  Widget buildButton({required Widget child, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 56),
      ),
      child: child,
    );
  }

  @override
  Widget buildInputField({required controller, required hint, icon, keyboardType, onChanged}) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget buildCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: buildCardDecoration(),
      child: child,
    );
  }

  @override
  BoxDecoration buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    );
  }

  @override
  Widget buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator(color: Colors.black));
  }

  @override
  Widget buildTextButton({required String label, required VoidCallback onPressed, IconData? icon}) {
    return icon != null
        ? TextButton.icon(onPressed: onPressed, icon: Icon(icon), label: Text(label))
        : TextButton(onPressed: onPressed, child: Text(label));
  }

  @override
  Widget buildPaymentMethodTile({
    required String title,
    required String assetPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(assetPath, width: 40),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            // Use a simple Radio here.
            // The RadioGroup should be wrapping ALL tiles in the Screen, not inside a single tile.
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) return Colors.black;
                return Colors.grey;
              }),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildVerifiedInputField({
    required TextEditingController controller,
    required bool isVerifying,
    required String? confirmedName,
    required bool isSavedInContacts,
    required Function(String) onChanged,
    VoidCallback? onPickContact,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: "Recipient Phone",
            prefixText: "+250 ",
            prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            prefixIcon: isVerifying
                ? const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2)),
            )
                : Icon(
              confirmedName != null ? Icons.verified : Icons.phone_android,
              color: confirmedName != null ? Colors.green : Colors.grey,
            ),
            // Contact Picker Icon on the right
            suffixIcon: IconButton(
              icon: const Icon(Icons.contact_page_outlined, color: Colors.blueAccent),
              onPressed: onPickContact,
              tooltip: "Pick from contacts",
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (confirmedName != null)
          buildNameBadge(name: confirmedName, isSaved: isSavedInContacts, isIos: false),
      ],
    );
  }
  @override
  Future<void> showConfirmation({required context, required title, required message}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Confirm")),
        ],
      ),
    );
  }

  @override
  Widget buildNameBadge({
    required String name,
    required bool isSaved,
    required bool isIos, // This parameter is passed but we force the style
  }) {
    final Color color = isSaved ? Colors.blue : Colors.green;

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8), // Material style
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSaved ? Icons.person : Icons.verified,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  
}