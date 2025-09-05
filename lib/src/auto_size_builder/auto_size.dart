part of '../../flutter_auto_size_text.dart';

class _AutoSize extends RenderObjectWidget {
  _AutoSize({
    required this.builder,
    this.overflowReplacement,
    required this.text,
    required this.textAlign,
    required this.textDirection,
    this.minLines,
    this.maxLines,
    this.locale,
    this.strutStyle,
    required this.textWidthBasis,
    this.textHeightBehavior,
    required this.wrapWords,
    required this.textScaleFactor,
    required this.minFontSize,
    required this.maxFontSize,
    this.groupMaxFontSize,
    required this.stepGranularity,
    required this.presetFontSizes,
    this.onMaxPossibleFontSizeChanged,
  }) {
    _validateProperties();
  }

  final _AutoSizeTextBuilder builder;
  final Widget? overflowReplacement;

  final TextSpan text;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final int? minLines;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final bool wrapWords;
  final double textScaleFactor;
  final double minFontSize;
  final double maxFontSize;
  final double stepGranularity;
  final List<double>? presetFontSizes;
  final double? groupMaxFontSize;
  final void Function(double)? onMaxPossibleFontSizeChanged;

  TextFitter _buildFitter() {
    return TextFitter(
      text: text,
      textAlign: textAlign,
      textDirection: textDirection,
      minLines: minLines,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      wrapWords: wrapWords,
      textScaleFactor: textScaleFactor,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      stepGranularity: stepGranularity,
      presetFontSizes: presetFontSizes,
    );
  }

  @override
  _RenderAutoSize createRenderObject(BuildContext context) {
    return _RenderAutoSize(
        fitter: _buildFitter(),
        onMaxPossibleFontSizeChanged: onMaxPossibleFontSizeChanged,
        groupMaxFontSize: groupMaxFontSize);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderAutoSize renderObject) {
    renderObject.updateTextFitter(_buildFitter());
    renderObject.updateGroupMaxFontSize(groupMaxFontSize);
  }

  @override
  RenderObjectElement createElement() {
    return _AutoSizeElement(this);
  }

  void _validateProperties() {
    assert(maxLines == null || maxLines! > 0,
        'MaxLines must be greater than or equal to 1.');

    if (presetFontSizes == null) {
      assert(
          stepGranularity >= 0.1,
          'StepGranularity must be greater than or equal to 0.1. It is not a '
          'good idea to resize the font with a higher accuracy.');
      assert(
          minFontSize >= 0, 'MinFontSize must be greater than or equal to 0.');
      assert(maxFontSize > 0, 'MaxFontSize has to be greater than 0.');
      assert(minFontSize <= maxFontSize,
          'MinFontSize must be smaller or equal than maxFontSize.');
      assert(minFontSize / stepGranularity % 1 == 0,
          'MinFontSize must be a multiple of stepGranularity.');
      if (maxFontSize != double.infinity) {
        assert(maxFontSize / stepGranularity % 1 == 0,
            'MaxFontSize must be a multiple of stepGranularity.');
      }
    } else {
      assert(presetFontSizes!.isNotEmpty, 'PresetFontSizes must not be empty.');
    }
  }
}
