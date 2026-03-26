import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900, // ExtraBold
              letterSpacing: 0.5,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class PremiumGroupCard extends StatelessWidget {
  const PremiumGroupCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).colorScheme.surfaceContainer : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark 
              ? Theme.of(context).colorScheme.outlineVariant.withOpacity(0.1)
              : Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.03),
            blurRadius: isDark ? 2 : 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8), // Adjusted from 4 to 8
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: isDark
                      ? Theme.of(context).colorScheme.outlineVariant.withOpacity(0.1)
                      : Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class PremiumSettingRow extends StatelessWidget {
  const PremiumSettingRow({
    super.key,
    required this.label,
    required this.value,
    required this.onClick,
  });

  final String label;
  final String value;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600, // SemiBold
                  ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith( // Changed from titleMedium to bodyLarge
                        fontWeight: FontWeight.w500, // Medium
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                      ),
                ),
                const SizedBox(width: 6), // Adjusted from 8 to 6
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18, // Adjusted from 20 to 18
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumSwitchRow extends StatelessWidget {
  const PremiumSwitchRow({
    super.key,
    required this.label,
    required this.checked,
    required this.onCheckedChange,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onCheckedChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Adjusted from 8 to 14
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Switch(
            value: checked,
            onChanged: onCheckedChange,
            activeColor: Colors.white,
            activeTrackColor: NemoColors.brandBlue,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }
}
