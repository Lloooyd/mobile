import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final String? size;
  final String? variant;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? color;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final int? maxLines;
  final List<Shadow>? shadows;

  const TextWidget({
    Key? key,
    required,
    required this.text,
    this.size = 'sm',
    this.variant,
    this.overflow,
    this.fontWeight,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.letterSpacing,
    this.maxLines,
    this.shadows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobileView = MediaQuery.of(context).size.width < 600;

    // FONT SIZE
    Map<String, double> textSize = (isMobileView)
        ? <String, double>{
            'xxs': 0.027,
            'xs': 0.035,
            'xsm': 0.045,
            'sm': 0.050,
            'md': 0.055,
            'lg': 0.070,
          }
        : <String, double>{
            'xxxs': 0.015,
            'xxs': 0.018,
            'xs': 0.020,
            'xsm': 0.025,
            'sm': 0.030,
            'md': 0.040,
            'lg': 0.050,
          };

    // FONT COLOR
    const textColor = <String, Color>{
      'default': Color(0xDD000000),
      'primary': Color(0xff008037),
      'secondary': Color(0xFFFFFFFF),
      'danger': Color(0xFFF44336),
      'success': Color(0xFF4CAF50),
      'light': Color(0xFFBDBDBD),
      'disabled': Color(0xFF9E9E9E),
    };

    return Text(
      text,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: MediaQuery.of(context).size.width * (textSize[size] ?? 0.030),
        color: color ?? textColor[variant ?? 'default'],
        letterSpacing: letterSpacing,
        shadows: shadows,
      ),
    );
  }
}
