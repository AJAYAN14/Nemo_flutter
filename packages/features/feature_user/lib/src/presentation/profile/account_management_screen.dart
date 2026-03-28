import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/user_routes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'account_components.dart';
import 'account_dialogs.dart';

// --- Mock Providers for Account UI 1:1 Demo ---
class AccountUiState {
  AccountUiState({
    this.username = 'Nemo User',
    this.email = 'nemo@example.com',
    this.avatarPath,
    this.isSyncLoading = false,
    this.showSyncSuccess = false,
    this.isRestoreLoading = false,
    this.showRestoreSuccess = false,
  });

  final String username;
  final String email;
  final String? avatarPath;
  final bool isSyncLoading;
  final bool showSyncSuccess;
  final bool isRestoreLoading;
  final bool showRestoreSuccess;

  AccountUiState copyWith({
    String? username,
    String? email,
    String? avatarPath,
    bool? isSyncLoading,
    bool? showSyncSuccess,
    bool? isRestoreLoading,
    bool? showRestoreSuccess,
  }) {
    return AccountUiState(
      username: username ?? this.username,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      isSyncLoading: isSyncLoading ?? this.isSyncLoading,
      showSyncSuccess: showSyncSuccess ?? this.showSyncSuccess,
      isRestoreLoading: isRestoreLoading ?? this.isRestoreLoading,
      showRestoreSuccess: showRestoreSuccess ?? this.showRestoreSuccess,
    );
  }
}

class AccountNotifier extends Notifier<AccountUiState> {
  @override
  AccountUiState build() => AccountUiState();

  Future<void> syncToCloud() async {
    state = state.copyWith(isSyncLoading: true, showSyncSuccess: false);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isSyncLoading: false, showSyncSuccess: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(showSyncSuccess: false);
  }

  Future<void> restoreFromCloud() async {
    state = state.copyWith(isRestoreLoading: true, showRestoreSuccess: false);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isRestoreLoading: false, showRestoreSuccess: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(showRestoreSuccess: false);
  }

  void updateUsername(String newName) => state = state.copyWith(username: newName);
  void updateEmail(String newEmail) => state = state.copyWith(email: newEmail);
}

final accountProvider = NotifierProvider<AccountNotifier, AccountUiState>(AccountNotifier.new);
// ----------------------------------------------

class AccountManagementScreen extends ConsumerWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(accountProvider);
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('账户管理', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // 1. Profile Header
          ProfileHeaderSection(
            username: uiState.username,
            email: uiState.email,
            avatarPath: uiState.avatarPath,
            onEditAvatar: () {
              // TODO: Avatar edit dialog
            },
          ),
          
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Group 1: Profile Settings
                PremiumSettingsGroup(
                  title: '个人信息',
                  children: [
                    PremiumSettingsItem(
                      icon: Icons.badge_rounded,
                      iconTint: const Color(0xFF007AFF), // Blue
                      title: '修改用户名',
                      onClick: () => showDialog(
                        context: context,
                        builder: (_) => AccountUpdateUsernameDialog(
                          currentUsername: uiState.username,
                          onUpdate: (name) async => ref.read(accountProvider.notifier).updateUsername(name),
                        ),
                      ),
                    ),
                    const _SettingsDivider(),
                    PremiumSettingsItem(
                      icon: Icons.mail_outline_rounded,
                      iconTint: const Color(0xFF34C759), // Green
                      title: '修改邮箱',
                      onClick: () => showDialog(
                        context: context,
                        builder: (_) => AccountUpdateEmailDialog(
                          currentEmail: uiState.email,
                          onUpdate: (email) async => ref.read(accountProvider.notifier).updateEmail(email),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Group 2: Security
                PremiumSettingsGroup(
                  title: '安全',
                  children: [
                    PremiumSettingsItem(
                      icon: Icons.lock_reset_rounded,
                      iconTint: const Color(0xFFFF9500), // Orange
                      title: '重置密码',
                      onClick: () {
                        // TODO: Reset password dialog
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Group 3: Data Sync
                PremiumSettingsGroup(
                  title: '数据同步',
                  children: [
                    PremiumSettingsItem(
                      icon: Icons.cloud_upload_rounded,
                      iconTint: const Color(0xFFAF52DE), // Purple
                      title: '立即同步',
                      subtitle: uiState.isSyncLoading ? '正在同步数据...' : (uiState.showSyncSuccess ? '同步成功' : '上次同步: 刚才'),
                      trailing: _SyncStatusIndicator(
                        isLoading: uiState.isSyncLoading,
                        isSuccess: uiState.showSyncSuccess,
                      ),
                      onClick: () => ref.read(accountProvider.notifier).syncToCloud(),
                    ),
                    const _SettingsDivider(),
                    PremiumSettingsItem(
                      icon: Icons.cloud_download_rounded,
                      iconTint: const Color(0xFF32ADE6), // Cyan
                      title: '从云端恢复',
                      subtitle: uiState.isRestoreLoading ? '正在恢复数据...' : (uiState.showRestoreSuccess ? '恢复成功' : '从未恢复'),
                      trailing: _SyncStatusIndicator(
                        isLoading: uiState.isRestoreLoading,
                        isSuccess: uiState.showRestoreSuccess,
                      ),
                      onClick: () => ref.read(accountProvider.notifier).restoreFromCloud(),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Group 4: Danger Zone
                PremiumSettingsGroup(
                  title: '危险区域',
                  children: [
                    PremiumSettingsItem(
                      icon: Icons.cloud_off_rounded,
                      iconTint: const Color(0xFFFF9500), // Orange
                      title: '清空云端同步数据',
                      titleColor: const Color(0xFFFF9500),
                      onClick: () {
                        // TODO: Delete cloud data confirm
                      },
                    ),
                    const _SettingsDivider(),
                    PremiumSettingsItem(
                      icon: Icons.delete_forever_rounded,
                      iconTint: Colors.red,
                      title: '删除账户',
                      titleColor: Colors.red,
                      onClick: () => showDialog(
                        context: context,
                        builder: (_) => DeleteAccountDialog(
                          onConfirm: (pw) async {
                            // TODO: Real delete
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => LogoutWarningDialog(
                        onLogout: () {
                          // TODO: Logout
                        },
                        onBackup: () => ref.read(accountProvider.notifier).syncToCloud(),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('退出登录', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 64),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
      ),
    );
  }
}

class _SyncStatusIndicator extends StatelessWidget {
  const _SyncStatusIndicator({
    required this.isLoading,
    required this.isSuccess,
  });

  final bool isLoading;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (isSuccess) {
      return const Icon(Icons.check_circle_rounded, color: Color(0xFF34C759), size: 20);
    }
    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: 14,
      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
    );
  }
}
