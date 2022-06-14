import 'package:flutter/material.dart';

class DTextField extends StatelessWidget {
  final String hint;
  final IconData prefix;
  final Widget? suffix;
  final bool obscureText;
  final bool suggestions;
  final bool isLast;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  const DTextField({
    Key? key,
    required this.hint,
    required this.prefix,
    this.suffix,
    this.obscureText = false,
    this.suggestions = true,
    this.onChanged,
    this.onSubmitted,
    this.isLast = false,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        // enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
        fillColor: const Color.fromARGB(128, 39, 45, 47),
        focusColor: const Color.fromARGB(128, 39, 45, 47),
        filled: true,
        prefixIcon: Icon(
          prefix,
          color: Colors.white.withOpacity(.5),
        ),
        prefixIconColor: Colors.white,
        suffixIcon: suffix,
      ),
      obscureText: obscureText,
      enableSuggestions: suggestions,
      onChanged: onChanged,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      textInputAction: isLast ? TextInputAction.go : TextInputAction.next,
    );
  }
}
