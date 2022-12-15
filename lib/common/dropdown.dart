import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DropdownFormBuilderWidget extends StatelessWidget {
  final String name;
  final String labelText;
  final List<DropdownMenuItem<Object>> items;
  final void Function(Object?)? onChanged;
  final void Function(Object?)? valueTransformer;
  final String? Function(Object?)? validator;
  final void Function(String?)? onSaved;

  const DropdownFormBuilderWidget({
    Key? key,
    required this.name,
    required this.labelText,
    required this.items,
    this.onChanged,
    this.valueTransformer,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobileView = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width * 0.040,
      ),
      child: FormBuilderDropdown(
        name: name,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width *
                (isMobileView ? 0.050 : 0.030),
          ),
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xff008037),
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.width * 0.008),
            ),
          ),
          border: const OutlineInputBorder(),
        ),
        isExpanded: true,
        allowClear: true,
        validator: validator,
        items: items,
        onChanged: onChanged,
        valueTransformer: valueTransformer,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.040,
        ),
      ),
    );
  }
}
