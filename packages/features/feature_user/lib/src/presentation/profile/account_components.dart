import 'package:flutter/material.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({
    super.key,
    required this.username,
    required this.email,
    this.avatarPath,
    required this.onEditAvatar,
  });

  final String username;
  final String email;
  final String? avatarPath;
  final VoidCallback onEditAvatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          // User Avatar with Ring
          GestureDetector(
            onTap: onEditAvatar,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surface,
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE0E0E0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: avatarPath != null
                        ? Image.asset(avatarPath!, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              username.isNotEmpty ? username[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
                // Edit Badge
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                    border: Border.all(color: theme.colorScheme.surface, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumSettingsGroup extends StatelessWidget {
  const PremiumSettingsGroup({
    super.key,
    required this.title,
    required this.children,
    this.backgroundColor,
  });

  final String title;
  final List<Widget> children;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBg = backgroundColor ?? (theme.brightness == Brightness.dark 
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) 
        : theme.colorScheme.surface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class PremiumSettingsItem extends StatelessWidget {
  const PremiumSettingsItem({
    super.key,
    required this.icon,
    required this.iconTint,
    required this.title,
    this.titleColor,
    this.subtitle,
    this.trailing,
    required this.onClick,
  });

  final IconData icon;
  final Color iconTint;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(26), // Match parent
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconTint.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconTint, size: 22),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: titleColor ?? theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            // Trailing
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    );
  }
}
