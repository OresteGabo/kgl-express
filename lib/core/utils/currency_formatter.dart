class CurrencyUtils {
  static String formatAmount(double amount) {
    if (amount >= 1000000) {
      double millions = amount / 1000000;
      // If it's a whole number like 2.0M, show 2M. If 2.5M, show 2.5M.
      return "${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 1)}M";
    } else if (amount >= 1000) {
      double thousands = amount / 1000;
      return "${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 1)}k";
    } else {
      return amount.toInt().toString();
    }
  }
}