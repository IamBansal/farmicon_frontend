import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme.dart';

/// App-wide common customization of [TextFormField].
class TextInput extends StatelessWidget {
  /// App-wide common customization of [TextFormField].
  const TextInput({
    required this.hint,
    required this.width,
    this.action = TextInputAction.next,
    this.controller,
    this.errorText,
    this.initialValue = '',
    this.keyboard,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.isFilled,
    this.fillColor,
    this.border,
    this.onSubmitted,
    this.prefixIconConstraints,
    this.validator,
    Key? key,
  }) : super(key: key);

  final bool obscureText;
  final int maxLines;
  final int? maxLength;
  final double width;
  final String initialValue;
  final String hint;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputAction action;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final bool? isFilled;
  final Color? fillColor;
  final InputBorder? border;
  final BoxConstraints? prefixIconConstraints;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 30.r,
      child: TextFormField(
        controller: controller,
        validator: validator,
        inputFormatters: (maxLength != null)
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : [],
        decoration: InputDecoration(
          errorText: errorText,
          labelText: hint,
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: AppTheme.primary),
              ),
          prefixIconConstraints: prefixIconConstraints,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primary,
              width: 1.5,
            ),
          ),
          filled: isFilled,
          fillColor: fillColor,
        ),
        initialValue: controller == null ? initialValue : null,
        keyboardType: keyboard,
        maxLines: maxLines,
        obscureText: obscureText,
        onChanged: onChanged,
        textInputAction: action,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}
