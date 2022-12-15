import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TextFieldFormBuilderWidget extends StatelessWidget {
  final String? initialValue;
  final String name;
  final String labelText;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final bool? obscureText;
  final bool? readOnly;

  const TextFieldFormBuilderWidget({
    Key? key,
    required this.name,
    required this.labelText,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
    this.obscureText,
    this.initialValue, this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth < 600;

    // Sizes
    double fontSize = screenWidth * (isMobileView ? 0.040 : 0.030);
    double borderRadiusSize = screenWidth * (isMobileView ? 0.016 : 0.008);
    // Sizes

    return Container(
      padding: EdgeInsets.only(
        bottom: screenWidth * 0.040,
      ),
      child: FormBuilderTextField(
        initialValue: initialValue,
        name: name,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: fontSize,
          ),
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xff008037),
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadiusSize),
            ),
          ),
          border: const OutlineInputBorder(),
        ),
        obscureText: obscureText ?? false,
        onSaved: onSaved,
        onChanged: onChanged,
        validator: validator,
        readOnly: readOnly ?? false,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
