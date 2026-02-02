
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// 1. The Contract: What must every OS implementation provide?
abstract class UIFactory {
  Widget buildInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    Color? fillColor,       // Optional override
    IconData? icon,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  });


  Widget buildCard({required Widget child, EdgeInsets? padding});
  Widget buildVerifiedInputField({
    required TextEditingController controller,
    required bool isVerifying,
    required String? confirmedName,
    required bool isSavedInContacts,
    required Function(String) onChanged,
    VoidCallback? onPickContact, // New parameter
  });
  // Navigation
  PreferredSizeWidget buildAppBar({
    required String title,
    Widget? leading,
    Color? backgroundColor,
    Color? foregroundColor,
  });



  Widget buildWalletButton({
    required BuildContext context,
    required VoidCallback onPressed,
    Color? backgroundColor,
    double? borderRadius,
  });


  // Feedback
  Widget buildLoadingIndicator();

  // Custom Design for KGL Express
  // This abstracts the background 'card' style for your PackageCards
  BoxDecoration buildCardDecoration();

  // Dialogs
  Future<void> showConfirmation({
    required BuildContext context,
    required String title,
    required String message
  });

  Widget buildTextButton({
    required String label,
    required VoidCallback onPressed,
    IconData? icon
  });

  // Added for MoMo / Airtel / BK integration
  Widget buildPaymentMethodTile({
    required String title,
    required String assetPath,
    required bool isSelected,
    required VoidCallback onTap,
  });

  Widget buildNameBadge({
    required String name,
    required bool isSaved,
    required bool isIos,
  });

  Widget buildSelectionTile({
    required String title,
    required bool isSelected,
    required IconData icon,
    required Color iconColor,
    required ValueChanged<bool?> onChanged,
  });

  Widget buildButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback onPressed,
    Color? backgroundColor,
    double? borderRadius,
  });

  void showActionSheet({
    required BuildContext context,
    required String title,
    required List<Widget> actions,
  });

  String getWalletInstruction();

  // Or if you want the factory to handle the styling too:
  Widget buildWalletInstructionText();

  Future<void> handleWalletAddition({required String passUrl, Map<String, dynamic>? data});
}
