import 'package:flutter/material.dart';

/// 日语振假名单元 (Annotated or Plain)
sealed class FuriganaSegment {
  const FuriganaSegment();
}

class PlainSegment extends FuriganaSegment {
  final String text;
  const PlainSegment(this.text);
}

class AnnotatedSegment extends FuriganaSegment {
  final String kanji;
  final String furigana;
  const AnnotatedSegment(this.kanji, this.furigana);
}

/// 日语振假名组件 (Japanese Furigana Text)
class NemoFuriganaText extends StatelessWidget {
  const NemoFuriganaText({
    super.key,
    required this.text,
    this.baseTextStyle,
    this.baseTextColor,
    this.furiganaTextSize = 12,
    this.furiganaTextColor = Colors.grey,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle? baseTextStyle;
  final Color? baseTextColor;
  final double furiganaTextSize;
  final Color furiganaTextColor;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    
    final segments = _parseFuriganaText(text);
    final themeTextStyle = baseTextStyle ?? Theme.of(context).textTheme.bodyLarge;
    final themeTextColor = baseTextColor ?? themeTextStyle?.color;

    return Wrap(
      alignment: _getWrapAlignment(textAlign),
      crossAxisAlignment: WrapCrossAlignment.end,
      children: segments.map((segment) {
        if (segment is PlainSegment) {
          return _buildPlainText(segment.text, themeTextStyle, themeTextColor);
        } else if (segment is AnnotatedSegment) {
          return _buildAnnotatedText(segment, themeTextStyle, themeTextColor);
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  Widget _buildPlainText(String text, TextStyle? style, Color? color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Top spacing for furigana alignment
        SizedBox(height: furiganaTextSize + 4),
        Text(
          text,
          style: style?.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildAnnotatedText(AnnotatedSegment segment, TextStyle? style, Color? color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Furigana
        Text(
          segment.furigana,
          style: TextStyle(
            fontSize: furiganaTextSize,
            color: furiganaTextColor,
            fontWeight: FontWeight.normal,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        // Kanji
        Text(
          segment.kanji,
          style: style?.copyWith(color: color),
        ),
      ],
    );
  }

  WrapAlignment _getWrapAlignment(TextAlign align) {
    switch (align) {
      case TextAlign.center: return WrapAlignment.center;
      case TextAlign.end: return WrapAlignment.end;
      default: return WrapAlignment.start;
    }
  }

  List<FuriganaSegment> _parseFuriganaText(String text) {
    final List<FuriganaSegment> result = [];
    // Regex: Match Kanji followed by [Furigana]
    final pattern = RegExp(r'([\u4E00-\u9FFF\u3400-\u4DBF々]+)\[([^\]]+)\]');
    
    int lastIndex = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > lastIndex) {
        result.add(PlainSegment(text.substring(lastIndex, match.start)));
      }
      result.add(AnnotatedSegment(match.group(1)!, match.group(2)!));
      lastIndex = match.end;
    }
    
    if (lastIndex < text.length) {
      result.add(PlainSegment(text.substring(lastIndex)));
    }
    
    return result;
  }
}
