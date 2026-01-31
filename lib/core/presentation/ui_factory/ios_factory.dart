import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kgl_express/core/presentation/ui_factory/ui_factory.dart';

class IosFactory implements UIFactory {
  @override
  PreferredSizeWidget buildAppBar({required String title, Widget? leading}) {
    return CupertinoNavigationBar(
      middle: Text(title),
      backgroundColor: Colors.white.withOpacity(0.9),
      leading: leading, // Corrected signature
    );
  }

  @override
  Widget buildButton({required Widget child, required VoidCallback onPressed}) {
    return CupertinoButton(
      color: CupertinoColors.activeBlue,
      borderRadius: BorderRadius.circular(25),
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  Widget buildInputField({required controller, required hint, icon, keyboardType, onChanged}) {
    return CupertinoTextField(
      controller: controller,
      placeholder: hint,
      onChanged: onChanged,
      keyboardType: keyboardType,
      padding: const EdgeInsets.all(16),
      prefix: icon != null ? Padding(padding: const EdgeInsets.only(left: 12), child: Icon(icon, color: Colors.grey)) : null,
      decoration: BoxDecoration(color: CupertinoColors.extraLightBackgroundGray, borderRadius: BorderRadius.circular(10)),
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
      color: CupertinoColors.systemBackground,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: CupertinoColors.separator.withOpacity(0.2)),
    );
  }

  @override
  Widget buildLoadingIndicator() {
    return const Center(child: CupertinoActivityIndicator());
  }

  @override
  Widget buildTextButton({required String label, required VoidCallback onPressed, IconData? icon}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 20),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget buildPaymentMethodTile({required String title, required String assetPath, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: CupertinoColors.separator.withValues(alpha:0.5), width: 0.5)),
        ),
        child: Row(
          children: [
            Image.asset(assetPath, width: 40),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 17)),
            const Spacer(),
            if (isSelected) const Icon(CupertinoIcons.check_mark_circled_solid, color: CupertinoColors.activeBlue),
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
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text("RECIPIENT", style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey, fontWeight: FontWeight.bold)),
        ),
        CupertinoTextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          placeholder: "78... or 79...",
          padding: const EdgeInsets.all(16),
          prefix: const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text("+250", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Verification Spinner and Contact Picker on the right
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isVerifying) const CupertinoActivityIndicator(),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                onPressed: onPickContact,
                child: const Icon(CupertinoIcons.person_crop_circle_badge_plus, size: 24),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: CupertinoColors.extraLightBackgroundGray,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        if (confirmedName != null)
          buildNameBadge(name: confirmedName, isSaved: isSavedInContacts, isIos: true),
      ],
    );
  }
  @override
  Future<void> showConfirmation({required context, required title, required message}) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(child: const Text("Confirm"), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }



  @override
  Widget buildNameBadge({
    required String name,
    required bool isSaved,
    required bool isIos, // Ignored here to enforce iOS look
  }) {
    const Color activeBlue = Color(0xFF007AFF);
    const Color activeGreen = Color(0xFF34C759);
    final Color color = isSaved ? activeBlue : activeGreen;

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20), // Pill style for iOS
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSaved ? CupertinoIcons.person_fill : CupertinoIcons.checkmark_seal_fill,
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