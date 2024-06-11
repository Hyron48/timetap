import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final FormFieldValidator<String> validator;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String prefixText;
  final String suffixText;
  final TextAlign textAlign;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTapField;
  final dynamic onChanged;
  final bool disabled;

  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    required this.label,
    required this.validator,
    required this.textInputAction,
    this.focusNode,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText = '',
    this.suffixText = '',
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.readOnly = false,
    this.disabled = false,
    this.onTapField,
    this.onChanged,
  });

  InputBorder _getMainBorderShape() {
    OutlineInputBorder border = textFieldBorder;
    return (disabled == true)
        ? border.copyWith(
            borderSide: const BorderSide(color: lightGrey),
          )
        : border;
  }

  void _resetValidator(BuildContext context) {
    Form.of(context).reset();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign,
      enabled: true,
      onTap: () {
        _resetValidator(context);
        if (onTapField != null) {
          onTapField!();
        }
      },
      focusNode: focusNode,
      textInputAction: textInputAction,
      validator: validator,
      controller: textEditingController,
      obscureText: obscureText,
      readOnly: readOnly,
      onChanged: onChanged,
      style: TextStyle(
        color: black,
        fontWeight: lightFontWeight,
        fontSize: fontSizeText,
      ),
      decoration: InputDecoration(
        errorMaxLines: 2,
        hintText: label,
        enabledBorder: _getMainBorderShape(),
        border: _getMainBorderShape(),
        focusedBorder: _getMainBorderShape(),
        errorBorder: textFieldBorderError,
        focusedErrorBorder: textFieldBorderError,
        contentPadding: const EdgeInsets.only(
          left: defaultSidePadding,
          top: 20,
          right: defaultSidePadding,
        ),
        filled: true,
        fillColor: disabled ? darkGrey : white,
        prefixIcon: prefixIcon,
        prefixText: prefixText.isEmpty ? null : prefixText,
        suffixText: suffixText.isEmpty ? null : suffixText,
        suffixIcon: suffixIcon
      ),
    );
  }
}
