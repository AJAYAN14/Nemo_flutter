import 'package:core_designsystem/core_designsystem.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/library_routes.dart';

/// 专项分类主题颜色
class _CategoryThemeColor {
  final Color containerColor;
  final Color contentColor;

  const _CategoryThemeColor({
    required this.containerColor,
    required this.contentColor,
  });
}

/// 专项训练/专项词汇 - 分类选择界面
/// 
/// 风格统一：
/// - Background: Solid (Theme background)
/// - Card: Premium Card (White/SurfaceContainer + Shadow + 26dp Rounded)
/// - Icon: Squircle (Rounded 14dp)
/// - Typography: ExtraBold Titles
class CategoryClassificationScreen extends StatelessWidget {
  const CategoryClassificationScreen({
    super.key,
    this.source = 'practice',
  });

  final String source;

  @override
  Widget build(BuildContext context) {

    final title = source == 'practice' ? '专项训练' : '专项词汇';

    return Scaffold(
      backgroundColor: NemoColors.bgBase,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 基础词性类
            const _SectionHeader(title: '基础词性类'),
            const SizedBox(height: 16),
            _CategoryGrid(
              items: [
                _CategoryItem(
                  id: 'noun',
                  title: '名词类',
                  subtitle: '名词、代词等',
                  icon: Icons.menu_book_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardNounBgDark : NemoCategoryColors.cardNounBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardNounTextDark : NemoCategoryColors.cardNounTextLight,
                  ),
                ),
                _CategoryItem(
                  id: 'adj',
                  title: '形容词类',
                  subtitle: 'い形、な形形容词',
                  icon: Icons.stars_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardAdjIBgDark : NemoCategoryColors.cardAdjIBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardAdjITextDark : NemoCategoryColors.cardAdjITextLight,
                  ),
                ),
                _CategoryItem(
                  id: 'verb',
                  title: '动词类',
                  subtitle: '自动/他动/自他動词',
                  icon: Icons.directions_run_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardVerbBgDark : NemoCategoryColors.cardVerbBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardVerbTextDark : NemoCategoryColors.cardVerbTextLight,
                  ),
                ),
                _CategoryItem(
                  id: 'adv',
                  title: '副词',
                  subtitle: '修饰用言词汇',
                  icon: Icons.sort_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardAdvBgDark : NemoCategoryColors.cardAdvBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardAdvTextDark : NemoCategoryColors.cardAdvTextLight,
                  ),
                ),
              ],
              onItemClick: (item) => _onCategorySelected(context, item),
            ),

            const SizedBox(height: 32),

            // 2. 构词·句法功能类
            const _SectionHeader(title: '构词·句法功能类'),
            const SizedBox(height: 16),
            _CategoryGrid(
              items: [
                _CategoryItem(
                  id: 'rentai',
                  title: '连体词',
                  subtitle: '直接修饰体言',
                  icon: Icons.link_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardRentaiBgDark : NemoCategoryColors.cardRentaiBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardRentaiTextDark : NemoCategoryColors.cardRentaiTextLight,
                  ),
                ),
                _CategoryItem(
                  id: 'conj',
                  title: '接続词',
                  subtitle: '连接句子成分',
                  icon: Icons.linear_scale_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardConjBgDark : NemoCategoryColors.cardConjBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardConjTextDark : NemoCategoryColors.cardConjTextLight,
                  ),
                ),
                _CategoryItem(
                  id: 'exclam',
                  title: '感叹词',
                  subtitle: '表达情感语气',
                  icon: Icons.campaign_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardIdiomBgDark : NemoCategoryColors.cardIdiomBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardIdiomTextDark : NemoCategoryColors.cardIdiomTextLight,
                  ),
                ),
                _CategoryItem(
                  id: 'particle',
                  title: '助词',
                  subtitle: '语法功能标记',
                  icon: Icons.attribution_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardFixBgDark : NemoCategoryColors.cardFixBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardFixTextDark : NemoCategoryColors.cardFixTextLight,
                  ),
                ),
              ],
              onItemClick: (item) => _onCategorySelected(context, item),
            ),

            const SizedBox(height: 32),

            // 3. 构词·表达用法类
            const _SectionHeader(title: '构词·表达用法类'),
            const SizedBox(height: 16),
            _CategoryGrid(
              items: [
                _CategoryItem(
                  id: 'prefix',
                  title: '接头词',
                  subtitle: '词语前置构成',
                  icon: Icons.arrow_forward_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardKataBgDark : NemoCategoryColors.cardKataBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardKataTextDark : NemoCategoryColors.cardKataTextLight,
                  ),
                ),
                _CategoryItem(
                  id: 'suffix',
                  title: '接尾词',
                  subtitle: '词语后置构成',
                  icon: Icons.arrow_back_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardSoundBgDark : NemoCategoryColors.cardSoundBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardSoundTextDark : NemoCategoryColors.cardSoundTextLight,
                  ),
                ),
                _CategoryItem(
                  id: 'expression',
                  title: '表达·固定句型',
                  subtitle: '习惯表达方式',
                  icon: Icons.format_quote_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardKeigoBgDark : NemoCategoryColors.cardKeigoBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardKeigoTextDark : NemoCategoryColors.cardKeigoTextLight,
                  ),
                ),
                _CategoryItem(
                  id: 'kata',
                  title: '外来语',
                  subtitle: '片假名借词体系',
                  icon: Icons.language_rounded,
                  getTheme: (isDark) => _CategoryThemeColor(
                    containerColor: isDark ? NemoCategoryColors.cardAdjNaBgDark : NemoCategoryColors.cardAdjNaBgLight,
                    contentColor: isDark ? NemoCategoryColors.cardAdjNaTextDark : NemoCategoryColors.cardAdjNaTextLight,
                  ),
                ),
              ],
              onItemClick: (item) => _onCategorySelected(context, item),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(BuildContext context, _CategoryItem item) {
    if (source == 'practice') {
      // Use the named route 'learning-category' defined in LearningRoutes
      context.pushNamed(
        'learning-category',
        pathParameters: {'categoryId': item.id},
        queryParameters: {'title': item.title},
      );
    } else {
      context.pushNamed(
        LibraryRouteNames.categoryWords,
        pathParameters: {'categoryId': item.id},
        queryParameters: {'title': item.title},
      );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.items,
    required this.onItemClick,
  });

  final List<_CategoryItem> items;
  final Function(_CategoryItem) onItemClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: _CategoryCard(
                    item: items[i],
                    onClick: () => onItemClick(items[i]),
                  ),
                ),
                const SizedBox(width: 16),
                if (i + 1 < items.length)
                  Expanded(
                    child: _CategoryCard(
                      item: items[i + 1],
                      onClick: () => onItemClick(items[i + 1]),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.item,
    required this.onClick,
  });

  final _CategoryItem item;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final theme = item.getTheme(Theme.of(context).brightness == Brightness.dark);

    return PremiumCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(26),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(26),
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onClick,
          child: Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Squircle Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.containerColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item.icon,
                    color: theme.contentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final _CategoryThemeColor Function(bool isDark) getTheme;

  const _CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.getTheme,
  });
}
