import 'package:flutter/material.dart';
import 'package:kgl_express/core/presentation/ui_factory/platform_ui.dart';
import 'package:kgl_express/models/package_model.dart';

class PackageItemTile extends StatelessWidget {
  final int index;
  final PackageItem item;
  final TextEditingController nameController;
  final Function(int) onRemove;
  final Function(CompatibilityGroup) onGroupChanged;
  final Function(int, int) onQtyChanged; // Pass index and new qty
  final Function(String) onNameChanged;

  const PackageItemTile({
    super.key,
    required this.index,
    required this.item,
    required this.nameController,
    required this.onRemove,
    required this.onGroupChanged,
    required this.onQtyChanged,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ui = AppUI.factory;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: ui.buildCardDecoration().copyWith(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Row: Icon + Name Input + Delete
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Icon(Icons.inventory_2_outlined, color: item.categoryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ui.buildInputField(
                  controller: nameController,
                  hint: "What are you sending?",
                  onChanged: onNameChanged,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                onPressed: () => onRemove(index),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 2. Quantity and Safety Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity "Pill" - separated - and + for better UX
              _buildCounterPill(),
              // Mini labels for groups
              _buildCompactCompatibility(item.compatibilityGroup),
            ],
          ),

          const Divider(height: 24),

          // 3. Safety Selection
          _buildGroupPicker(),
        ],
      ),
    );
  }

  Widget _buildCounterPill() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove, size: 18),
            onPressed: item.quantity > 1 ? () => onQtyChanged(index, item.quantity - 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => onQtyChanged(index, item.quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupPicker() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: CompatibilityGroup.values.map((group) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: Icon(_getIcon(group), size: 14,
                  color: item.compatibilityGroup == group ? Colors.white : Colors.black54),
              label: Text(group.name, style: const TextStyle(fontSize: 12)),
              selected: item.compatibilityGroup == group,
              selectedColor: Colors.black,
              onSelected: (val) => val ? onGroupChanged(group) : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIcon(CompatibilityGroup group) {
    if (group == CompatibilityGroup.fragile) return Icons.wine_bar;
    if (group == CompatibilityGroup.hazardous) return Icons.warning_amber_rounded;
    return Icons.verified_user_outlined;
  }
  Widget _buildCompactCompatibility(CompatibilityGroup group) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // Using the modern withValues for the background tint
        color: _getGroupColor(group).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(group), size: 14, color: _getGroupColor(group)),
          const SizedBox(width: 4),
          Text(
            group.name.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _getGroupColor(group),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGroupColor(CompatibilityGroup group) {
    switch (group) {
      case CompatibilityGroup.hazardous:
        return Colors.orange[800]!;
      case CompatibilityGroup.fragile:
        return Colors.blue[700]!;
      case CompatibilityGroup.safe:
      return Colors.green[700]!;
    }
  }
}