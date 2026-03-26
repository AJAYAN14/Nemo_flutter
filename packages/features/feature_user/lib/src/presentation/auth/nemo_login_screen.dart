import 'package:core_designsystem/core_designsystem.dart';
import 'package:flutter/material.dart';
import '../../routes/user_routes.dart';

class NemoLoginScreen extends StatefulWidget {
  const NemoLoginScreen({
    super.key,
    required this.onAuthSuccess,
  });

  final VoidCallback onAuthSuccess;

  @override
  State<NemoLoginScreen> createState() => _NemoLoginScreenState();
}

class _NemoLoginScreenState extends State<NemoLoginScreen> {
  final _accountController = TextEditingController(text: 'nemo@example.com');
  final _passwordController = TextEditingController(text: '123456');
  final _usernameController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscure = true;
  bool _confirmObscure = true;
  bool _isLoginMode = true;

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: NemoColors.brandBlue,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLoginMode ? '欢迎回来' : '创建账户',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isLoginMode ? '我们想念您！登录以开始学习' : '加入我们，开始您的学习之旅',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.86),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: NemoMetrics.topRadius26,
                boxShadow: NemoMetrics.cardTopShadow,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isLoginMode ? '登录' : '注册',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: NemoColors.textMain,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: NemoColors.surfaceSoft,
                        borderRadius: NemoMetrics.radius(26),
                      ),
                      child: Row(
                        children: [
                          _AuthTabButton(
                            text: '登录',
                            isSelected: _isLoginMode,
                            onTap: () => setState(() => _isLoginMode = true),
                          ),
                          _AuthTabButton(
                            text: '注册',
                            isSelected: !_isLoginMode,
                            onTap: () => setState(() => _isLoginMode = false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!_isLoginMode) ...[
                      _InputField(
                        label: '用户名',
                        hintText: '输入用户名',
                        controller: _usernameController,
                        prefixIcon: Icons.badge_rounded,
                      ),
                      const SizedBox(height: 12),
                    ],
                    _InputField(
                      label: '账号',
                      hintText: '输入邮箱或用户名',
                      controller: _accountController,
                      prefixIcon: Icons.person_rounded,
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      label: '密码',
                      hintText: '输入密码',
                      controller: _passwordController,
                      prefixIcon: Icons.lock_rounded,
                      obscureText: _obscure,
                      suffix: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: NemoColors.textMuted,
                        ),
                      ),
                    ),
                    if (!_isLoginMode) ...[
                      const SizedBox(height: 12),
                      _InputField(
                        label: '确认密码',
                        hintText: '再次输入密码',
                        controller: _confirmController,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _confirmObscure,
                        suffix: IconButton(
                          onPressed: () =>
                              setState(() => _confirmObscure = !_confirmObscure),
                          icon: Icon(
                            _confirmObscure
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: NemoColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                    if (_isLoginMode)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('忘记密码?'),
                        ),
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: NemoMetrics.authButtonHeight,
                      child: FilledButton(
                        onPressed: widget.onAuthSuccess,
                        style: FilledButton.styleFrom(
                          backgroundColor: NemoColors.brandBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: NemoMetrics.radius(14),
                          ),
                        ),
                        child: Text(
                          _isLoginMode ? '登录' : '注册',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTabButton extends StatelessWidget {
  const _AuthTabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor:
                isSelected ? NemoColors.brandBlue : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: NemoMetrics.radius(22),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : NemoColors.textSub,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: NemoColors.textSub,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(prefixIcon, color: NemoColors.textMuted),
            suffixIcon: suffix,
            border: OutlineInputBorder(
              borderRadius: NemoMetrics.radius(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: NemoMetrics.radius(14),
              borderSide: const BorderSide(color: NemoColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: NemoMetrics.radius(14),
              borderSide: const BorderSide(color: NemoColors.brandBlue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
