import 'package:flutter_contacts/flutter_contacts.dart';

class ContactService {
  /// Opens the native picker and returns the raw phone number string.
  /// Returns null if permission is denied or no contact is picked.
  static Future<String?> pickContactNumber() async {
    // Explicitly check and request
    bool permission = await FlutterContacts.requestPermission();

    if (!permission) {
      print("MY_DEBUG: Permission denied by user");
      return null;
    }

    try {
      // Some Android devices struggle with openExternalPick() if
      // the Contacts app is restricted.
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null && contact.phones.isNotEmpty) {
        return contact.phones.first.number.replaceAll(RegExp(r'[^0-9+]'), '');
      }
    } catch (e) {

      print("MY_DEBUG: Error picking contact: $e");
    }
    return null;
  }
}