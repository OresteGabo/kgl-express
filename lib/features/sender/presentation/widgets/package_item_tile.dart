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
    final theme = Theme.of(context);
    final ui = AppUI.factory;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: ui.buildCardDecoration().copyWith(
        // Use surface color instead of white
        color: theme.colorScheme.surface,
        // Use outlineVariant for subtle borders
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Icon(
                    Icons.inventory_2_outlined,
                    color: _getGroupColor(context, item.compatibilityGroup)
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ui.buildInputField(
                  context: context,
                  controller: nameController,
                  hint: "What are you sending?",
                  onChanged: onNameChanged,
                ),
              ),
              IconButton(
                // Use the semantic error color for destructive actions
                icon: Icon(Icons.delete_sweep_outlined, color: theme.colorScheme.error),
                onPressed: () => onRemove(index),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCounterPill(context),
              _buildCompactCompatibility(context, item.compatibilityGroup),
            ],
          ),

          Divider(height: 24, color: theme.colorScheme.outlineVariant),

          _buildGroupPicker(context),
        ],
      ),
    );
  }

  Widget _buildCounterPill(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.remove, size: 18, color: theme.colorScheme.onSurface),
            onPressed: item.quantity > 1 ? () => onQtyChanged(index, item.quantity - 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
                "${item.quantity}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                )
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.add, size: 18, color: theme.colorScheme.onSurface),
            onPressed: () => onQtyChanged(index, item.quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupPicker(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: CompatibilityGroup.values.map((group) {
          final isSelected = item.compatibilityGroup == group;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: Icon(
                  _getIcon(group),
                  size: 14,
                  color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant
              ),
              showCheckmark: false,
              label: Text(
                  group.name,
                  style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant
                  )
              ),
              selected: isSelected,
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surfaceContainerLow,
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

  Widget _buildCompactCompatibility(BuildContext context, CompatibilityGroup group) {
    final themeColor = _getGroupColor(context, group);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(group), size: 14, color: themeColor),
          const SizedBox(width: 4),
          Text(
            group.name.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: themeColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGroupColor(BuildContext context, CompatibilityGroup group) {
    final theme = Theme.of(context);
    switch (group) {
      case CompatibilityGroup.hazardous:
        return theme.colorScheme.error; // Red/Orange for danger
      case CompatibilityGroup.fragile:
        return theme.colorScheme.primary; // Brand color for attention
      case CompatibilityGroup.safe:
        return theme.colorScheme.tertiary; // Green/Teal for safe
    }
  }


}