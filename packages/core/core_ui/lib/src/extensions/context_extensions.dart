import 'package:flutter/material.dart';

extension NemoBottomSheetExtension on BuildContext {
  /// 显示一个统一风格的 Nemo 底部面板
  /// 
  /// 默认使用 [rootNavigator] 以确保覆盖底部导航栏
  Future<T?> showNemoBottomSheet<T>({
    required Widget child,
    bool useRootNavigator = true,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    Color backgroundColor = Colors.transparent,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: (context) => child,
      useRootNavigator: useRootNavigator,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
    );
  }
}
