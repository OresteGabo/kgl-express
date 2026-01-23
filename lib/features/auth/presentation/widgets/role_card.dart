import 'package:flutter/material.dart';
import 'package:kgl_express/core/enums/user_role.dart';
class RoleCard extends StatelessWidget {
  final UserRole role;
  final VoidCallback onTap;
  final bool isRecommended;

  const RoleCard({
    super.key,
    required this.role,
    required this.onTap,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isRecommended
            ? const BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: Icon(role.icon, color: Colors.green),
        title: Row(
          children: [
            Text(role.label, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isRecommended) ...[
              const SizedBox(width: 8),
              const Text(
                'RECOMMENDED',
                style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w900),
              ),
            ]
          ],
        ),
        subtitle: Text('Access ${role.label} features'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}