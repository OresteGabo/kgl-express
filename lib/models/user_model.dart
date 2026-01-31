import 'package:kgl_express/core/enums/user_role.dart';
import 'package:kgl_express/core/utils/string_utils.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String phoneNumber;
  final UserRole role;
  final PrivacyLevel privacy;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    this.privacy = PrivacyLevel.contactsOnly,
  });
}


enum PrivacyLevel {
  public,
  contactsOnly,
  private
}

String getDisplayName({
  required UserModel recipient,
  required bool isSavedInMyContacts,
}) {
  switch (recipient.privacy) {
    case PrivacyLevel.public:
      return recipient.fullName;

    case PrivacyLevel.private:
      return obfuscateName(recipient.fullName);

    case PrivacyLevel.contactsOnly:
    // This is the "Smart" logic
      return isSavedInMyContacts
          ? recipient.fullName
          : obfuscateName(recipient.fullName);
  }
}