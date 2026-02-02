import 'package:flutter/material.dart';
import 'package:kgl_express/features/sender/presentation/provider_profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ContactUtils {
  /// Opens the native phone dialer
  static Future<void> makeCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  /// Make a whatsapp call request
  static Future<void> makeWhatsappCall(String number, String name) async {
    final cleanNumber = number.replaceAll(RegExp(r'[\+\s\-\(\)]'), '');

    final message = Uri.encodeComponent(
        "Hello $name, I'm calling you from KGL Express. Are you available for a WhatsApp call?"
    );

    final Uri url = Uri.parse(
      'https://wa.me/$cleanNumber?text=$message',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  static void showCallOptions(BuildContext context, ServiceProvider motar) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  'Contact via',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                /// Normal phone call
                ListTile(
                  leading: const Icon(Icons.call, color: Colors.blue),
                  title: const Text('Phone call'),
                  subtitle: Text(motar.phoneNumber),
                  onTap: () {
                    Navigator.pop(context);
                    ContactUtils.makeCall(motar.phoneNumber);
                  },
                ),

                /// WhatsApp call request
                ListTile(
                  leading: const Icon(Icons.whatshot, color: Colors.green),
                  title: const Text('WhatsApp call'),
                  subtitle: const Text('Open chat and request a call'),
                  onTap: () {
                    Navigator.pop(context);
                    ContactUtils.makeWhatsappCall(
                      motar.phoneNumber,
                      motar.name,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  /// Opens WhatsApp with a pre-filled message
  static Future<void> openWhatsApp(String number, String name) async {
    // Clean the number: remove '+', ' ', '-', etc.
    final cleanNumber = number.replaceAll(RegExp(r'[\+\s\-\(\)]'), '');

    // Create a pre-filled message for the Rwandan market
    final message = Uri.encodeComponent(
        "Hello $name, I found your profile on KGL Express and I'm interested in your services."
    );

    final Uri url = Uri.parse('https://wa.me/$cleanNumber?text=$message');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // If WhatsApp isn't installed, this usually opens the browser version
      await launchUrl(url, mode: LaunchMode.platformDefault);
    }
  }

  /// Modern Share API using ShareParams
  static Future<void> shareProviderProfile(BuildContext context, ServiceProvider pro) async {
    // 1. Prepare the text content
    final String shareContent = '''
Check out this professional on KGL Express!
    
Name: ${pro.name}
Service: ${pro.specialty}
Location: ${pro.location}
Rating: ${pro.rating} ⭐
    
Contact them directly via KGL Express: ${pro.phoneNumber}
''';

    // 2. Get the RenderBox for iPad/Tablet support (the 'box' logic from your doc)
    final box = context.findRenderObject() as RenderBox?;
    final Rect? sharePosition = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    try {
      // 3. Using the new SharePlus instance approach
      final ShareResult result = await SharePlus.instance.share(
        ShareParams(
          text: shareContent,
          subject: 'Service Provider Recommendation',
          title: 'Professional Profile: ${pro.name}',
          // sharePositionOrigin is vital for iPad and MacOS
          sharePositionOrigin: sharePosition,
        ),
      );

      // 4. Optional: Logic based on result (e.g., track successful shares)
      if (result.status == ShareResultStatus.success) {
        debugPrint("Successfully shared to: ${result.raw}");
      }
    } catch (e) {
      debugPrint("Error sharing profile: $e");
    }
  }

}