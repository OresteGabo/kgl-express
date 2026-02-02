import 'package:add_to_google_wallet/add_to_google_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kgl_express/core/presentation/ui_factory/ui_factory.dart';
import 'package:add_to_google_wallet/add_to_google_wallet.dart';
import 'package:url_launcher/url_launcher.dart';

class AndroidFactory implements UIFactory {
  @override
  Color get primaryColor => const Color(0xFF1A1A1A);
  @override
  Color get surfaceColor => throw UnimplementedError();


  @override
  PreferredSizeWidget buildAppBar({
    required String title,
    Widget? leading,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    // Determine if we are on a dark or light background to set the status bar icons
    final bool isDarkBackground = (backgroundColor ?? Colors.white).computeLuminance() < 0.5;

    return AppBar(
      title: Text(
          title,
          style: TextStyle(
              color: foregroundColor ?? (isDarkBackground ? Colors.white : Colors.black),
              fontWeight: FontWeight.bold
          )
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: leading,
      // This ensures the back button matches the text color
      iconTheme: IconThemeData(
          color: foregroundColor ?? (isDarkBackground ? Colors.white : Colors.black)
      ),
      // This adapts the Status Bar (Time, Battery) to be visible
      systemOverlayStyle: isDarkBackground
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
  }

  @override
  Widget buildButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback onPressed,
    Color? backgroundColor,
    double? borderRadius,
  }) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // Logic: Parameter ?? Theme Primary
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
        ),
        elevation: 0,
      ),
      child: child,
    );
  }
  @override
  Widget buildInputField({
    required context,
    required controller,
    required hint,
    fillColor,
    icon,
    keyboardType,
    onChanged,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        // Logic: Parameter ?? Theme Surface Low
        fillColor: fillColor ?? theme.colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIcon: icon != null ? Icon(icon) : null,
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
            // Inside your build method
            RadioGroup<bool>(
              groupValue: isSelected, // The current selected value
              onChanged: (bool? value) {
                if (value != null) {
                  onTap(); // Call your existing function
                }
              },
              child: Radio<bool>(
                value: true, // The value this specific radio represents
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) return Colors.black;
                  return Colors.grey;
                }),
              ),
            )
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

  @override
  Widget buildSelectionTile({
    required String title,
    required bool isSelected,
    required IconData icon,
    required Color iconColor,
    required ValueChanged<bool?> onChanged,
  }) {
    return SwitchListTile( // Note: Material 3 Switch is now the default in SwitchListTile
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha:0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      value: isSelected,
      activeThumbColor: Colors.green,
      activeTrackColor: Colors.green.withValues(alpha:0.2),
      // This is the magic part for the M3 check icon
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.check, color: Colors.white);
        }
        return null; // When off, it remains a simple circle
      }),
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  @override
  Widget buildWalletButton({
    required BuildContext context,
    required VoidCallback onPressed,
    Color? backgroundColor,
    double? borderRadius,
  }) {
    // We just call the normal buildButton but fill in the "Wallet" specifics
    return buildButton(
      context: context,
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_card, color: Colors.white),
          SizedBox(width: 12),
          Text("Add to Google Wallet", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  void showActionSheet({
    required BuildContext context,
    required String title,
    required List<Widget> actions,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      showDragHandle: true, // Native M3 feel
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const Divider(),
              ...actions,
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
  @override
  String getWalletInstruction() => "ACCESS QUICKLY VIA GOOGLE WALLET SHORTCUT";

  @override
  Widget buildWalletInstructionText() {
    return Text(
      getWalletInstruction(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 9,
        color: Colors.grey[400],
        letterSpacing: 0.5,
      ),
    );
  }
  @override
  Future<void> handleWalletAddition({required String passUrl, Map<String, dynamic>? data}) async {
    final String? jwt = data?['jwt'];
    if (jwt == null) return;

    // Google Wallet logic: Navigating to the save URL with the JWT
    // Format: https://pay.google.com/gp/v/save/{encoded_jwt}
    final String googleWalletUrl = "https://pay.google.com/gp/v/save/$jwt";
    final Uri uri = Uri.parse(googleWalletUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $googleWalletUrl';
      }
    } catch (e) {
      print("Google Wallet Error: $e");
    }
  }

}