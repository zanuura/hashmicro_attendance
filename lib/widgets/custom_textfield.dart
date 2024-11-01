import 'package:flutter/material.dart';
import 'package:hashmicro_attendance/widgets/warna.dart';

class CTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool? enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final double borderRadius;
  final Function(String)? onChanged;
  final String? subLabelText;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final EdgeInsets? contentPadding;
  final EdgeInsets? outerPadding;

  const CTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.hintStyle,
    this.labelStyle,
    this.textStyle,
    this.maxLines,
    this.minLines,
    this.obscureText = false,
    this.keyboardType,
    this.enabled,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.borderRadius = 8,
    this.onChanged,
    this.subLabelText,
    this.textInputAction,
    this.onSubmitted,
    this.contentPadding,
    this.outerPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              color: fillColor ?? Colors.white,
              child: RichText(
                text: TextSpan(
                  text: labelText,
                  style: labelStyle ?? TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Warna.hitam,
                  ),
                  // style: TextStyle(fontSize: 10, color: Warna.regulerFontColor),
                  children: [
                    TextSpan(
                      text: subLabelText,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Padding(
          padding: outerPadding ?? const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            obscuringCharacter: '●',
            keyboardType: keyboardType,
            textInputAction: textInputAction ?? TextInputAction.done,
            maxLines: maxLines,
            minLines: minLines,
            enabled: enabled,
            style: TextStyle(
                      color: Warna.hitam,
                    ),
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                      color: Warna.hitam.withOpacity(0.50),
                    ),
              filled: true,
              fillColor: fillColor ?? Colors.white,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? Colors.grey),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: borderColor ?? Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? Colors.grey),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? Colors.grey),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15,),
      ],
    );
  }
}