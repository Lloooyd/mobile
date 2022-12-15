import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/text_widget.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final String? variant;
  final String? textColor;
  final Function() onPressed;

  const ElevatedButtonWidget({
    Key? key,
    required,
    required this.text,
    this.variant,
    required this.onPressed,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth < 600;

    // Size
    double paddingSize = screenWidth * (isMobileView ? 0.030 : 0.020);

    // FONT COLOR
    const buttonColor = <String, Color> {
      'primary': Color(0xff008037),
      'secondary': Color.fromARGB(255, 140, 205, 255),
      'danger': Color(0xFFF44336),
      'success': Color(0xFF4CAF50),
      'light': Color(0xFFEEEEEE),
      'white': Color(0xFFFFFFFF),
      'disabled': Color(0xFFE0E0E0),
    };
    Colors.grey;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(paddingSize),
        primary: buttonColor[variant ?? 'primary'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(screenWidth * 1),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.020),
        child: TextWidget(
          text: text,
          fontWeight: FontWeight.w700,
          size: 'xs',
          overflow: TextOverflow.ellipsis,
          variant: (variant == 'light' || variant == 'white')
              ? 'default'
              : (variant == 'secondary'
                  ? 'primary'
                  : (variant != 'disabled' ? 'white' : 'disabled')),
        ),
      ),
    );
  }
}
