import 'package:flutter/material.dart';

class AccountUpdateUsernameDialog extends StatefulWidget {
  const AccountUpdateUsernameDialog({
    super.key,
    required this.currentUsername,
    required this.onUpdate,
  });

  final String currentUsername;
  final Future<void> Function(String) onUpdate;

  @override
  State<AccountUpdateUsernameDialog> createState() => _AccountUpdateUsernameDialogState();
}

class _AccountUpdateUsernameDialogState extends State<AccountUpdateUsernameDialog> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentUsername);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      title: const Text('修改用户名', style: TextStyle(fontWeight: FontWeight.bold)),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: '新用户名',
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : () async {
            setState(() => _isLoading = true);
            await widget.onUpdate(_controller.text);
            if (mounted) Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('更新'),
        ),
      ],
    );
  }
}

class AccountUpdateEmailDialog extends StatefulWidget {
  const AccountUpdateEmailDialog({
    super.key,
    required this.currentEmail,
    required this.onUpdate,
  });

  final String currentEmail;
  final Future<void> Function(String) onUpdate;

  @override
  State<AccountUpdateEmailDialog> createState() => _AccountUpdateEmailDialogState();
}

class _AccountUpdateEmailDialogState extends State<AccountUpdateEmailDialog> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      title: const Text('修改邮箱', style: TextStyle(fontWeight: FontWeight.bold)),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: '新邮箱地址',
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : () async {
            setState(() => _isLoading = true);
            await widget.onUpdate(_controller.text);
            if (mounted) Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('发送验证码'),
        ),
      ],
    );
  }
}

class LogoutWarningDialog extends StatelessWidget {
  const LogoutWarningDialog({
    super.key,
    required this.onLogout,
    required this.onBackup,
  });

  final VoidCallback onLogout;
  final VoidCallback onBackup;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      title: const Text('退出登录', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text('您确认要退出登录吗？\n建议在退出前同步一次数据，以免本地缓存丢失。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            onBackup();
            Navigator.pop(context);
          },
          child: const Text('先去备份'),
        ),
        TextButton(
          onPressed: () {
            onLogout();
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('直接退出'),
        ),
      ],
    );
  }
}

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    super.key,
    required this.onConfirm,
  });

  final Future<void> Function(String password) onConfirm;

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      title: const Text('删除账户', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('这是一个不可逆的操作！所有云端同步的学习进度和记录将被永久删除。', style: TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: '请输入密码确认',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : () async {
            setState(() => _isLoading = true);
            await widget.onConfirm(_controller.text);
            if (mounted) Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('确认删除'),
        ),
      ],
    );
  }
}
