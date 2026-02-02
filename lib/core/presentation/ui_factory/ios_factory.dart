import 'package:apple_passkit/apple_passkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kgl_express/core/presentation/ui_factory/ui_factory.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class IosFactory implements UIFactory {
  @override
  Color get primaryColor => const Color(0xFF1A1A1A);
  @override
  Color get surfaceColor => const Color(0xFF1A1A1A);


  @override
  PreferredSizeWidget buildAppBar({
    required String title,
    Widget? leading,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    final bool isDarkBackground = (backgroundColor ?? Colors.white).computeLuminance() < 0.5;
    final Color finalForegroundColor = foregroundColor ?? (isDarkBackground ? Colors.white : Colors.black);

    return PreferredSize(
      preferredSize: const Size.fromHeight(44), // Standard iOS Nav Bar height
      child: CupertinoTheme(
        data: CupertinoThemeData(
          // This is where we force the back button and action colors
          primaryColor: finalForegroundColor,
        ),
        child: CupertinoNavigationBar(
          middle: Text(
            title,
            style: TextStyle(
              color: finalForegroundColor,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          backgroundColor: backgroundColor ?? Colors.white.withValues(alpha:0.9),
          leading: leading,
          border: backgroundColor != null ? const Border(bottom: BorderSide(color: Colors.transparent)) : null,
        ),
      ),
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
    // Logic: Parameter ?? Theme Default
    final Color finalBgColor = backgroundColor ?? Theme.of(context).colorScheme.primary;
    final double finalRadius = borderRadius ?? 12.0;

    return CupertinoButton(
      color: finalBgColor,
      borderRadius: BorderRadius.circular(finalRadius),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      onPressed: onPressed,
      child: child,
    );
  }







  @override
  Widget buildInputField({
    required context,
    required controller,
    required hint,
    fillColor, // Optional parameter
    icon,
    keyboardType,
    onChanged,
  }) {
    final theme = Theme.of(context);
    return CupertinoTextField(
      controller: controller,
      placeholder: hint,
      onChanged: onChanged,
      keyboardType: keyboardType,
      padding: const EdgeInsets.all(16),
      // Logic: Parameter ?? Theme Surface Container
      decoration: BoxDecoration(
        color: fillColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
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
      color: CupertinoColors.systemBackground,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: CupertinoColors.separator.withValues(alpha:0.2)),
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

  @override
  Widget buildSelectionTile({
    required String title,
    required bool isSelected,
    required IconData icon,
    required Color iconColor,
    required ValueChanged<bool?> onChanged,
  }) {
    return CupertinoListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          letterSpacing: -0.3,
        ),
      ),
      // Using a Switch instead of a check icon
      trailing: CupertinoSwitch(
        value: isSelected,
        activeTrackColor: CupertinoColors.activeGreen, // Classic iOS green
        onChanged: (bool value) {
          onChanged(value);
        },
      ),
      // On iOS, tapping the row should also toggle the switch
      onTap: () => onChanged(!isSelected),
    );
  }



  @override
  Widget buildWalletButton({
    required BuildContext context,
    required VoidCallback onPressed,
    Color? backgroundColor,
    double? borderRadius,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50, // Standard height for iOS Wallet buttons
      child: buildButton(
        context: context,
        onPressed: onPressed,
        // Priority: 1. Manual Override, 2. Brand Scrim (Black), 3. Primary Color
        //backgroundColor: backgroundColor ?? theme.colorScheme.scrim,
        //borderRadius: borderRadius ?? 8.0, // Apple standard radius
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
                CupertinoIcons.creditcard_fill,
                color: Colors.white,
                size: 22
            ),
            const SizedBox(width: 12),
            Text(
              "Add to Apple Wallet",
              style: TextStyle(
                // Using white here because Wallet buttons are historically black
                // regardless of light/dark mode for branding.
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void showActionSheet({
    required BuildContext context,
    required String title,
    required List<Widget> actions,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(title),
        // In a real app, you might want to pass 'message' as well
        actions: actions,
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }
  @override
  String getWalletInstruction() => "ACCESS QUICKLY VIA DOUBLE-TAP ON SIDE BUTTON";

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


  /*@override
  Future<void> handleWalletAddition({required String passUrl, Map<String, dynamic>? data}) async {
    /// 1. CHECK AVAILABILITY
    /// Before attempting to add, we must ensure the hardware/OS supports PassKit.
    final bool isAvailable = await _applePasskitPlugin.isPassLibraryAvailable();
    if (!isAvailable) {
      // TODO: Implement a user-friendly 'Not Supported' dialog
      return;
    }

    try {
      /// 2. FETCH PASS DATA
      /// FUTURE IMPLEMENTATION:
      /// Currently, we might load a local asset for testing.
      /// In production, you must use an HTTP client (like Dio or http) to:
      ///   a. Send the [passUrl] to your backend.
      ///   b. Receive a Stream or List<int> representing the .pkpass binary.
      ///   c. Convert it to Uint8List.

      // TEMPORARY: Loading a placeholder asset to demonstrate the plugin flow
      // final Uint8List passBytes = await _fetchPassFromNetwork(passUrl);
      final ByteData assetData = await rootBundle.load('assets/passes/kgl_sample.pkpass');
      final Uint8List passBytes = assetData.buffer.asUint8List();

      /// 3. ADD TO NATIVE WALLET
      /// This triggers the native Apple "Add Pass" view controller.
      /// The user must manually tap "Add" in the top right corner.
      await _applePasskitPlugin.addPass(passBytes);

    } catch (e) {
      /// TODO: Handle specific errors
      /// - Network timeout during download
      /// - Invalid signature (Apple requires passes to be signed with your developer cert)
      debugPrint("iOS PassKit Error: $e");
    }
  }
*/
  @override
  Future<void> handleWalletAddition({required String passUrl, Map<String, dynamic>? data}) async {
    final applePassKit = ApplePassKit();

    // 1. Check if the library is available on this device
    if (await applePassKit.isPassLibraryAvailable()) {
      try {
        /* FUTURE CODE:
       Replace rootBundle with a network call to download the actual .pkpass file.
       Example: final response = await http.get(Uri.parse(passUrl));
       final Uint8List passBytes = response.bodyBytes;
      */

        // Temporary placeholder using local asset
        final ByteData assetData = await rootBundle.load('assets/coupon.pkpass');
        final Uint8List passBytes = assetData.buffer.asUint8List();

        // 2. Present the native Apple "Add Pass" UI
        await applePassKit.addPass(passBytes);
      } catch (e) {
        print("Apple Wallet Error: $e");
      }
    }
  }
}